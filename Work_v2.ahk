/**
 *  My AutoHotkey Automations for Work
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
SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
RunAsAdmin()



/**
 *  Include classes here, because they must be included before the auto-execute section 
 */
#Include "%A_ScriptDir%\Work\Jira_v2.ahk"
#Include "%A_ScriptDir%\Work\Slack_v2.ahk"



/**
 *  This code executes when the script starts, so declare global variables and do initializations here
 * 
 *  Requires several environment variables, see "Configure.bat" for details
 */
InitializeCommonGlobalVariables()
Configuration.Work := {
  UserEmailAddress: EnvGet("USERNAME") "@" EnvGet("USERDNSDOMAIN"),
  SourceCode: {
    Url: EnvGet("AHK_SOURCE_CODE_URL"),
    SchemaUrl: EnvGet("AHK_SOURCE_CODE_SCHEMA_URL"),
    SearchCodePrefix : EnvGet("AHK_SOURCE_CODE_SEARCH_CODE_PREFIX"),
    SearchCodeUrl: EnvGet("AHK_SOURCE_CODE_SEARCH_CODE_URL"),
    SearchRepositoriesUrl: EnvGet("AHK_SOURCE_CODE_SEARCH_REPOSITORIES_URL")
  },
  ParsecPeerId: EnvGet("AHK_PARSEC_PEER_ID"),
  WifiNetworks: {
    Office: EnvGet("AHK_OFFICE_WIFI_NETWORKS"),
    Home: EnvGet("AHK_HOME_WIFI_NETWORKS")
  }
}

; Initialize Jira
global MyJira := Jira()

; Initialize Slack integration and set my status based on where I am
;   * Requires several Windows environmental variables
global MySlack := Slack()
MySlack.SetStatusBasedOnLocation()

; Define the pop-up menu for accessing source code
global SourceCodeMenu := Menu()
CreateSourceCodeMenu()

return





/**
 *  Debugging, troubleshooting, and proof-of-concept stuff
 */
;AppsKey::    Msgbox(Configuration.Work.SourceCode.SchemaUrl)


/**
 *  Toggle mute in VOIP apps (Slack/Microsoft Teams/Zoom/Google Meet)
 *    Mute                 Activate the current VOIP call/meeting and toggles mute
 */
Volume_Mute::            ToggleMuteVOIPApps()


/**
 *  When looking at my personal laptop
 *    ✦ [                  On my personal laptop, toggle left sidebar
 */
#HotIf WinActive("ahk_exe parsecd.exe", )
  CapsLock & [::         SendKeystrokesToPersonalLaptop("{CapsLock down}[{CapsLock up}")
#HotIf


/**
 *  Slack
 *    ✦ k                  Open Slack
 *    ✦ ^ k                Open Slack and go to the "jump to" window
 *    ✦ [                  Toggle left sidebar
 *    ^ mousewheel         Decrease/increase font size
 *    ^ k                  Insert hyperlink (overrides Slack opening "jump to" window)
 *
 *   Statuses
 *     These used to use #/Win instead of !/Alt, but that broke by upgrading to AHK v2
 *     ✦ ! b              Status - Be Right Back. If I'm in the office, also locks my laptop.
 *     ✦ ! c              Status - Clears Slack status
 *     ✦ ! e              Status - Eating. Sets Slack status to lunch/dinner.
 *                                   - Locks my workstation
 *                                   - If I'm at home, also turns off my office lights
 *     ✦ ! m              Status - In a meeting
 *     ✦ ! p              Status - Playing
 *     ✦ ! w              Status - Working. Sets Slack status to office/remote.
 */
CapsLock & k::           MySlack.RunOrActivateSlack((GetKeyState("Ctrl") ? "^k" : ""))    

#HotIf WinActive("ahk_exe i)\\slack\.exe$", )
  ^wheelup::             SendInput("^{=}")
  ^wheeldown::           SendInput("^{-}")
  CapsLock & [::         SendInput("^+{d}")
  ^k::                   SendInput("^+{u}")
#HotIf

#HotIf GetKeyState("Alt")
  CapsLock & b::         SlackStatus_BeRightBack()
  CapsLock & c::         MySlack.SetStatusNone()
  CapsLock & e::         SlackStatus_Eating(15)    ; Lunch is before 3:00pm/15:00
  CapsLock & m::         MySlack.SetStatusMeeting()
  CapsLock & p::         MySlack.SetStatusPlaying()
  CapsLock & w::         MySlack.SetStatusWorking()
#HotIf


/**
 *  Calendar
 *    ✦ c                  Run or activate Outlook and switch to the calendar, using an Outlook
 *                         shortcut to switch to the calendar
 */
CapsLock & c::           RunOrActivateOutlook("^2")


/**
 *  Inbox
 *    ✦ i                  Run or activate Outlook and switch to the inbox, using an Outlook shortcut
 *                          to switch to the inbox  
 */
CapsLock & i::           RunOrActivateOutlook("^+I")


/*
 *  Jira
 *    ✦ j                  Opens the current sprint board
 *    ✦ ^ j                Search for a specific story number to open
 *                           * If the selected text looks like a Jira story number (e.g. 
 *                             PROJECT-1234), then open that story
 *                           * If the Git Bash window has text that looks like a Jira story number, 
 *                             then open that story
 *                           * Last resort is to open the current sprint board
 */
CapsLock & j::           MyJira.OpenJira()


/**
 *  Google search
 *    ✦ g                 Search for the selected text
 */
CapsLock & g::           GoogleSearch()


/**
 *  Music/Spotify
 *    ✦ m                  Run or activate Spotify
 *    ^ mousewheel         Decrease/increase font size
 */
CapsLock & m::           RunOrActivateSpotify()
#HotIf WinActive("ahk_exe i)\\spotify\.exe$", )
  ^wheelup::              SendInput("^{=}")
  ^wheeldown::            SendInput("^{-}")
#HotIf
  

/**
 *  Personal computer using Parsec
 *    ✦ p                  Connect to personal computer
 */
CapsLock & p::           ConnectToPersonalComputer()


/**
 *  Source code 
 *    ✦ s                  Source code- dashboard/overview
 *    ✦ ^ s                Source code- popup menu
 *                            - Search code for selected text
 *                            - Search repositories for selected text
 *                            - Event schema repository
 */
CapsLock & s::           OpenSourceCode(GetKeyState("Ctrl"))


/**
 *  Visual Studio
 *    ✦ [                  Toggle left sidebar
 *                          Use Shift+Esc to exit, or click outside
 *                          I could not find a way to determine if the Solution Explorer was open or 
 *                          not, to determine if I should do ✦[ or +{Esc}
 */
#HotIf WinActive("ahk_exe i)\\devenv\.exe$", )
  CapsLock & [::          SendInput("^!l")
#HotIf


/**
 *  IntelliJ
 *    ✦ l                  UNUSED - Start IntelliJ
 *    ✦ [                  Toggle left sidebar
 *
 */
;CapsLock & l::           RunOrActivateAppAsAdmin("ahk_exe i)\\idea64\.exe$", Configuration.WindowsProgramFilesFolder "\JetBrains\IntelliJ IDEA Community Edition 2021.2.3\bin\idea64.exe",, 20)
#HotIf WinActive("ahk_exe i)\\idea64\.exe$", )
  CapsLock & [::         SendInput("!1")
#HotIf


/**
 *  Home automation
 *
 *  (keys listed are on the numeric keypad)
 *    ✦ +                   Air cleaner: toggle on/off
 *    ✦ Enter                       Fan: toggle on/off
 *
 *    ✦ 7|8|9                 Top light: brightness down|toggle on/off|brightness up
 *    ✦ ^ 7|9                 Top light: brightness 1%|brightness 100%
 *
 *    ✦ 4|5|6              Middle light: brightness down|toggle on/off|brightness up
 *    ✦ ^ 4|6              Middle light: brightness 1%|brightness 100%
 *
 *   ✦ 1|2|3               Bottom light: brightness down|toggle on/off|brightness up
 *   ✦ ^ 1|3               Bottom light: brightness 1%|brightness 100%
 *
 * Disabled
 *   ✦ ^ +                  Air cleaner: cycle between fan speeds
 *                          THIS IS VALID FOR VESYNC AIR CLEANER, NOT WYZE PLUG
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


/**
 *  Generate a random UUID/GUID
 *    ✦ u                  Generate random UUID (lowercase)
 *    ✦ + u                Generate random UUID (uppercase)
 */
CapsLock & u::            SendInput(CreateRandomGUID(GetKeyState("Shift")))





/**
 *  Include all libraries, utilities, and other AutoHotkey scripts
 *
 *  I have to put this at the bottom of my script or it interferes with other code in this script
 */
#Include "%A_ScriptDir%\Common\Common_v2.ahk"

#Include "%A_ScriptDir%\Work\Work Functions_v2.ahk"
#Include "%A_ScriptDir%\Work\Mute VOIP Apps_v2.ahk"

#Include "%A_ScriptDir%\Lib\RunAsAdmin_v2.ahk"