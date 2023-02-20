/**
 *  RunApp
 * 
 *  Run an application or website and wait for it to appear. Since this code makes
 *  use of WinWait, it'd ideally be in it's own thread or process. So it was broken
 *  out into a separate script that can be executed with Run, putting it in a 
 *  separate process.
 *  
 *  Notes
 *    - xxxxx
 *
 *  To Do List
 *    - Is the call to CommonReturn() in ShellRun() a problem? Since this is running 
 *      in a different process, it may not matter
 *    - Can any improvements be made to the code that waits for the app to start?
 */


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


; Constants
SW_SHOWNORMAL := 0        ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
SW_SHOWMAXIMIZED := 3


; Assign the parameters to meaningful variable names
winTitle := a_args[1]
whatToRun := a_args[2]
maximizeWindow := StrLower(a_args[3]) == "true"
asAdminUser := StrLower(a_args[4]) == "true"
timeToWait := a_args[5] * 1


; When starting an app, it is always better to pass a maximize flag instead of 
; starting the app, doing a WinWait(), and then a WinMaximize()
if (asAdminUser) {
  Run(whatToRun,, (maximizeWindow ? "max" : ""))
} else {
  ShellRun(whatToRun,,,, (maximizeWindow ? SW_SHOWMAXIMIZED : SW_SHOWNORMAL))
}


; Here are two versions of code to wait for the app to start and window to appear

; 1. The old version that had issues w/concurrency when it was part of Utilities.ahk
; Windows doesn't always set focus to this new window, so we need to use WinActivate
WinWait(winTitle,, timeToWait)
if (WinExist(winTitle)) {
  ; If the window now exists, activate it, else, give up
  WinActivate(winTitle)
}

; 2. There's something wrong with this code. I'm not confident it would help my problem anyway.
;waitedForSeconds := 0
;While (WinWaitActive(winTitle,, 0.25) == 0 && waitedForSeconds <= timeToWait) {
;  Sleep(250)
;  waitedForSeconds += 0.5
;}
;WinActivate(winTitle)


ExitApp()



/**
 *  ShellRun() is in Utilities.ahk and uses CommonRestore(), which is in Customize Windows.ahk,
 *  which contains many functions that use variables defined in Common Functions.ahk
 */
#Include "Common Functions.ahk"
#Include "Customize Windows.ahk"
#Include "Utilities.ahk"