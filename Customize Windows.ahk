;--------------------------------------------------------------------------------------------------
; Customizing Windows
;--------------------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------------------------------------
; Minimize the active window. This overrides the existing Windows hotkey that:
;   - First time you use it, un-maximizes (restores) the window
;   - Second second time you use it, it minimizes the window
;---------------------------------------------------------------------------------------------------------------------
#down::  WinMinimize, A


;--------------------------------------------------------------------------------------------------
;  CapsLock processing.  Double tap CapsLock to toggle CapsLock mode on or off.
;
;  https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
;
;  DO I EVEN WANT THIS? OR IS IT JUST SOMETHING I'LL MESS UP WITH? JUST HOLD DOWN SHIFT??
;--------------------------------------------------------------------------------------------------
;CapsLock::
;  KeyWait, CapsLock                                                   ; Wait forever until Capslock is released.
;  KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
;  If ((ErrorLevel = 0) && (A_PriorKey = "CapsLock") )                 ; Is a double tap on CapsLock?
;  {
;    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"    ; Toggle the state of CapsLock LED
;  }
;  Return

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
xbutton1::
  WinMinimize, A
	Return

xbutton2::
  WinGet, processName, ProcessName, A
  SplitPath, processName,,,, processNameNoExtension

  If RegExMatch(processNameNoExtension, "i)skype|outlook|wmplayer|slack|typora") 
    or WinActive("iHeartRadio ahk_exe i)ApplicationFrameHost.exe")
  {
	WinMinimize, A     ; Do not want to close these apps
  }
  Else If RegExMatch(processNameNoExtension, "i)chrome|iexplore|firefox|notepad++|ssms|devenv|eclipse|winmergeu|robo3t|code|idea64") 
    or WinActive("ahk_exe msedge.exe")
  {
    SendInput ^{f4}    ; Close a WINDOW/TAB/DOCUMENT
  }
  Else
  {
    SendInput !{f4}    ; Close the APP
  }
  Return


;---------------------------------------------------------------------------------------------------------------------
; Mouse media controls
;   ⇪ mouse wheel        Volume down/up
;   ⇪ LButton            Play/pause
;   ⇪ RButton            Music app (Spotify)
;   ⇪ XButton1           Previous track
;   ⇪ XButton2           Next track
;---------------------------------------------------------------------------------------------------------------------
CapsLock & wheelup::  	 SendInput {Blind}{Volume_Up 1}
CapsLock & wheeldown::   SendInput {Blind}{Volume_Down 1}
CapsLock & LButton::     SendInput {Blind}{Media_Play_Pause}
CapsLock & RButton::     RunOrActivateSpotify()
CapsLock & XButton1::    SendInput {Blind}{Media_Prev}
CapsLock & XButton2::    SendInput {Blind}{Media_Next}


; I wanted a toggle, but I couldn't find a way to determine the current setting. Could just toggle a varaible and it might be
; out of sync the first time.
^#pause::                SwitchAudioOutput("Headphones")    ; ^numlock = ^pause
^#numpadsub::            SwitchAudioOutput("Headset")
