﻿/**
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
 #Requires AutoHotkey v2.0-b      ; I've converted all my code to AHK v2.0+
 #SingleInstance FORCE            ; Skip invocation dialog box and silently replace previously executing instance of this script
 Persistent                       ; Prevents script from exiting automatically when its last thread completes, allowing it to stay running in an idle state
 SetWorkingDir(A_ScriptDir)       ; Ensures a consistent starting directory
 SetCapsLockState("AlwaysOff")    ; Disable the CapsLock LED on my keyboard
 SetNumLockState("On")            ; Turn on Scroll Lock, so my macros with keypad work
 SetTitleMatchMode("RegEx")       ; Make windowing commands use regex
 RunAsAdmin()
 


/**
 *  Include classes here, because they must be included before the auto-execute section 
 */
#Include "%A_ScriptDir%\Work\Jira.ahk"
#Include "%A_ScriptDir%\Work\Slack.ahk"



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

return





/*******************************  Debugging, troubleshooting, and proof-of-concept work  *******************************/


;AppsKey::    Msgbox(Configuration.Work.SourceCode.SchemaUrl)


;---------------------------------------------------------------------------------------------------------------------
; Use Google search to try to fix the selected text
;   - For example, this changes "Where is you're house?" to "Where is your house?"
;   - Code adapted from https://jacksautohotkeyblog.wordpress.com/2016/09/22/fixing-grammar-problems-with-google-search-intermediate-autohotkey-tip/
;---------------------------------------------------------------------------------------------------------------------
/*

    << I DON'T KNOW HOW USEFUL THIS REALLY IS... it's cool code, but likely not very useful. >>

*/
#^g:: {       ; Windows|AHK|Google search to fix selected text
  clipSave := A_Clipboard                               ; Save clipboard contents so we can restore when done
  A_Clipboard := ""                                     ; Empty clipboard so ClipWait has something to detect
  SendInput("^c")                                       ; Copies selected text
  Errorlevel := !ClipWait()
  if (!ErrorLevel)
  {
    ; Only do this if there was selected text
    whr := ComObject("Msxml2.XMLHTTP")
    whr.Open("GET", "https://www.google.com/search?q=" UriEncode(A_Clipboard), false)
    whr.Send()
    contents := whr.ResponseText

    if (RegExMatch(contents, "Showing results for <a.*?>(.*?)</a>", &match))
    {
      ; Strip out span, bold, and italic tags, then output the results
      A_Clipboard := RegExReplace(match[1], "(<b>|<i>|<span>|<\/b>|<\/i>|<\/span>)", "")

      SendInput("^v")
      Sleep(250)
      A_Clipboard := clipSave  
    }
  }
}



;---------------------------------------------------------------------------------------------------------------------
; Grammarly - Paste the selected text into a new document on Grammarly.com
;
; To create a new document in Grammarly.com, navigate to https://app.grammarly.com/docs/new.
;   - It takes a few seconds to load
;   - When it is almost ready to allow editing, it changes the URL to something like this:
;     https://app.grammarly.com/ddocs/565623631. 
;   - Recent versions of Chrome don't allow us to easily or reliably get the URL from code
;   - I could press !d/^i/f6 to get to the Chrome omnibar so I can copy the URL, but there is no easy/consistent 
;     way to get back to the page content
;   - My solution is to use the Chrome extension called "Url in Title" by Guillaume Ryder, which adds the URL to the
;     title of the webpage, so AHK can watch for it. You can specify a whitelist so that only the whitelisted sites
;     display the URL in the title. I confligured the extension like this:
;       Tab title format: {title} - {protocol}://{hostname}{port}/{path}
;       Whitelist: https://app.grammarly.com
;
; Decisions
;   - Grammarly Windows app was my first choice, but is very keyboard unfriendly, so had to use the web page
;   - CAN THAT BE AUTOMATED USING AUTOHOTKEY UIA ??
;
; Dependencies
;   - Chrome extension "URL in Title". https://github.com/erichgoldman/add-url-to-window-title
;---------------------------------------------------------------------------------------------------------------------
/******* NEEDS CONVERTED TO AHK v2
#^+g:: {   ; Windows|AHK|Paste selected text into new document on Grammarly.com
	selectedText := GetSelectedTextUsingClipboard()
  Run, "https://app.grammarly.com/docs/new"
	WinWaitActive, Grammarly - https://app.grammarly.com/ddocs, , 15
	If !ErrorLevel
  {
	  Sleep, 1250
    SendInput %selectedText%
    Sleep, 500
  }
}
*/





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
 *  Calendar
 *    ✦ c                Run or activate Outlook and switch to the calendar, using an Outlook
 *                       shortcut
 */
CapsLock & c::           RunOrActivateOutlook("^2")


/**
 *  Inbox
 *    ✦ i                Run or activate Outlook and switch to the inbox, using an Outlook shortcut
 */
CapsLock & i::           RunOrActivateOutlook("^+I")


/**
 *  Jira
 *    ✦ j                Opens the current sprint board
 *    ✦ ^ j              Search for a specific story number to open
 *                         - If the selected text looks like a Jira story number (e.g. 
 *                           PROJECT-1234), then open that story
 *                         - If the Git Bash window has text that looks like a Jira story number, 
 *                           then open that story
 *                         - Last resort is to open the current sprint board
 */
CapsLock & j::           MyJira.OpenJira()


/**
 *  Google search
 *    ✦ g               Search for the selected text
 */
CapsLock & g::           GoogleSearch()


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
 *  Generate a random UUID/GUID
 *    ✦ u                Generate random UUID (lowercase)
 *    ✦ + u              Generate random UUID (uppercase)
 */
CapsLock & u::           SendInput(CreateRandomGUID(GetKeyState("Shift")))



/**
 *  Wiki
 *    ✦ w                Open wiki page
 *    ✦ ^ w              Search the wiki for the selected text
 */
CapsLock & w::           OpenWiki(GetKeyState("Ctrl"))
  




/**
 *  Include all libraries, utilities, and other AutoHotkey scripts
 *
 *  I have to put this at the bottom of my script or it interferes with other code in this script
 */
#Include "%A_ScriptDir%\Common\Common.ahk"
#Include "%A_ScriptDir%\Work\Work Functions.ahk"
#Include "%A_ScriptDir%\Work\Mute VOIP Apps.ahk"
#Include "%A_ScriptDir%\Lib\RunAsAdmin.ahk"