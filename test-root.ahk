#Requires AutoHotkey v2.0-b      ; I've converted all my code to AHK v2.0+
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent                       ; Prevents script from exiting automatically when its last thread completes, allowing it to stay running in an idle state
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex



^a:: {
  ;SetTimer(timera, -1)
  Run 'test-run.ahk "Fox News.*" "https://foxnews.com" True False 10 False'
}

^b:: {
  ;SetTimer(timerb, -1)
}

timera() {
  veg := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
  Loop veg.Length {
    Tooltip "X=" . veg[A_Index], 100, 100, 1
    Sleep(750)
  }
  Tooltip
}

timerb() {
  veg := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
  Loop veg.Length {
    Tooltip "Y=" . veg[A_Index], 500, 500, 2
    Sleep(750)
  }
  Tooltip
}