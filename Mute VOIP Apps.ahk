; TEAMS TEST CASES
;   1. PASSED- Not in a call, just have calendar open
;   2. PASSED- In a mtg like standup, with no screen sharing
;   3. PASSED- In a planned mtg with screen share, like preplanning, etc
;   4. PASSED- 1-on-1 with BA, he sharing
;   5. 1-on-1 with BA, I'm sharing
;
; IMPROVEMENTS
;   - Can I used FindText to determine if there is a "Leave" button?
;
; CAN I DETERMINE WHAT STATUS OF MUTE IS?
;   - Use ImageSearch to look for muted or unmuted icon
;
; ONCE I get this working wire it up to
;   - the play/pause media key on my headset which will be great
;   - Looks like headset doesn't always send {Media_Play_Pause}, 
;     AND it sends WM_APPCOMMAND every OTHER time... not sure how to fix this
;   - Does this work better as headphones instead of headset?
;     It needs to work as headset, but might help troubleshoot
;
;
;
; SLACK INFO
;
; WHERE DOES THIS GO? REGULAR CALL, OR HUDDLE?
;   - When I'm presenting, is a little window with mute button and "Stop Sharing" button. Title is simply "Slack"
;
;
;   - Not on a call, window title is "Slack | <channel name> | teletracking"
;   - Regular slack call, can do this with home account (unpaid)
;       - Window titles
;          - Audio only: "Slack | Slack call with xxxxx | m:ss"
;          - When other side sharing: "Slack | Slack call with xxxxx | m:ss"
;          - When I'm sharing: xxxxxxxxxxxxxxxxx
;       - Mute by "SendInput m"
;   - Huddles, requires paid account
;       - WIndow titles
;          - Audio only: xxxxxxxxxxxxxxxxx
;          - When other side sharing: "Kiran Jaghni screen share"
;          - When I'm sharing: xxxxxxxxxxxxxxxxx
;       - Mute by "SendInput ^+{space}", works if on Slack main window or screen share window has focus
;
; SLACK TEST CASES
;   1. Not in a call, not in a huddle, Slack not open
;   2. Not in a call, not in a huddle, Slack is open
;   3. In a huddle, audio only
;   4. In a huddle, someone sharing screen
;   5  In a huddle, I'm sharing screen
;   6. On a call with BA, he sharing
;   7. On a call with BA, I'm sharing
;
; IMPROVEMENTS
;   - Can I used FindText to determine if there is a "Leave" button?
;
; CAN I DETERMINE WHAT STATUS OF MUTE IS?
;   - Use ImageSearch to look for muted or unmuted icon
;   - Is it worth the amount of work?
;
;
;
; GOOGLE MEET (in a Chrome tab)
; Window title: "Meet - xxx-xxxx-xxx - Google Chrome"
; ctrl-d to mute
; Does NOT search through open tabs. But if the Meet is the active tab in any instance of Chrome, then it finds it
ToggleMuteVOIPApps() {
  ; Slack call
  If ActivateWindowByIdAndSendKeystroke(GetSlackCallWindowId(), "m")
    Return

  ; Slack huddle
  If ActivateWindowByIdAndSendKeystroke(GetSlackHuddleWindowId(), "^+{space}")
    Return

  ; Zoom
  If ActivateWindowByIdAndSendKeystroke(GetZoomMeetingWindowId(), "!a")
    Return

  ; Google Meet, in a Chrome tab
  If ActivateWindowByIdAndSendKeystroke(GetGoogleMeetWindowId(), "^d")
    Return

  ; Microsoft Teams
  If ActivateWindowByIdAndSendKeystroke(GetTeamsMeetingWindowId(), "^+m")
    Return

  MsgBox Muting NOTHING
}

GetTeamsMeetingWindowId() {
  ; Make sure title is not the notification
  ; Screen sharing window uses null title, make sure the win does not have a null title
  ; No idea why other window(s?) end with "[QSP]"", but the meeting window does not (as of Oct 2021)
  ;
  ; I tried to simplify this using a single regex, but doing NOT is ugly in regex, and excluding the
  ; null title made this very confusing. This code is MUCH simpler.
  WinGet, id, List, ahk_exe Teams.exe
  Loop, %id%
  {
    thisId := id%A_Index%
    WinGetTitle, title, ahk_id %thisId%
    
    If (title <> Microsoft Teams Notification) And (title <> "") And (Not RegExMatch(title, "\[QSP\]$"))
    {
      ;msgbox TEAMS Window: %title%
      Return %thisId%
    }
  }
  
  Return
}
GetSlackCallWindowId() {
  WinGet, windowId, ID, Slack call with .* \| \d+:\d\d
  ; I don't believe I can get multiple windows, so I think this code is unnecessary
  ;WinGet, callWindowIds, List, Slack call with .* \| \d+:\d\d
  ;windowId := callWindowIds1    ; Return 1st matching window
  Return windowId
}
GetSlackHuddleWindowId() {
  WinGet, windowId, ID, (.* screen share)
  ; I don't believe I can get multiple windows, so I think this code is unnecessary
  ;WinGet, huddleWindowIds, List, (.* screen share)
  ;windowId := huddleWindowIds1    ; Return 1st matching window
  Return windowId
}
GetZoomMeetingWindowId() {
  WinGet, windowId, ID, ahk_class ZPContentViewWndClass
  Return windowId
}
GetGoogleMeetWindowId() {
; Does NOT search through open tabs. But if the Meet is the active tab in any instance of Chrome, then it finds it
  WinGet, windowId, ID, Meet - \w{3}\-\w{4}\-\w{3} \- Google Chrome
  Return windowId
}
