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
;   https://github.com/AdamJel/win-capslock-usefull
;
; WHAT WORKS AND FAILS?
;   WORKS
;     -  In browser
;   FAILS
;     -  When VS Code has focus and you can enter text
;====================================






;
; Autohotkey script: CapsLock actually usefull!
;
; Summary:
; CapsLock             : Esc
; CapsLock + h/j/k/l   : arrows left/down/up/right, including most combos:
;                        - CapsLock + Shift
;                        - CapsLock + Shift + Alt
;                        - CapsLock + Shift + Ctrl
;                        - CapsLock + Shift + Ctrl + Alt
;                        - CapsLock + Ctrl
;                        - CapsLock + Ctrl + Win
;                        - CapsLock + Alt
;                        - CapsLock + Win
; CaspLock + n/m       : Home/End
; CaspLock + y/u       : PageUp/PageDown
; CaspLock + s/d/f/g   : Delete word-before/char-before/char-after/word-after
; CapsLock + i/p       : Insert/PrintScreen
; CapsLock + 1/../0/=  : F1/../F10/F12  (F11 TO-DO), supports:
;                        - CapsLock + Ctrl + "="        : zoom in
;                        - CapsLock + Ctrl + Shitf + "=": zoom out
; CapsLock + w/e/r     : volume down/up/off




; Devel info:
; https://www.autohotkey.com/docs/KeyList.htm
;
; Win   = #
; Shift = +
; Ctrl  = ^
; Alt   = !
;
; & may be used between any two keys to combine them into a custom hotkey



; CapsLock Initializer
;--------------------------------------
SetCapsLockState, AlwaysOff




RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


; CapsLock Switcher
;--------------------------------------
CapsLock & t::
GetKeyState, CapsLockState, CapsLock, T
if CapsLockState = D
    SetCapsLockState, AlwaysOff
else
    SetCapsLockState, AlwaysOn
KeyWait, ``
return


; CapsLock = Esc
;--------------------------------------
CapsLock::Send, {ESC}



;***** BROWSER *****
CapsLock & b::
   msgbox "Browser"
   return

;***** SLACK *****
CapsLock & k::
  If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
  ;If GetKeyState("Ctrl") = 1      ; Ctrl is pressed
    msgbox "Slack - jump"
  Else
    msgbox "Slack"
  return



; CapsLock Media Controller
;--------------------------------------
CapsLock & r:: Send, {Volume_Mute}
CapsLock & w:: Send, {Volume_Down}
CapsLock & e:: Send, {Volume_Up}