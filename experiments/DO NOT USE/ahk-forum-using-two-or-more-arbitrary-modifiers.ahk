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
;   https://autohotkey.com/board/topic/70239-using-two-or-more-arbitrary-modifiers/
;  by Lexikos - I HAVE NO IDEA HOW TO USE THIS !!!!
; 
; 
;
; WHAT WORKS AND FAILS?
;   WORKS
;     - 
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





; https://autohotkey.com/board/topic/70239-using-two-or-more-arbitrary-modifiers/

ctrl_key := "CapsLock"
shift_key := "LWin"
j_key := "j"
k_key := "k"

Hotkey *%ctrl_key%, mod_key
Hotkey *%ctrl_key% Up, mod_key
Hotkey *%shift_key%, mod_key
Hotkey *%shift_key% Up, mod_key

return

mod_key:    ; Modifier key pressed or released.
    mods := ""
    if GetKeyState(ctrl_key, "P")
        mods .= "CL"
    if GetKeyState(shift_key, "P")
        mods .= "LW"
    Hotkey *%j_key%, other_key, % mods ? "On" : "Off"
    Hotkey *%k_key%, other_key, % mods ? "On" : "Off"
    return

other_key:  ; Modified key pressed (with at least one modifier).
    other_key(mods, SubStr(A_ThisHotkey, 2)) ; For local variables.
    return

other_key(mods, key)
{
    if InStr(mods . key, "L")
        KeyWait LWin ; (global) mods and A_ThisHotkey will change in the meantime.
    SendRaw % mods . key
}




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
