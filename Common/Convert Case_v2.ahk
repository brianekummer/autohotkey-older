/**
 *  Convert Case
 * 
 *  Cycles selected text between lowercase, uppercase, sentence case, and title case
 *
 *  - Based on code by J. Scott Elblein (GeekDrop.com), modified by Brian Kummer
 *    https://geekdrop.com/content/super-handy-autohotkey-ahk-script-to-change-the-case-of-text-in-line-or-wrap-text-in-quotes
 *  - Code is noticeably faster by using SendInput for moving cursor
 *  - Moves cursor to start of text, highlights text, leaving cursor at rightmost end of highlighted text
 *  - Tooltip to say what new case is
 *  - Timer to reset cycle back to lowercase after 30 seconds
 *  - For converting to title case, instead of using AutoHotkey's StringUpper/StringLower with the title option (which
 *    capitalizes EVERY word, including articles, prepositions, etc), I'm using code from this thread that is more 
 *    accurate: https://www.autohotkey.com/boards/viewtopic.php?t=19036
 *  - I tried using my GetSelectedTextUsingClipboard() method but it was unreliable and much slower when used here.
 *    I do not know why, nor did I have the time to figure out why and fix it.
 */
ConvertCase() {
  static cycleNumber := 1

  SetTimer(ResetCycleNumber,0)

  clipSave := A_Clipboard                               ; Save clipboard contents so we can restore when done
  A_Clipboard := ""                                     ; Empty clipboard so ClipWait has something to detect
  SendInput("^c")                                       ; Copies selected text
  Errorlevel := !ClipWait()
  A_Clipboard := StrReplace(A_Clipboard, "`r`n", "`n")  ; Fix for SendInput sending Windows linebreaks

  switch cycleNumber {
    case 1:   
      A_Clipboard := StrLower(A_Clipboard)
      ToolTip("Lowercase")
    case 2:  
      A_Clipboard := StrUpper(A_Clipboard)
      ToolTip("Uppercase")
    case 3:    
      A_Clipboard := StrLower(A_Clipboard)
      A_Clipboard := RegExReplace(A_Clipboard, "(((^|([.!?]+\s+))[a-z])| i | i')", "$u1")
      ToolTip("Sentence Case")
    case 4:    
      str := Format("{:T}", A_Clipboard)
      static tCase := "(?:A(?:nd?|s|t)?|B(?:ut|y)|For|In|Nor|O(?:f|n|r)|Per|T(?:he|o))"
      loop 3	   ; Must run at least twice to overcome potential misses from using '\K'
        str := RegExReplace(str, "s)[^\.\?\!]\h+\K\b" tCase "\b(?![\.\?\!])", "$L0")
      A_Clipboard := str
      ToolTip("Title Case")
    default:
      MsgBox("Error, cycleNumber is " cycleNumber)
      cycleNumber := 1
  }

  SetTimer(RemoveToolTip, -3000)

  Len := Strlen(A_Clipboard)
  SendInput("^v")                                        ; Paste the changed text
  SendInput("{left " Len "}+{right " Len "}")            ; Select all the text we just updated
  Sleep(250)                                             ; This seems to get rid of weird behavior
  A_Clipboard := clipSave                                ; Restore clipboard to original value

  cycleNumber := cycleNumber == 4 ? 1 : cycleNumber + 1  ; Move on to the next cycle

  ; Set a timer to run once 30 seconds from now, which will reset cycleNumber back to 1, so
  ; that after 30 seconds, this will start over converting to lowercase.
  SetTimer(ResetCycleNumber, -30000)
}


RemoveToolTip() {
  ToolTip()
}


ResetCycleNumber() {
  global cycleNumber
  cycleNumber := 1
}