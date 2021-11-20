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
;     - 
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


#NoEnv
#Persistent
#SingleInstance, force
;#InstallKeybdHook ; "physical state of a key or mouse button will usually be the same as the logical state unless the keyboard and/or mouse hooks are installed"
SendMode Input


RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


;***** BROWSER *****
F20 & b::
    msgbox "Browser"
    return

;***** SLACK *****
F20 & k::
  If GetKeyState("Ctrl", "P")      ; Ctrl is pressed
    msgbox "Slack - jump"
  Else
    msgbox "Slack"
  return

