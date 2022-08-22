/*
  My AutoHotkey Automations - Home
 
 
  Modifiers
  ---------
  ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper


  DEPENDENCIES
  ------------
  * IntelliJ
      - Plugin "macOS Dark Mode Sync" by Johnathan Gilday automatically 
        switches between Darcula and Intellij when OS changes
  * Chrome extension "Dark Reader"
  * VS Code extension "theme-switcher" by latusinski to toggle between light
   and dark mode



  Notes
  -----
    - Near the bottom of this script are a number of #include statements to include libraries of 
      utility functions
    - Using regex in "#IfWinActive ahk_exe i)\\xxxx\.exe$" requires "SetTitleMatchMode RegEx"
    - This script must be run as an admin or else any app run as an admin (i.e. Visual Studio,
      Visual Studio Code, etc.) will intercept the keystrokes before this script.
    - Definition of AutoHotkey keys: http://www.autohotkey.com/docs/KeyList.htm
    - This looks helpful: http://www.daviddeley.com/autohotkey/xprxmp/autohotkey_expression_examples.htm


  Dependencies
  ------------
    - IntelliJ
        - Enabled option: Editor > General > Change font size (Zoom) with Ctrl+MouseWheel
    - nircmd, for "setdefaultsounddevice" to switch between headphones and headset
*/


/*
  AutoHotkey configuration options
*/
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent
SendMode("Input")                ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; So my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
RunAsAdmin()


/*
  Global variables
*/
InitializeCommonGlobalVariables()
Configuration.IsWorkLaptop := False

/*
  This code executes when the script starts
*/
return





/*
  Include all libraries, utilities, and other AutoHotkey scripts

  I have to put this at the bottom of my script, or else it interferes with other code in this script
*/
#Include "%A_ScriptDir%\Home\Home Functions_v2.ahk"

#Include "%A_ScriptDir%\Common\Common_v2.ahk"
#Include "%A_ScriptDir%\Common\Convert Case_v2.ahk"
#Include "%A_ScriptDir%\Common\Customize Windows_v2.ahk"
#Include "%A_ScriptDir%\Common\My Auto Correct_v2.ahk"
#Include "%A_ScriptDir%\Common\Utilities_v2.ahk"

#Include "%A_ScriptDir%\Lib\RunAsAdmin_v2.ahk"