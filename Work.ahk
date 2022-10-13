/**
 *  My AutoHotkey Automations for Work
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
 *  Include classes here, because they must be included before the auto-execute section 
 */
#Include Work\Jira.ahk
#Include Work\Slack.ahk



/**
 *  This code executes when the script starts, so declare global variables and do initializations here
 * 
 *  Requires several environment variables, see "Configure.bat" for details
 */
InitializeCommonGlobalVariables()
Configuration.Work := {
  UserEmailAddress: EnvGet("USERNAME") . "@" . EnvGet("USERDNSDOMAIN"),
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
  },
  Wiki: {
    Url: EnvGet("AHK_WIKI_URL"),
    SearchUrl: EnvGet("AHK_WIKI_SEARCH_URL"),
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

global IdentifiersMenu := Menu()
global identifiers := []
CreateIdentifiersMenu()
return





/*******************************  Debugging, troubleshooting, and proof-of-concept work  *******************************/


;AppsKey:: {
;} 



/************************************************  Production Code  ***********************************************/





/**
 *  Toggle mute in VOIP apps (Slack/Microsoft Teams/Zoom/Google Meet)
 *    Mute               Activate the current VOIP call/meeting and toggles mute
 */
Volume_Mute::            ToggleMuteVOIPApps()


/**
 *  When looking at my personal laptop
 *    ✦ [                On my personal laptop, toggle left sidebar
 */
#HotIf WinActive("ahk_exe parsecd.exe", )
  CapsLock & [::         SendKeystrokesToPersonalLaptop("{CapsLock down}[{CapsLock up}")
#HotIf


/**
 *  Pop-up menu of identifiers
 *    ✦ =                Opens a menu of commonly used identifiers/constants. Selecting one outputs
 *                       that constant to the currently-active window.
 */
CapsLock & =::           IdentifiersMenu.Show()


/**
 *  Calendar
 *    ✦ c                Run or activate Outlook and switch to the calendar, using an Outlook
 *                       shortcut
 */
CapsLock & c::           RunOrActivateOutlook("^2")


 /**
 *  Google search
 *    ✦ g                Search for the selected text
 */
  CapsLock & g::         GoogleSearch()


/**
 *  Inbox
 *    ✦ i                Run or activate Outlook and switch to the inbox, using an Outlook shortcut
 */
CapsLock & i::           RunOrActivateOutlook("^+I")


/**
 *  IntelliJ
 *    ✦ l                UNUSED - Start IntelliJ
 *    ✦ [                Toggle left sidebar
 *
 */
;CapsLock & l::            RunOrActivateAppAsAdmin("ahk_exe i)\\idea64\.exe$", Configuration.WindowsProgramFilesFolder "\JetBrains\IntelliJ IDEA Community Edition 2021.2.3\bin\idea64.exe",, 20)
#HotIf WinActive("ahk_exe i)\\idea64\.exe$", )
  CapsLock & [::         SendInput("!1")
#HotIf


/**
 *  Jira
 *    ✦ j                - If the selected text looks like a Jira story number (e.g. PROJECT-1234),
 *                         then open that story
 *                       - If the selected text is the url to a Jira sprint, then parse out the
 *                         story number and save that as our current sprint number
 *                       - If a Git Bash window has a window title that looks like a Jira story number, 
 *                         then open that story
 *                       - Last option is to open the current sprint board
 */
CapsLock & j::           MyJira.OpenJira()


/**
 *  Slack
 *    ✦ k                Open Slack
 *    ✦ ^ k              Open Slack and go to the "jump to" window
 *    ✦ [                Toggle left sidebar
 *    ^ mousewheel       Decrease/increase font size
 *    ^ k                Insert hyperlink (overrides Slack opening "jump to" window)
 *
 *   Statuses
 *     These used to use #/Win instead of !/Alt, but that broke by upgrading to AHK v2
 *     ✦ ! b             Status: Be Right Back
 *                          - If I'm in the office, also locks my laptop
 *     ✦ ! c             Status: Clears Slack status
 *     ✦ ! e             Status: Eating
 *                          - Sets Slack status to lunch/dinner depending on the time
 *                          - Locks my workstation
 *                          - If I'm at home, also turns off my office lights
 *     ✦ ! m             Status: In a meeting
 *     ✦ ! p             Status: Playing
 *     ✦ ! w             Status: Working
 *                         - Sets Slack status to office/remote depending on my location
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
 *  Music/Spotify
 *    ✦ m                Run or activate Spotify
 *    ^ mousewheel       Decrease/increase font size
 */
CapsLock & m::           RunOrActivateSpotify()
#HotIf WinActive("ahk_exe i)\\spotify\.exe$", )
  ^wheelup::             SendInput("^{=}")
  ^wheeldown::           SendInput("^{-}")
#HotIf
  

/**
 *  Personal computer using Parsec
 *    ✦ p                Connect to personal computer
 */
CapsLock & p::           ConnectToPersonalComputer()


/**
 *  Source code 
 *    ✦ s                Source code- dashboard/overview
 *    ✦ ^ s              Source code- popup menu
 *                          - Search code for selected text
 *                          - Search repositories for selected text
 *                          - Event schema repository
 */
CapsLock & s::           OpenSourceCode(GetKeyState("Ctrl"))


/**
 *  Generate a random UUID/GUID
 *    ✦ u                Generate random UUID (lowercase)
 *    ✦ + u              Generate random UUID (uppercase)
 */
 CapsLock & u::           SendInput(CreateRandomGUID(GetKeyState("Shift")))
 
 
 /**
 *  Visual Studio
 *    ✦ [               Toggle left sidebar
 *                       Use Shift+Esc to exit, or click outside
 *                       I could not find a way to determine if the Solution Explorer was open or 
 *                       not, to determine if I should do ✦[ or +{Esc}
 */
#HotIf WinActive("ahk_exe i)\\devenv\.exe$", )
  CapsLock & [::         SendInput("^!l")
#HotIf


/**
 *  Wiki
 *    ✦ w                Open wiki page
 *    ✦ ^ w              Search the wiki for the selected text
 */
 CapsLock & w::           OpenWiki(GetKeyState("Ctrl"))


/**
 *  Home automation
 *
 *  (keys listed are on the numeric keypad)
 *    ✦ +                 Air cleaner: toggle on/off
 *    ✦ Enter                     Fan: toggle on/off
 *
 *    ✦ 7|8|9               Top light: brightness down|toggle on/off|brightness up
 *    ✦ ^ 7|9               Top light: brightness 1%|brightness 100%
 *
 *    ✦ 4|5|6            Middle light: brightness down|toggle on/off|brightness up
 *    ✦ ^ 4|6            Middle light: brightness 1%|brightness 100%
 *
 *   ✦ 1|2|3             Bottom light: brightness down|toggle on/off|brightness up
 *   ✦ ^ 1|3             Bottom light: brightness 1%|brightness 100%
 *
 * Disabled
 *   ✦ ^ +               Air cleaner: cycle between fan speeds
 *                       This is valid for vesync air cleaner, not Wyze plugs
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
 *  Include all libraries, utilities, and other AutoHotkey scripts
 *
 *  I have to put this at the bottom of my script or it interferes with other code in this script
 */
#Include "%A_ScriptDir%\Common\Common.ahk"
#Include "%A_ScriptDir%\Work\Work Functions.ahk"
#Include "%A_ScriptDir%\Work\Mute VOIP Apps.ahk"