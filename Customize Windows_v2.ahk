;--------------------------------------------------------------------------------------------------
; Customizing Windows
;--------------------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------------------------------------
; Minimize the active window. This overrides the existing Windows hotkey that:
;   - First time you use it, un-maximizes (restores) the window
;   - Second second time you use it, it minimizes the window
;---------------------------------------------------------------------------------------------------------------------
#down::WinMinimize("A")


;--------------------------------------------------------------------------------------------------
;  CapsLock processing.  Double tap CapsLock to toggle CapsLock mode on or off.
;
;  https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
;
;  DO I EVEN WANT THIS? OR IS IT JUST SOMETHING I'LL MESS UP WITH? JUST HOLD DOWN SHIFT??
;--------------------------------------------------------------------------------------------------
;CapsLock::
;{
;  KeyWait, CapsLock                                                   ; Wait forever until Capslock is released.
;  KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
;  If ((ErrorLevel = 0) && (A_PriorKey = "CapsLock") )                 ; Is a double tap on CapsLock?
;  {
;    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"    ; Toggle the state of CapsLock LED
;  }
;  Return
;}

; If don't want the above, then disable CapsLock using below
CapsLock:: Return



;---------------------------------------------------------------------------------------------------------------------
; Extra mouse buttons
;   - I have a Logitech M510 5 button mouse
;   - XButton1 (front button) minimizes the current window
;   - XButton2 (rear button) depending on the active window, closes the active TAB/WINDOW, or minimizes or closes the 
;     active APPLICATION.
;
; This is based on the name of app/process, NOT the window title, or else it would minimize a browser with a tab whose
; title is "How to Use Slack".  Also, Microsoft Edge browser is more complex than a single process, so detecting it is
; more complex.
;---------------------------------------------------------------------------------------------------------------------
#HotIf !WinActive("ahk_exe parsecd.exe", )
  xbutton1::
  {
    WinMinimize("A")
	  Return
  }

  xbutton2::
  {
    processName := WinGetProcessName("A")
    SplitPath(processName, , , , &processNameNoExtension)

    If RegExMatch(processNameNoExtension, "i)skype|outlook|wmplayer|slack|typora") 
    or WinActive("iHeartRadio ahk_exe i)ApplicationFrameHost.exe")
    {
	    WinMinimize("A")     ; Do not want to close these apps
    }
    Else If RegExMatch(processNameNoExtension, "i)chrome|iexplore|firefox|notepad++|ssms|devenv|eclipse|winmergeu|robo3t|code|idea64") 
    or WinActive("ahk_exe msedge.exe")
    {
      SendInput("^{f4}")    ; Close a WINDOW/TAB/DOCUMENT
    }
    Else
    {
      SendInput("!{f4}")    ; Close the APP
    }
    Return
  }
#HotIf !WinActive(, )


;---------------------------------------------------------------------------------------------------------------------
; Mouse media controls
;   â‡ª mouse wheel        Volume down/up
;   â‡ª LButton            Play/pause
;   â‡ª RButton            Music app (Spotify)
;   â‡ª XButton1           Previous track
;   â‡ª XButton2           Next track
;---------------------------------------------------------------------------------------------------------------------
#HotIf IsWorkLaptop
  CapsLock & wheelup::     SendMediaKey("{Blind}{Volume_Up 1}")
  CapsLock & wheeldown::   SendMediaKey("{Blind}{Volume_Down 1}")
  CapsLock & LButton::     SendMediaKey("{Blind}{Media_Play_Pause}")
  CapsLock & RButton::     RunSpotifyByMediaKey()
  CapsLock & XButton1::    SendMediaKey("{Blind}{Media_Prev}")
  CapsLock & XButton2::    SendMediaKey("{Blind}{Media_Next}")
#HotIf


SendMediaKey(mediaKey)
{
  SendInput mediaKey
  FixBrokenCapsLock()
}

RunSpotifyByMediaKey()
{
  RunOrActivateSpotify()
  FixBrokenCapsLock()
}

/*
   I have problems with CapsLock sometimes getting stuck
*/
FixBrokenCapsLock()
{
  if (GetKeyState("CapsLock"))    ; Does it matter if I use "P", "T", or no 2nd param?
  {
    ; Both of these commands seem to fix my problem
    SetCapsLockState("AlwaysOff")  ; Disable the CapsLock LED on my keyboard
    ; Reload                       ; I don't like this because it loses static variables like used by ConvertCase

    ; These do not fix the problem
    ;Send "{Blind}{CapsLock up}"
    ;Send "{CapsLock up}"
  }
  Return
}