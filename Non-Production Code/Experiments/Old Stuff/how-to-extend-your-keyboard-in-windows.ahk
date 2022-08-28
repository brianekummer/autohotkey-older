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
;   https://dev.to/coding_with_ju/how-to-extend-your-keyboard-in-windows-4399
;
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




; https://dev.to/coding_with_ju/how-to-extend-your-keyboard-in-windows-4399

#Persistent
SetCapsLockState, AlwaysOff



RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


; Caps Lock Disable
capslock::return
; Caps Lock with shift+caps
+Capslock::
If GetKeyState("CapsLock", "T") = 1
  SetCapsLockState, AlwaysOff
Else
  SetCapsLockState, AlwaysOn
Return

Capslock & c::send, ^c

;CapsLock & h::Left
;CapsLock & j::Down
;CapsLock & k::Up
;CapsLock & l::Right




;***** BROWSER *****
CapsLock & b::
   msgbox "Browser"
   return

;***** SLACK *****
CapsLock & k::
If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
  msgbox "Slack - jump"
Else
  msgbox "Slack"
return