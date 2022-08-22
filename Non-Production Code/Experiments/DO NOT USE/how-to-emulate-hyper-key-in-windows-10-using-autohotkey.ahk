;====================================
; AHK research for Hyperkey
;
; POC
;   - H + K        = Slack
;   - H + Ctrl + K = Slack jump
;   - H + B        = Browser
;
; TESTING
;   - Does it work in browser?
;   - Does it work in VS Code?
;   - Does it bring up MS office (Win + Ctrl +Alt + Shift + Y = yammer)
;   - Can Ctrl and Shift work?
;   - Can I make Win work with it (bonus, not required)
;   - Does caps lock key sometimes get stuck on/off?
;
; WHERE IS THIS FROM?
;   https://stackoverflow.com/questions/40435980/how-to-emulate-hyper-key-in-windows-10-using-autohotkey
;
; WHAT WORKS AND FAILS?
;   WORKS
;     - In browser
;     - When VS Code has focus and you can enter text- fixed by using RunAsAdmin()
;   FAILS
;     - All sorts of issues with MS Office hot key 
;
;
; CODE
;   ;***** BROWSER *****
;   F20 & b::
;      msgbox "Browser"
;      return
;
;   ;***** SLACK *****
;   F20 & k::
;   If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
;     msgbox "Slack - jump"
;   Else
;     msgbox "Slack"
;  return
;====================================






; https://stackoverflow.com/questions/40435980/how-to-emulate-hyper-key-in-windows-10-using-autohotkey

#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force

SendMode Input



RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


;; deactivate capslock completely
SetCapslockState, AlwaysOff

;; remap capslock to hyper
;; if capslock is toggled, remap it to esc

;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; must use downtemp to emulate hyper key, you cannot use down in this case 
    ;; according to http://bit.ly/2fLyHHI, downtemp is as same as down except for ctrl/alt/shift/win keys
    ;; in those cases, downtemp tells subsequent sends that the key is not permanently down, and may be 
    ;; released whenever a keystroke calls for it.
    ;; for example, Send {Ctrl Downtemp} followed later by Send {Left} would produce a normal {Left}
    ;; keystroke, not a Ctrl{Left} keystroke
    Send {Ctrl DownTemp}{Shift DownTemp}{Alt DownTemp}{LWin DownTemp}
    KeyWait, Capslock
    Send {Ctrl Up}{Shift Up}{Alt Up}{LWin Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

;; vim navigation with hyper
;~Capslock & h:: Send {Left}
;~Capslock & l:: Send {Right}
;~Capslock & k:: Send {Up}
;~Capslock & j:: Send {Down}

;; popular hotkeys with hyper
;~Capslock & c:: Send ^{c}
;~Capslock & v:: Send ^{v}


#^!+W::
Send ^!+W
return

#^!+Y:: 
Send ^!+Y
return



;***** BROWSER *****
Capslock & b::
   msgbox "Browser"
   return

;***** SLACK *****
Capslock & k::
If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
  msgbox "Slack - jump"
Else
  msgbox "Slack"
return
