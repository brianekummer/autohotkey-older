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
  Define global variables 
*/
global SlackStatusUpdate_MySlackTokens
global SlackStatusUpdate_SlackStatuses


/*
  PUBLIC - Initialize global variables from Windows environment variables
*/
SlackStatusUpdate_Initialize() 
{
  global SlackStatusUpdate_MySlackTokens
  global SlackStatusUpdate_SlackStatuses

  ; Variables are read from environment variables, see "Slack Status Update Config.bat" for more details
  slackTokens := EnvGet("SLACK_TOKENS")
  SlackStatusUpdate_MySlackTokens := StrSplit(slackTokens, "|")

  global SlackStatusUpdate_SlackStatuses := Map(
    "none", SlackStatusUpdate_BuildSlackStatus("", "|", 0),
    "meeting", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_MEETING", "In a meeting|:spiral_calendar_pad:", 0), 
    "workingInOffice", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_WORKING_OFFICE", "In the office|:cityscape:", 0), 
    "workingRemotely", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_WORKING_REMOTELY", "Working remotely|:house_with_garden:", 0),
    "vacation", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_VACATION", "Vacationing|:palm_tree:", 0), 
    "lunch", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_LUNCH", "At lunch|:hamburger:", 0), 
    "dinner", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_DINNER", "At dinner|:poultry_leg:", 0), 
    "brb", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_BRB", "Be Right Back|:brb:", 0), 
    "playing", SlackStatusUpdate_BuildSlackStatus("SLACK_STATUS_PLAYING", "Playing|:8bit:", 0)
  )
}


/*
  PUBLIC - Set Slack status, based on what wifi networks are available to the user. I can be connected to a network
           by a wired ethernet cable in the office or at home, so looking at what wifi networks are nearby/available 
           seems like an accurate method of determining where I'm connected from.

           If I am on PTO, then don't change the status before the PTO status expires.
*/
SlackStatusUpdate_SetSlackStatusBasedOnNetwork() 
{
  ; Get current Slack status (network errors are returned as emoji "???")
  mySlackStatusEmoji := SlackStatusUpdate_GetSlackStatusEmoji()
	While (mySlackStatusEmoji = "???") 
	{
	  Sleep(30000)
    mySlackStatusEmoji := SlackStatusUpdate_GetSlackStatusEmoji() 
	}

  slackMeetingEmoji := SlackStatusUpdate_SlackStatuses["meeting"].emoji
  slackVacationEmoji := SlackStatusUpdate_SlackStatuses["vacation"].emoji

	if (mySlackStatusEmoji = slackMeetingEmoji) 
	{
	  ; I'm in a meeting, and I ASSUME that my Outlook addin will change my status back when the meeting ends
	}
  else if (mySlackStatusEmoji = slackVacationEmoji) 
	{
	  ; I'm on PTO, and I ASSUME that my Outlook addin or JavaScript code set that status to have an expiration
	}
	else
	{
	  ; I'm not in a meeting, so we need to set my Slack status
		done := False
		Loop
		{
      if (ConnectedToInternet())
			{
			  ; I'm connected to a network
			  done := True
			  if (AmNearWifiNetwork(Configuration.Work.OfficeNetworks))
          SlackStatusUpdate_SetSlackStatus(SlackStatusUpdate_SlackStatuses["workingInOffice"])
				else
				  SlackStatusUpdate_SetSlackStatus(SlackStatusUpdate_SlackStatuses["workingRemotely"])
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
  https://www.autohotkey.com/board/topic/80587-how-to-find-internet-connection-status/
*/
ConnectedToInternet(flag := 0x40) { 
  return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0) 
}


/*
  Private - Build a slack status object by reading the environment variable envVarName. If this variable is blank or 
            not set, use the default value provided. 
              - The text obtained from the environment variable and/or defaultValue should be a pipe-delimited string 
                with the name and the emoji, such as "At lunch|:hamburger:". It does not matter the order of these.
*/
SlackStatusUpdate_BuildSlackStatus(envVarName, defaultValue, statusExpiration)
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
  Private - Sets my status in Slack via the Slack keyboard command "/status :emoji: :text:"
*/
SlackStatusUpdate_SetSlackStatusViaKeyboard(slackStatus)
{
  SendInput("/status " slackStatus.text " " slackStatus.emoji "{enter}")
}


/*
  Private - Get the name of the emoji for my current Slack status using the Slack web API

            Now that I have both a work and a personal Slack account, we're just getting the status of the first 
            (work) account.
*/
SlackStatusUpdate_GetSlackStatusEmoji() 
{
  try 
  {
	  webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
    webRequest.Open("GET", "https://slack.com/api/users.profile.get")
    webRequest.SetRequestHeader("Authorization", "Bearer " SlackStatusUpdate_MySlackTokens[1])
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
SlackStatusUpdate_SetSlackStatusAndPresence(slackStatusKey, presence := "") {
  SlackStatusUpdate_SetSlackStatus(SlackStatusUpdate_SlackStatuses[slackStatusKey])
  SlackStatusUpdate_SetPresence(presence)
}


/*
  TODO - add expiration
*/
SlackStatusUpdate_SetHomeSlackStatus(slackStatusKey) {
  ; Not necessary, but keeps AHK #warn happy
  ;if (!IsSet(slackStatusUpdate_MySlackTokens))
  ;  SlackStatusUpdate_Initialize()
  SlackStatusUpdate_SetSlackStatus(SlackStatusUpdate_SlackStatuses[slackStatusKey], [SlackStatusUpdate_MySlackTokens[2]])
}
SlackStatusUpdate_SetWorkSlackStatus(slackStatusKey) {
  ; Not necessary, but keeps AHK #warn happy
  ;if !IsSet(slackStatusUpdate_MySlackTokens)
  ;  SlackStatusUpdate_Initialize()
  SlackStatusUpdate_SetSlackStatus(SlackStatusUpdate_SlackStatuses.GetOwnPropDesc(slackStatusKey).Value, [SlackStatusUpdate_MySlackTokens[1]])
}


/*

*/
SlackStatusUpdate_SetSlackStatus(slackStatus, slackTokens := "") 
{
  if (!slackTokens)
  {
    slackTokens := SlackStatusUpdate_MySlackTokens
  }

  webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
  data := "profile={'status_text': '" slackStatus.text "', 'status_emoji': '" slackStatus.emoji "', 'status_expiration': " slackStatus.expiration "}"

  For i, thisToken in slackTokens
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
SlackStatusUpdate_SetPresence(presence, slackTokens := "")
{
  if (!slackTokens)
    slackTokens := SlackStatusUpdate_MySlackTokens

  webRequest := ComObject("WinHttp.WinHttpRequest.5.1")

  For i, thisToken in slackTokens
  {
    webRequest.Open("POST", "https://slack.com/api/users.setPresence?presence=" presence)
    webRequest.SetRequestHeader("Content-Type", "application/application/json")
    webRequest.SetRequestHeader("Authorization", "Bearer " thisToken)
    webRequest.Send("")
  }
}



;<<<<<<<<<<====================  Utility functions  ====================>>>>>>>>>>


/*
  Private - Run a DOS command. This code taken from AutoHotkey website: https://autohotkey.com/docs/commands/Run.htm
*/
SlackStatusUpdate_RunWaitOne(command)
{
  shell := ComObject("WScript.Shell")      ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
  exec := shell.Exec(A_ComSpec " /C " command)  ; Execute a single command via cmd.exe
  return exec.StdOut.ReadAll()                ; Read and return the command's output 
}


/*
  Run a DOS command
*/
SlackStatusUpdate_RunWaitHidden(cmd)
{
	Sleep(250)                ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  clipSaved := ClipboardAll()	; Save the entire clipboard
  A_Clipboard := ""

	RunWait(cmd " | clip", , "hide")
  output := A_Clipboard
	
	Sleep(250)                ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  A_Clipboard := clipSaved	  ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  clipSaved := ""			          ; Free the memory in case the clipboard was very large

	return output
}




;<<<<<<<<<<====================  UNUSED CODE  ====================>>>>>>>>>>


/*
  UNUSED

  Private - Get my Slack status using the Slack web API

            I wrote this and then realized I didn't need it. It's good code, so I'm keeping it here in case I need
            it later.
*/
SlackStatusUpdate_GetSlackStatus(&statusText, &statusEmoji, &statusExpiration) 
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