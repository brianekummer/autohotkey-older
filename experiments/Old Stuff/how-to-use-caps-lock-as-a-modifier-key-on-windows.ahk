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
;   https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
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




; https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/

#NoEnv                      ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn                     ; Enable warnings to assist with detecting common errors.
#SingleInstance FORCE       ; Skip invocation dialog box and silently replace previously executing instance of this script.
SendMode Input              ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


RunAsAdmin()
#Include %A_ScriptDir%\lib\RunAsAdmin.ahk


;================================================================================================
;  CapsLock processing.  Must double tap CapsLock to toggle CapsLock mode on or off.
;================================================================================================
; Must double tap CapsLock to toggle CapsLock mode on or off.
CapsLock::
    KeyWait, CapsLock                                                   ; Wait forever until Capslock is released.
    KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
    if ((ErrorLevel = 0) && (A_PriorKey = "CapsLock") )                 ; Is a double tap on CapsLock?
        {
        SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"  ; Toggle the state of CapsLock LED
        }
return



;================================================================================================
; Hot keys with CapsLock modifier.  See https://autohotkey.com/docs/Hotkeys.htm#combo
;================================================================================================
; Get DEFINITION of selected word.    
CapsLock & d::
    ClipboardGet()
    Run, http://www.google.com/search?q=define+%clipboard%     ; Launch with contents of clipboard
    ClipboardRestore()
Return

; GOOGLE the selected text.
CapsLock & g::
    ClipboardGet()
    Run, http://www.google.com/search?q=%clipboard%             ; Launch with contents of clipboard
    ClipboardRestore()
Return

; Do THESAURUS of selected word
CapsLock & t::
    ClipboardGet()
    Run http://www.thesaurus.com/browse/%Clipboard%             ; Launch with contents of clipboard
    ClipboardRestore()
Return

; Do WIKIPEDIA of selected word
CapsLock & w::
    ClipboardGet()
    Run, https://en.wikipedia.org/wiki/%clipboard%              ; Launch with contents of clipboard
    ClipboardRestore()
Return

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;================================================================================================
; Clipboard helper functions.
;================================================================================================
ClipboardGet()
{
    OldClipboard:= ClipboardAll                         ;Save existing clipboard.
    Clipboard:= ""
    Send, ^c                                            ;Copy selected test to clipboard
    ClipWait 0
    If ErrorLevel
        {
        MsgBox, No Text Selected!
        Return
        }
}


ClipboardRestore()
{
    Clipboard:= OldClipboard
}




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