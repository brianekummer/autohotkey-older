/**
 *  Mute VOIP Apps
 * 
 *  My home-grown solution that cobbles together various bits of code I found online
 * 
 *  Notes
 *  - I usually have both Slack and Teams open at the same time
 * 
 *  Dependencies
 *    - Utilities.ActivateWindowByIdAndSendKeystroke()
 */


/**
 *  Toggles the mute of the currently active VOIP app
 */
ToggleMuteVOIPApps() {
  ; Slack call
  if (ActivateWindowByIdAndSendKeystroke(GetSlackCallWindowId(), "m")) {
    return
  }

  ; Slack huddle
  if (ActivateWindowByIdAndSendKeystroke(GetSlackHuddleWindowId(), "^+{space}")) {
    return
  }

  ; Zoom
  if (ActivateWindowByIdAndSendKeystroke(GetZoomMeetingWindowId(), "!a")) {
    return
  }

  ; Google Meet, in a Chrome tab
  if (ActivateWindowByIdAndSendKeystroke(GetGoogleMeetWindowId(), "^d")) {
    return
  }

  ; Microsoft Teams
  if (ActivateWindowByIdAndSendKeystroke(GetTeamsMeetingWindowId(), "^+m")) {
    return
  }

  MsgBox("Muting NOTHING")
}


/**
 *  Gets the window id of the active Teams meeting, if there is one
 * 
 *  Notes
 *    - Make sure title is not the notification
 *    - The screen sharing window uses null title, so make sure that the window does not have a null title
 *    - I have no idea why other window(s?) end with "[QSP]", but the meeting window does not (as of Oct 2021)
 *    - I tried to simplify the logic using a single regex, but doing NOTs in regex is igly, and excluding the
 *      null title made this very confusing.  This code is MUCH simpler to understand.
 *
 *  @return       The window id of the active Teams meeting, else returns ""
 */
GetTeamsMeetingWindowId() {
  oid := WinGetList("ahk_exe Teams.exe",,,)
  aid := Array()
  ;id := oid.Length   ; TODO- uncomment if this is actually necessary

  for v in oid {
    aid.Push(v)
  }
  
  loop aid.Length {
    thisId := aid[A_Index]
    title := WinGetTitle("ahk_id " thisId)
    
    if (title != "Microsoft Teams Notification") && (title != "") && (!RegExMatch(title, "\[QSP\]$")) {
      return thisId
    }
  }
  
  ;return     ; I suspect this is useless
}


/**
 *  Gets the window id of the active Slack call, if there is one
 * 
 *  Since I don't believe I can get multiple windows, I think using WinGetID is sufficient code is unnecessary.
 *  If that ever changes, the following code may be helpful:
 *    WinGet, callWindowIds, List, Slack call with .* \| \d+:\d\d
 *    windowId := callWindowIds1     ; Return 1st matching window
 *
 *  @return       The window id of the active Slack call, else returns ""
 */
GetSlackCallWindowId() {
  try {
    windowId := WinGetID("Slack call with .* \| \d+:\d\d")
  } catch TargetError as err {
    windowId := 0
  }

  return windowId
}


/**
 *  Gets the window id of the active Slack huddle, if there is one
 *  
 *  Since I don't believe I can get multiple windows, I think using WinGetID is sufficient code is unnecessary.
 *  If that ever changes, the following code may be helpful:
 *    WinGet, huddleWindowIds, List, (.* screen share)
 *    windowId := huddleWindowIds1    ; Return 1st matching window
 * 
 *  @return       The window id of the active Slack huddle, else returns ""
 */
GetSlackHuddleWindowId() {
  try {
    windowId := WinGetID("(.* screen share)")
  } catch TargetError as err {
    windowId := 0
  }

  return windowId
}


/**
 *  Gets the window id of the active Zoom meeting, if there is one
 *  
 *  @return       The window id of the active Zoom meeting, else returns ""
 */
GetZoomMeetingWindowId() {
  try {
    windowId := WinGetID("ahk_class ZPContentViewWndClass")
  } catch TargetError as err {
    windowId := 0
  }

  return windowId
}


/**
 *  Gets the window id of the active Google Meet, if there is one
 *
 *  This does NOT search through all the open Chrome tabs, but if the Meet is the active tab in any instance of 
 *  Chrome, then this code finds it.
 * 
 *  @return       The window id of the active Google Meet, else returns ""
 */
GetGoogleMeetWindowId() {
  try {
    windowId := WinGetID("Meet - \w{3}\-\w{4}\-\w{3} \- Google Chrome")
  } catch TargetError as err {
    windowId := 0
  }

  return windowId
}