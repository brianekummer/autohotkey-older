/**
 *  My AutoHotkey Automations for Home
 *
 *  Ideally, this script should contain only hotkeys and hostrings. Any supporting code
 *  should be in a "xxxx Functions.ahk" script.
 * 
 *  Modifiers
 *    ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper
 * 
 *  Notes
 *    - This MUST be run as administrator. See Utilities.VerifyRunningAsAdmin() for tips
 *      on how to do this.
 */



/**
 *  AutoHotkey configuration options
 */
#Requires AutoHotkey v2.0-b      ; I've converted all my code to AHK v2.0+
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent                       ; Prevents script from exiting automatically when its last thread completes, allowing it to stay running in an idle state
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
VerifyRunningAsAdmin()



/**
 *  This code executes when the script starts, so declare global variables and do initializations here
 */
InitializeCommonGlobalVariables()

return





/**
 *  Include all libraries, utilities, and other AutoHotkey scripts
 *
 *  I have to put this at the bottom of my script or it interferes with other code in this script
 */
#Include "%A_ScriptDir%\Common\Common.ahk"
#Include "%A_ScriptDir%\Home\Home Functions.ahk"