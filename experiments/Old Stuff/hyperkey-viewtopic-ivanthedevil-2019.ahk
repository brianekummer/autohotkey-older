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
;   https://www.autohotkey.com/boards/viewtopic.php?t=70854
;
; WHAT WORKS AND FAILS?
;   WORKS
;     - In browser
;     - When VS Code has focus and you can enter text- fixed by using RunAsAdmin()
;   FAILS
;     - 
;====================================


#NoEnv
#Persistent
#SingleInstance, force
#InstallKeybdHook ; "physical state of a key or mouse button will usually be the same as the logical state unless the keyboard and/or mouse hooks are installed"
SendMode Input



RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


; Must double tap CapsLock to toggle CapsLock mode on or off.
CapsLock::
+CapsLock::
    KeyWait, CapsLock                                                    ; Wait forever until Capslock is released.
    KeyWait, CapsLock, D T0.2                                            ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
    if ((ErrorLevel = 0) && (A_PriorKey = "CapsLock"))                   ; Is a double tap on CapsLock?
    {
        SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"  ; Toggle the state of CapsLock LED
    }
return


;***** all my hotkeys - only one GetStateKey *****
#If GetKeyState("CapsLock", "P") ; instead of constantly checking whether the capslock key is down, this is probably more efficient

;***** BROWSER *****
b::
    msgbox "Browser"
    return

;***** SLACK *****
k::
    msgbox "Slack"
    return
^k::
    msgbox "Slack - jump"
    return
#If ; turn off context sensitivity for everything after this line

