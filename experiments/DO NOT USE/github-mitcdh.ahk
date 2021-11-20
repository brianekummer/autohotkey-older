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
;   Me
;   Use PowerToys Keyboard Manager to map CapsLock to F20 and AHK to catch F20
;
; WHAT WORKS AND FAILS?
;   WORKS
;     - In browser
;     - When VS Code has focus and you can enter text- fixed by using RunAsAdmin()
;   FAILS
;     - Issues with MS Office key
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





; https://gist.github.com/mitcdh/33aaf96ce2636d0c9e8ed9473059fa93

;; based on @babygau's answer here https://stackoverflow.com/a/40559502
#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force

SendMode Input

;; deactivate capslock completely
SetCapslockState, AlwaysOff



RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk



;; remap capslock to hyper
;; if capslock is toggled, remap it to esc

;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; downtemp tells subsequent sends that the key is not permanently down, and may be released whenever a keystroke calls for it.
    Send {Ctrl DownTemp}{Shift DownTemp}{Alt DownTemp}{LWin DownTemp}
    KeyWait, Capslock
    Send {Ctrl Up}{Shift Up}{Alt Up}{LWin Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

;; vim navigation with hyper and additional modifiers
;~Capslock & h:: Send {Blind}{Left}
;~Capslock & l:: Send {Blind}{Right}
;~Capslock & k:: Send {Blind}{Up}
;~Capslock & j:: Send {Blind}{Down}

;; Hyper+c/v to copy/paste
~Capslock & c:: Send ^{c}
;;~Capslock & v:: Send ^{v} ;map to ditto instead

;; Hyper+a to set window to always on top
~Capslock & a:: Winset, Alwaysontop, , A

;# Also see this for disabling the hyper key launching office: https://superuser.com/questions/1455857/how-to-disable-office-key-keyboard-shortcut-opening-office-app




;***** BROWSER *****
~Capslock & b::
   msgbox "Browser"
   return

;***** SLACK *****
~Capslock & k::
If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
  msgbox "Slack - jump"
Else
  msgbox "Slack"
return


