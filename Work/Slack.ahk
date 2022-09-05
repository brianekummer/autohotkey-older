/**
 *  Slack functionality
 *
 *  Features
 *    - Set my Slack status based on my location 
 *    - Get the name of the emoji for my current Slack status
 *    - Run/activates Slack app
 *    - Functions to set a specific status
 *        - Working status selects between office/remote
 *        - Eating status selects between lunch and dinner
 * 
 *  Notes
 *    - Borrowed heavily from my Hammerspoon script for the Mac:
 *      https://github.com/brianekummer/hammerspoon/blob/master/my-slack.lua
 * 
 *  Dependencies
 *    - Utilities.AmConnectedToInternet()
 *    - Utilities.AmAtOffice()
 *    - Environment variables          ; See "Configure.bat" for details
 *        AHK_SLACK_TOKENS             ; Assumes 1st token is always work, 2nd is home
 */


class Slack {
  /**
   *  Constructor that initializes variables
   */
   __New() {
    this.Tokens := StrSplit(EnvGet("AHK_SLACK_TOKENS"), "|")

    this.Statuses := Map(
      "none", this.BuildStatus("", "|", 0),
      "meeting", this.BuildStatus("SLACK_STATUS_MEETING", "Meeting|:spiral_calendar_pad:", 0), 
      "workingInOffice", this.BuildStatus("SLACK_STATUS_WORKING_OFFICE", "Office|:cityscape:", 0), 
      "workingRemotely", this.BuildStatus("SLACK_STATUS_WORKING_REMOTELY", "Working remotely|:house_with_garden:", 0),
      "vacation", this.BuildStatus("SLACK_STATUS_VACATION", "Vacationing|:palm_tree:", 0), 
      "lunch", this.BuildStatus("SLACK_STATUS_LUNCH", "Lunch|:hamburger:", 0), 
      "dinner", this.BuildStatus("SLACK_STATUS_DINNER", "Dinner|:poultry_leg:", 0), 
      "brb", this.BuildStatus("SLACK_STATUS_BRB", "Be Right Back|:brb:", 0), 
      "playing", this.BuildStatus("SLACK_STATUS_PLAYING", "Playing|:8bit:", 0)
    )
  }
  




  /******************************  Public Methods  ******************************/



  /**
   *  Sets my Slack status, based on my location
   * 
   *  I can be connected to a network by a wired ethernet cable in the office or at home, so looking at what wifi
   *  networks are nearby/available seems like an accurate method of determining where I'm located.
   *
   *  If I am on PTO, then don't change the status before the PTO status expires.
   */
  SetStatusBasedOnLocation() {
    ; Get current Slack status (network errors are returned as emoji "???")
    currentEmoji := this.GetStatusEmoji()
    while (currentEmoji = "???") {
      Sleep(30000)
      currentEmoji := this.GetStatusEmoji() 
    }

    meetingEmoji := this.Statuses["meeting"].emoji
    vacationEmoji := this.Statuses["vacation"].emoji

    if (currentEmoji = meetingEmoji) {
      ; I'm in a meeting, and I ASSUME that my Outlook addin will change my status back when the meeting ends
    } else if (currentEmoji = vacationEmoji) {
      ; I'm on PTO, and I ASSUME that my Outlook addin or JavaScript code set that status to have an expiration
    } else {
      ; I'm not in a meeting, so we need to set my Slack status
      done := False
      loop {
        if (AmConnectedToInternet()) {
          ; I'm connected to a network
          done := True
          ;if (AmAtOffice())
          ;  this.SetStatus(this.Statuses["workingInOffice"])
          ;else
          ;  this.SetStatus(this.Statuses["workingRemotely"])
          this.SetStatusWorking()
        } else {
          ; Wait for 30 seconds and check again
          Sleep(30000)
        }
      }
      until done
    }
  }


  /**
   *  Gets the name of the emoji for my current Slack status
   *
   *  Now that I have both a work and a personal Slack account, we're just getting the status of the first 
   *  (work) account.
   * 
   *  @return                    The emoji for my current Slack status
   */
  GetStatusEmoji() {
    try {
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
    } catch {
      statusEmoji := "???"
    }

    return statusEmoji
  }
  

  /**
   *  Runs or activates Slack app
   * 
   *  @param shortcut            The shortcut key to send to the Slack app after it is run or activated
   */
   RunOrActivateSlack(shortcut := "") {
    RunOrActivateApp("ahk_exe slack.exe", Configuration.WindowsLocalAppDataFolder "\Slack\Slack.exe")
    if (shortcut != "") {
      SendInput(shortcut)
    }
  }


  /**
   *  Simple functions to set a specific status
   */
  SetStatusPlaying()     => this.SetSlackHomeStatusAndPresence("playing", "auto")
  SetStatusNone()        => this.SetStatusAndPresence("none", "auto")
  SetStatusMeeting()     => this.SetSlackWorkStatusAndPresence("meeting", "auto")
  SetStatusBeRightBack() => this.SetSlackWorkStatusAndPresence("brb", "away")
  SetStatusVacation()    => this.SetSlackWorkStatusAndPresence("vacation", "away")



  /**
   *  Sets my status to either working in the office or working remotely
   */
  SetStatusWorking() {
    if AmAtOffice() {
      this.SetSlackWorkStatusAndPresence("workingInOffice", "auto")
    } else {
      this.SetSlackWorkStatusAndPresence("workingRemotely", "auto")
    }
  }

  
  /**
   *  Sets my status to either lunch or dinner, depending on the current time
   * 
   *  @param lunchIsBeforeHour   Any time before this hour is considered lunch
   */
  SetStatusEating(lunchIsBeforeHour) {
    if (A_Hour < lunchIsBeforeHour) {
      this.SetSlackWorkStatusAndPresence("lunch", "away")
    } else {
      this.SetSlackWorkStatusAndPresence("dinner", "away")
    }
  }


  


  /******************************  Private Methods  ******************************/



  /**
   *  Builds a slack status object
   * 
   *  Reads the environment variable envVarName
   *    - If that variable is blank or not set, use the default value provided
   *    - The text obtained from the environment variable and/or defaultValue should be a pipe-delimited string 
   *      with the name and the emoji, such as "At lunch|:hamburger:". It does not matter the order of these.
   *  @param envVarName          The name of the environment variable 
   *  @param defaultValue        Default value to use if the environment variable is empty
   *  @param statusExpiration    The expiration of this status- as an integer specifying seconds since the epoch, 
   *                             more commonly known as "UNIX time". When 0 or omitted, the status does not expire.
   *  @return                    A Slack status object with the text, emoji, and expiration 
   */
  BuildStatus(envVarName, defaultValue, statusExpiration) {
    slackStatus := EnvGet(envVarName)
    
    if (slackStatus = "") {
      slackStatus := defaultValue
    }

    parts := StrSplit(slackStatus, "|")
    slackStatus := RegExMatch(parts[1], "^:.*:$")
      ? { text: parts[2], emoji: parts[1], expiration: statusExpiration}
      : { text: parts[1], emoji: parts[2], expiration: statusExpiration}
    
    return slackStatus
  }


  /**
   *  Sets my Slack status
   *
   *  Now I have a work and a personal Slack account, so I have two Slack tokens. So we'll loop through them
   *  and send the status update to both.
   * 
   *  @param newStatusKey        The status key of the new status (the key from this.Statuses)
   *  @param newPresence         The new presence (auto|away)
   */
  SetStatusAndPresence(newStatusKey, newPresence := "") {
    this.SetStatus(this.Statuses[newStatusKey])
    this.SetPresence(newPresence)
  }


  /**
   *  Set Slack status for home and away
   * 
   *  @param newStatusKey        The status key of the new status (the key from this.Statuses)
   */
  SetSlackHomeStatusAndPresence(newStatusKey, newPresence := "") {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[2]])
    this.SetPresence(newPresence, [this.Tokens[2]])
  }
  SetSlackWorkStatusAndPresence(newStatusKey, newPresence := "") {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[1]])
    this.SetPresence(newPresence, [this.Tokens[1]])
  }
  

  /**
   *  Sets my Slack status for one or more accounts
   * 
   *  @param newStatus           The status object of the new status, contains properties text, emoji, expiration
   *  @param tokens              The array of tokens for my Slack accounts. Defaults to all my accounts.
   */
  SetStatus(newStatus, tokens := this.Tokens) {
    webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
    data := "profile={'status_text': '" newStatus.text "', 'status_emoji': '" newStatus.emoji "', 'status_expiration': " newStatus.expiration "}"

    for i, thisToken in tokens {
      webRequest.Open("POST", "https://slack.com/api/users.profile.set")
      webRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
      webRequest.SetRequestHeader("Authorization", "Bearer " thisToken)
      webRequest.Send(data)
    }
  }


  /**
   *  Set presence for for one or more accounts
   * 
   *  @param newPresence         The new presence (auto|away)
   *  @param tokens              The array of tokens for my Slack accounts. Defaults to all my accounts.
   */
  SetPresence(newPresence, tokens := this.Tokens) {
    if (StrLen(newPresence) > 0) {
      webRequest := ComObject("WinHttp.WinHttpRequest.5.1")

      for i, thisToken in tokens {
        webRequest.Open("POST", "https://slack.com/api/users.setPresence?presence=" newPresence)
        webRequest.SetRequestHeader("Content-Type", "application/application/json")
        webRequest.SetRequestHeader("Authorization", "Bearer " thisToken)
        webRequest.Send("")
      }
    }
  }



  

  /******************************  Unused Code  ******************************/



  /**
   *  Sets my status in Slack via the Slack keyboard command "/status :emoji: :text:"
   *  @param newStatus       The status object of the new status, contains properties text, emoji, expiration
   */
  SetStatusViaKeyboard(newStatus) {
    SendInput("/status " newStatus.text " " newStatus.emoji "{enter}")
  }


  /**
   *  Gets my Slack status using the Slack web API
   *  
   *  CURRENTLY UNTESTED
   * 
   *  I wrote this and then realized I didn't need it. It's good code, so I'm keeping it here in case I need
   *  it later.
   * 
   *  @param statusText         ByRef- The status text
   *  @param statusEmoji        ByRef- The status emoji
   *  @param statusExpiration   ByRef- The status expiration
   */
  GetStatus(&statusText, &statusEmoji, &statusExpiration) {
    try {
      ;webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
      ;webRequest.Open("GET", "https://slack.com/api/users.profile.get?token=" SlackStatusUpdate_MySlackTokens)
      ;webRequest.Send()
      ;results := webRequest.ResponseText
      
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
      ;RegExMatch(results, '\"status_text\"\s*:\s*\"(.+?)\s*\"', statusText)
      ;RegExMatch(results, '\"status_emoji\"\s*:\s*\"(.+?)\s*\"', statusEmoji)
      ;RegExMatch(results, '\"status_expiration\"\s*:\s*(\d+)?', statusExpiration)
    } catch {
      ;statusText := "???"
      ;statusEmoji := "???"
      ;statusExpiration := "???"
    }
  }
}