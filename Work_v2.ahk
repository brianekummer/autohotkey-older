/*
; My AutoHotkey Automations - Work
;
;
; Modifiers
; ---------
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = Hyper 
;
; DEPENDENCIES
; ------------
; * IntelliJ
;     - Plugin "macOS Dark Mode Sync" by Johnathan Gilday automatically 
;       switches between Darcula and Intellij when OS changes
; * Chrome extension "Dark Reader"
; * VS Code extension "theme-switcher" by latusinski to toggle between light
;  and dark mode
;
; Notes
; -----
;   - Near the bottom of this script are a number of #include statements to include libraries of 
;     utility functions
;   - Using regex in "#IfWinActive ahk_exe i)\\xxxx\.exe$" requires "SetTitleMatchMode RegEx"
;   - This script must be run as an admin or else any app run as an admin (i.e. Visual Studio,
;     Visual Studio Code, etc.) will intercept the keystrokes before this script.
;   - Definition of AutoHotkey keys: http://www.autohotkey.com/docs/KeyList.htm
;   - This looks helpful: http://www.daviddeley.com/autohotkey/xprxmp/autohotkey_expression_examples.htm
;
;
; Dependencies
; ------------
;   - IntelliJ
;       - Enabled option: Editor > General > Change font size (Zoom) with Ctrl+MouseWheel
;   - nircmd, for "setdefaultsounddevice" to switch between headphones and headset
*/



/*
  AutoHotkey configuration options
*/
#SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent
SendMode("Input")                ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
RunAsAdmin()


/*
  Include classes here, because they must be included before the auto-execute section
*/
#Include "%A_ScriptDir%\Work\Jira_v2.ahk"


/*
  Global variables
*/
InitializeCommonGlobalVariables()
global MyJira := Jira()

Configuration.IsWorkLaptop := True
Configuration.Work := {
  UserEmailAddress: EnvGet("USERNAME") "@" EnvGet("USERDNSDOMAIN"),

  ; These come from my Windows environment variables- see "Configure.bat" for details
  SourceCodeUrl: EnvGet("AHK_SOURCE_CODE_URL"),
  SourceSchemaUrl: EnvGet("AHK_SOURCE_CODE_SCHEMA_URL"),
  ParsecPeerId: EnvGet("AHK_PARSEC_PEER_ID"),
  OfficeNetworks: EnvGet("AHK_OFFICE_NETWORKS")
}


/*
  This code executes when the script starts
*/
; Configure Slack status updates based on the network. *REQUIRES* several Windows environment variables - see 
; "Slack.ahk" for details
SlackStatusUpdate_Initialize()
SlackStatusUpdate_SetSlackStatusBasedOnNetwork()
return


/*
  Toggle mute in VOIP apps (Slack/Microsoft Teams/Zoom/Google Meet)
    Mute                 Activate the current VOIP call/meeting and toggles mute
*/
Volume_Mute::            ToggleMuteVOIPApps()


/*
  When looking at my personal laptop
    ✦ [                  On my personal laptop, toggle left sidebar
*/
#HotIf WinActive("ahk_exe parsecd.exe", )
  CapsLock & [::         SendKeystrokesToPersonalLaptop("{CapsLock down}[{CapsLock up}")
#HotIf


/*
  Slack
    ✦ k                  Open Slack
    ✦ ^ k                Open Slack and go to the "jump to" window
    ✦ [                  Toggle left sidebar
    ^ mousewheel         Decrease/increase font size
    ^ k                  Insert hyperlink (overrides Slack opening "jump to" window)

    Statuses
      These use to use #/Win instead of !/Alt, but that broke by upgrading to AHK v2
      ✦ ! b              Status - Be Right Back. Sets Slack statuses to brb.
      ✦ ! c              Status - Cleared. Clears Slack status.
      ✦ ! e              Status - Eating. Sets Slack statuses to lunch/dinner.
                          Also locks my laptop and turns off my office lights if I'm at home.
      ✦ ! m              Status - In a meeting. Sets Slack statuses to mtg.
      ✦ ! p              Status - Playing. Sets home Slack status to 8bit.
      ✦ ! w              Status - Working. Clears Slack statuses.
*/
CapsLock & k::           OpenSlack((GetKeyState("Ctrl") ? "^k" : ""))    

#HotIf WinActive("ahk_exe i)\\slack\.exe$", )
  ^wheelup::             SendInput("^{=}")
  ^wheeldown::           SendInput("^{-}")
  CapsLock & [::         SendInput("^+{d}")
  ^k::                   SendInput("^+{u}")
#HotIf

#HotIf GetKeyState("Alt")
  CapsLock & b::         SlackStatusUpdate_SetSlackStatusAndPresence("brb", "away")
  CapsLock & c::         SlackStatusUpdate_SetSlackStatusAndPresence("none", "auto")
  CapsLock & e::         SlackStatus_Eating(15)    ; Lunch is before 3:00pm/15:00
  CapsLock & m::         SlackStatusUpdate_SetSlackStatusAndPresence("meeting", "auto")
  CapsLock & p::         SlackStatusUpdate_SetHomeSlackStatus("playing")
  CapsLock & w::         SlackStatus_Working()
#HotIf



/*
  Calendar
    ✦ c                  Run or activate Outlook and switch to the calendar, using an Outlook
                         shortcut to switch to the calendar
*/
CapsLock & c::           ActivateOrStartMicrosoftOutlook("^2")


/*
  Inbox
    ✦ i                  Run or activate Outlook and switch to the inbox, using an Outlook shortcut
                         to switch to the inbox
*/
CapsLock & i::           ActivateOrStartMicrosoftOutlook("^+I")


/*
  Jira
    ✦ j                  Opens the current sprint board
    ✦ ^ j                Search for a specific story number to openr
                           * If the highlighted text looks like a Jira story number (e.g. 
                             PROJECT-1234), then open that story
                           * If the Git Bash window has text that looks like a Jira story number, 
                             then open that story
                           * Last resort is to open the current sprint board
*/
CapsLock & j::           MyJira.OpenJira()


/*
  Music/Spotify
    ✦ m                  Run or activate Spotify
*/
CapsLock & m::           RunOrActivateSpotify()
#HotIf WinActive("ahk_exe i)\\spotify\.exe$", )
  ^wheelup::              SendInput("^{=}")
  ^wheeldown::            SendInput("^{-}")
#HotIf
  

/*
  Personal computer
    ✦ p                  Connect to personal computer
*/
CapsLock & p::           ConnectToPersonalComputer()


/*
  Source code
    ✦ s                  Source code/BitBucket
    ✦ ^ s                Source code/BitBucket- schemas
*/
CapsLock & s::           OpenSourceCode(GetKeyState("Ctrl"))




/*
  Visual Studio
    ✦ [                  Toggle left sidebar
                         Use Shift+Esc to exit, or click outside
                         I could not find a way to determine if the Solution Explorer was open or 
                         not, to determine if I should do ✦[ or +{Esc}
*/
#HotIf WinActive("ahk_exe i)\\devenv\.exe$", )
  CapsLock & [::          SendInput("^!l")
#HotIf


/*
  IntelliJ
    ✦ l                  Start IntelliJ
    ✦ [                  Toggle left sidebar
*/
CapsLock & l::           RunAppAsAdmin("ahk_exe i)\\idea64\.exe$", Configuration.WindowsProgramFilesFolder "\JetBrains\IntelliJ IDEA Community Edition 2021.2.3\bin\idea64.exe",, 20)
#HotIf WinActive("ahk_exe i)\\idea64\.exe$", )
  CapsLock & [::         SendInput("!1")
#HotIf


/*
  Home automation
    (keys listed are on the numeric keypad)
    ✦ +                   Air cleaner: toggle on/off
    ✦ Enter                       Fan: toggle on/off

    ✦ 7|8|9                 Top light: brightness down|toggle on/off|brightness up
    ✦ ^ 7|9                 Top light: brightness 1%|brightness 100%

    ✦ 4|5|6              Middle light: brightness down|toggle on/off|brightness up
    ✦ ^ 4|6              Middle light: brightness 1%|brightness 100%

    ✦ 1|2|3              Bottom light: brightness down|toggle on/off|brightness up
    ✦ ^ 1|3              Bottom light: brightness 1%|brightness 100%


  DISABLED
   ✦ ^ +                 Air cleaner: cycle between fan speeds
                           THIS IS VALID FOR VESYNC AIR CLEANER, NOT WYZE PLUG
*/
CapsLock & NumpadAdd::   HomeAutomationCommand("officeac         toggle")     
CapsLock & NumpadEnter:: HomeAutomationCommand("officefan        toggle")

; Because ^NumLock produces key code of Pause, must do hot keys differently for minimum brightness for officelite
CapsLock & NumLock::     HomeAutomationCommand("officelite       brightness -")
CapsLock & Pause::       HomeAutomationCommand("officelite       brightness 1")

CapsLock & NumpadDiv::   HomeAutomationCommand("officelite       toggle")
CapsLock & NumpadMult::  HomeAutomationCommand("officelite       brightness " (GetKeyState("Ctrl") ? "100" : "+"))

CapsLock & Numpad7::     HomeAutomationCommand("officelitetop    brightness " (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & Numpad8::     HomeAutomationCommand("officelitetop    toggle")
CapsLock & Numpad9::     HomeAutomationCommand("officelitetop    brightness " (GetKeyState("Ctrl") ? "100" : "+"))

CapsLock & Numpad4::     HomeAutomationCommand("officelitemiddle brightness " (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & Numpad5::     HomeAutomationCommand("officelitemiddle toggle")
CapsLock & Numpad6::     HomeAutomationCommand("officelitemiddle brightness " (GetKeyState("Ctrl") ? "100" : "+"))

CapsLock & Numpad1::     HomeAutomationCommand("officelitebottom brightness " (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & Numpad2::     HomeAutomationCommand("officelitebottom toggle")
CapsLock & Numpad3::     HomeAutomationCommand("officelitebottom brightness " (GetKeyState("Ctrl") ? "100" : "+"))


/*
  Generate a UUID/GUID
    ✦ u                  Generate random UUID (lowercase)
    ✦ + u                Generate random UUID (uppercase)
*/
CapsLock & u::            SendInput(CreateRandomGUID(GetKeyState("Shift")))





/*
class Jira
{
  __New() {
    this.BaseUrl := EnvGet("AHK_JIRA_URL")
    this.MyProjectKeys := EnvGet("AHK_JIRA_MY_PROJECT_KEYS")
    this.DefaultProjectKey := EnvGet("AHK_JIRA_DEFAULT_PROJECT_KEY")
    this.DefaultRapidKey := EnvGet("AHK_JIRA_DEFAULT_RAPID_KEY")
    this.DefaultSprint := EnvGet("AHK_JIRA_DEFAULT_SPRINT")
  }
  

  OpenJira(selectedText)
  {
    msgbox("opening Jira. SelectedText is " selectedText ", base url is " this.BaseUrl)
  }
}
*/


/*
  Include all libraries, utilities, and other AutoHotkey scripts

  I have to put this at the bottom of my script, or else it interferes with other code in this script
*/
#Include "%A_ScriptDir%\Work\Work Functions_v2.ahk"
#Include "%A_ScriptDir%\Work\Mute VOIP Apps_v2.ahk"
#Include "%A_ScriptDir%\Work\Slack_v2.ahk"

#Include "%A_ScriptDir%\Common\Common_v2.ahk"
#Include "%A_ScriptDir%\Common\Convert Case_v2.ahk"
#Include "%A_ScriptDir%\Common\Customize Windows_v2.ahk"
#Include "%A_ScriptDir%\Common\My Auto Correct_v2.ahk"
#Include "%A_ScriptDir%\Common\Utilities_v2.ahk"

#Include "%A_ScriptDir%\Lib\RunAsAdmin_v2.ahk"