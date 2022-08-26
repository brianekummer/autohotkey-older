/**
 *  My AutoHotkey Automations for Home
 *
 *  Ideally, this script should contain only hotkeys and hostrings. Any supporting code
 *  should be in a "xxxx Functions.ahk" script.
 * 
 *  Modifiers
 *    ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper
 */



/**
 *  AutoHotkey configuration options
 */
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent
SendMode("Input")                ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; So my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
RunAsAdmin()



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
#Include "%A_ScriptDir%\Common\Common_v2.ahk"

#Include "%A_ScriptDir%\Home\Home Functions_v2.ahk"

#Include "%A_ScriptDir%\Lib\RunAsAdmin_v2.ahk"