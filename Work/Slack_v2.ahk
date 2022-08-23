
/*
; https://github.com/brianekummer/hammerspoon/blob/master/my-slack.lua

;***** TO DO
;   What do I want to do with Slack?
;     set status for x minutes (focus mode, studying)
;     set status no limit (lunch)
;     set home status (playing)
;     set presence (auto = when working, away = not sure when)
;     when log into laptop, look at network at clear slack away and set status 
;
;     when at work, and see Tele wifi, set status to 



;****** DEPENDENCIES
;   - Utilities.AmNearWifiNetwork()


;   1. Parse SLACK_TOKEN. Work is always FIRST
;   2. Make SlackStatusUpdate_GetSlackStatus do multiple accounts
;   3. Make SlackStatusUpdate_GetSlackStatusEmoji() do multiple accounts
;   4. Make SlackStatusUpdate_SetSlackStatus(slackStatus)  do multiple accounts
;   5. disable wifi stuff for Now


  Public Functions
    SlackStatusUpdate_Initialize
    SlackStatusUpdate_SetSlackStatusBasedOnNetwork() {
*/


/*
  DEPENDENCIES
     Utilities.AmConnectedToInternet()
     Utilities.RunOrActivateApp()
     Configuration.Work.OfficeNetworks
     Configuration.WindowsLocalAppDataFolder
*/


class Slack
{
  __New() 
  {
    this.Tokens := StrSplit(EnvGet("SLACK_TOKENS"), "|")

    this.Statuses := Map(
      "none", this.BuildStatus("", "|", 0),
      "meeting", this.BuildStatus("SLACK_STATUS_MEETING", "In a meeting|:spiral_calendar_pad:", 0), 
      "workingInOffice", this.BuildStatus("SLACK_STATUS_WORKING_OFFICE", "In the office|:cityscape:", 0), 
      "workingRemotely", this.BuildStatus("SLACK_STATUS_WORKING_REMOTELY", "Working remotely|:house_with_garden:", 0),
      "vacation", this.BuildStatus("SLACK_STATUS_VACATION", "Vacationing|:palm_tree:", 0), 
      "lunch", this.BuildStatus("SLACK_STATUS_LUNCH", "At lunch|:hamburger:", 0), 
      "dinner", this.BuildStatus("SLACK_STATUS_DINNER", "At dinner|:poultry_leg:", 0), 
      "brb", this.BuildStatus("SLACK_STATUS_BRB", "Be Right Back|:brb:", 0), 
      "playing", this.BuildStatus("SLACK_STATUS_PLAYING", "Playing|:8bit:", 0)
    )
  }
  

  /*
    PUBLIC - Set Slack status, based on what wifi networks are available to the user. I can be connected to a network
            by a wired ethernet cable in the office or at home, so looking at what wifi networks are nearby/available 
            seems like an accurate method of determining where I'm connected from.

            If I am on PTO, then don't change the status before the PTO status expires.
  */
  SetStatusBasedOnNetwork() 
  {
    ; Get current Slack status (network errors are returned as emoji "???")
    currentEmoji := this.GetStatusEmoji()
    While (currentEmoji = "???") 
    {
      Sleep(30000)
      currentEmoji := this.GetStatusEmoji() 
    }

    meetingEmoji := this.Statuses["meeting"].emoji
    vacationEmoji := this.Statuses["vacation"].emoji

    if (currentEmoji = meetingEmoji) 
    {
      ; I'm in a meeting, and I ASSUME that my Outlook addin will change my status back when the meeting ends
    }
    else if (currentEmoji = vacationEmoji) 
    {
      ; I'm on PTO, and I ASSUME that my Outlook addin or JavaScript code set that status to have an expiration
    }
    else
    {
      ; I'm not in a meeting, so we need to set my Slack status
      done := False
      Loop
      {
        if (AmConnectedToInternet())
        {
          ; I'm connected to a network
          done := True
          if (AmNearWifiNetwork(Configuration.Work.OfficeNetworks))
            this.SetStatus(this.Statuses["workingInOffice"])
          else
            this.SetStatus(this.Statuses["workingRemotely"])
        }
        else
        {
          ; Wait for 30 seconds and check again
          Sleep(30000)
        }
      }
      Until done
    }
  }


  /*
  Private - Build a slack status object by reading the environment variable envVarName. If this variable is blank or 
            not set, use the default value provided. 
              - The text obtained from the environment variable and/or defaultValue should be a pipe-delimited string 
                with the name and the emoji, such as "At lunch|:hamburger:". It does not matter the order of these.
  */
  BuildStatus(envVarName, defaultValue, statusExpiration)
  {
    slackStatus := EnvGet(envVarName)
    
    if (slackStatus = "") 
      slackStatus := defaultValue

    parts := StrSplit(slackStatus, "|")
    slackStatus := RegExMatch(parts[1], "^:.*:$")
      ? { text: parts[2], emoji: parts[1], expiration: statusExpiration}
      : { text: parts[1], emoji: parts[2], expiration: statusExpiration}
    
    return slackStatus
  }


  /*
    Private - Get the name of the emoji for my current Slack status using the Slack web API

              Now that I have both a work and a personal Slack account, we're just getting the status of the first 
              (work) account.
  */
  GetStatusEmoji() 
  {
    try 
    {
      webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
      webRequest.Open("GET", "https://slack.com/api/users.profile.get")
      webRequest.SetRequestHeader("Authorization", "Bearer " this.Tokens[1])
      webRequest.Send()
      results := webRequest.ResponseText

      ; The JSON returned by Slack will look something like this: 
      ;   ..."status_emoji":":house_with_garden:",... 
      ;   or
      ;   ..."status_emoji":"",...
      statusEmoji := SubStr(results, (InStr(results, "status_emoji"))<1 ? (InStr(results, "status_emoji"))-1 : (InStr(results, "status_emoji")))
      statusEmoji := SubStr(statusEmoji, 1, InStr(statusEmoji, ","))
      statusEmoji := RegExReplace(statusEmoji, 'i)(status_emoji|\"|,)')
      statusEmoji := RegExReplace(statusEmoji, "i)::", ":")
    }
    catch 
    {
      statusEmoji := "???"
    }
    return statusEmoji
  }


  /*
    Private - Set my Slack status via the Slack web API

              Now I have a work and a personal Slack account, so I have two Slack tokens. So we'll loop through them
              and send the status update to both.
  */
  SetStatusAndPresence(newStatusKey, newPresence := "") {
    this.SetStatus(this.Statuses[newStatusKey])
    this.SetPresence(newPresence)
  }


  /*
    TODO - add expiration
  */
  SetSlackHomeStatus(newStatusKey) {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[2]])
  }
  SetSlackWorkStatus(newStatusKey) {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[1]])
  }


  /*

  */
  SetStatus(newStatus, tokens := this.Tokens) 
  {
    ;if (!tokens)
    ;{
    ;  tokens := this.Tokens
    ;}

    webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
    data := "profile={'status_text': '" newStatus.text "', 'status_emoji': '" newStatus.emoji "', 'status_expiration': " newStatus.expiration "}"

    For i, thisToken in tokens
    {
      webRequest.Open("POST", "https://slack.com/api/users.profile.set")
      webRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
      webRequest.SetRequestHeader("Authorization", "Bearer " thisToken)
      webRequest.Send(data)
    }
  }


  /*
  Set presence for each of my Slack accounts
    presence must be "auto" or "away"
  */
  SetPresence(newPresence, tokens := this.Tokens)
  {
    webRequest := ComObject("WinHttp.WinHttpRequest.5.1")

    For i, thisToken in tokens
    {
      webRequest.Open("POST", "https://slack.com/api/users.setPresence?presence=" newPresence)
      webRequest.SetRequestHeader("Content-Type", "application/application/json")
      webRequest.SetRequestHeader("Authorization", "Bearer " thisToken)
      webRequest.Send("")
    }
  }



  /*
    
  */
  OpenSlackApp(shortcut := "")
  {
    RunOrActivateApp("ahk_exe slack.exe", Configuration.WindowsLocalAppDataFolder "\Slack\Slack.exe")
    if (shortcut != "")
      SendInput(shortcut)
  }


  /*

  */
  SetStatusEating(lunchIsBeforeHour)
  {
    ; MOVE THIS IF Statement into Slack project
    if (A_Hour < lunchIsBeforeHour)
      this.SetStatusAndPresence("lunch", "away")
    else
      this.SetStatusAndPresence("dinner", "away")
  }



  /*
  */
  SetStatusWorking()
  {
    if AmNearWifiNetwork(Configuration.Work.OfficeNetworks)
      this.SetStatusAndPresence("workingInOffice", "auto")
    else
      this.SetStatusAndPresence("workingRemotely", "auto")
  }


  

  /********** UNUSED CODE **********/

  /*
    Private - Sets my status in Slack via the Slack keyboard command "/status :emoji: :text:"
  */
  SlackStatusUpdate_SetSlackStatusViaKeyboard(slackStatus)
  {
    SendInput("/status " slackStatus.text " " slackStatus.emoji "{enter}")
  }

  /*
    UNUSED

    Private - Get my Slack status using the Slack web API

              I wrote this and then realized I didn't need it. It's good code, so I'm keeping it here in case I need
              it later.
  */
  GetStatus(&statusText, &statusEmoji, &statusExpiration) 
  {
    try 
    {
      webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
      ;webRequest.Open("GET", "https://slack.com/api/users.profile.get?token="SlackStatusUpdate_MySlackTokens)
      webRequest.Open("GET", "https://slack.com/api/users.profile.get?token=%SlackStatusUpdate_MySlackTokens%")
      webRequest.Send()
      results := webRequest.ResponseText
      
      ; The JSON returned by Slack will look something like this: 
      ;   ..."status_text":"Working remotely","status_emoji":":house_with_garden:","status_expiration":1535890000... 
      ;   or
      ;   ..."status:text":"","status_emoji":"","status_expiration:":0...

      ; OLD WORKING CODE
      ;V1: RegExMatch(results, """status_text""\s*:\s*\""(.+?)\s*""", stText)
      ;RegExMatch(results, '\"status_text\"\s*:\s*\"(.+?)\s*\"', stText)
      ;V1: RegExMatch(results, """status_emoji""\s*:\s*\""(.+?)\s*""", stEmoji)
      ;RegExMatch(results, '\"status_emoji\"\s*:\s*\"(.+?)\s*\"', stEmoji)
      ;V1: RegExMatch(results, """status_expiration""\s*:\s*(\d+)?", stExpiration)
      ;RegExMatch(results, '\"status_expiration\"\s*:\s*(\d+)?', stExpiration)
      ;statusText := stText1
      ;statusEmoji := stEmoji1
      ;statusExpiration := stExpiration1

      ; NEW UNTESTED CODE
      RegExMatch(results, '\"status_text\"\s*:\s*\"(.+?)\s*\"', statusText)
      RegExMatch(results, '\"status_emoji\"\s*:\s*\"(.+?)\s*\"', statusEmoji)
      RegExMatch(results, '\"status_expiration\"\s*:\s*(\d+)?', statusExpiration)
    }
    catch 
    {
      statusText := "???"
      statusEmoji := "???"
      statusExpiration := "???"
    }
  }
}