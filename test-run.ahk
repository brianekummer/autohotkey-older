#Requires AutoHotkey v2.0-b      ; I've converted all my code to AHK v2.0+
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
;Persistent                       ; Prevents script from exiting automatically when its last thread completes, allowing it to stay running in an idle state
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex





/**
 *  This code executes when the script starts, so declare global variables and do initializations here
 */
InitializeCommonGlobalVariables()

; Get the params from array A_Args

; TODO- IF this works well, consider pulling RunOrActivateApp out into it's own script
;       OR, is there a way to run Utilities.ahk and pass the method name as a parameter and then 
;       JIRA could do something like
;         Run '"C:\Program Files\AutoHotkey\AutoHotkey64.exe" Utilities.ahk RunOrActivateApp ' . title . ' ' . url . 'True False 10 False'
; Means Utilities startup code would have to decide what to do based on command line params
; 
; Other places this needs used besides Jira.ahk:
;   - CommonFunctions.RunOrActivateSpotify()


SetTimer(DoIt,-1)



DoIt() {
  ; Want to run this by a timer so can return to the original caller ASAP so it can continue
  ; I'm not sure if this helps or not. There are still times where pressing hotkey 2nd time 
  ; doesn't work, and it just types the letter j. I wonder if moving the settimer into Jira.ahk 
  ; will help solve or reduce this problem. Even if it doesn't, this is substantially better
  ; than the old code that wouldn't work well.
  ; 
  ; But the old code wasn't THAT bad, because typically-
  ;   1. press H+J to open a jira website, is running very slow
  ;   2. press H+J to open diff jira website. Code for 1st one pauses while 2nd one runs,
  ;      but web page for 1st is still loading.
  ;   3. 2nd page loads and code finishes, goes back to first code, and page is already loaded
  ; Problem really is that pause/resume apparently messes w/CapsLock status.

  RunOrActivateApp(a_args[1], a_args[2], StrLower(a_args[3]) == "true", StrLower(a_args[4]) == "true", a_args[5] * 1, StrLower(a_args[6]) == "true")
  ExitApp()
}


#Include "%A_ScriptDir%\Common\Common Functions.ahk"
#Include "%A_ScriptDir%\Common\Customize Windows.ahk"
#Include "%A_ScriptDir%\\Common\Utilities.ahk"