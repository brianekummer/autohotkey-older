/*
; My AutoHotkey Automations - Work
;
;
; Keep in Mind While Developing This
; ----------------------------------
;   - Any use for text-to-speech? ComObject("SAPI.SpVoice").Speak("Speak this phrase")
;   - Popup menus are useful- can I use them elsewhere?
;   - Are timed tooltips useful somewhere?
;   - Are classes useful anywhere?
;
;
; Modifiers
; ---------
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = Hyper 
;
;
;
; Windows Provided
; ----------------
; # -                   Windows          Windows Magnifier -
; # =                   Windows          Windows Magnifier +
; # a                   Windows          Windows Action Center
; # d                   Windows          Windows desktop
; # e                   Windows          Windows Explorer
; # l                   Windows          Lock workstation
; # p                   Windows          Project (duplicate, extend, etc)
; # up                  Windows          Maximize active window
;
;
; Shortcuts
; ---------
; ✦ ^ ! Esc             Windows (AHK)    Reload AHK (emergency restart)
; ✦ b                   Windows (AHK)    Browser
; ✦ c                   Windows (AHK)    Calendar
; ✦ i                   Windows (AHK)    Inbox
; ✦ l                   Windows (AHK)    IntelliJ
; ✦ j                   Windows (AHK)    JIRA- current project board
; ✦ ^ j                 Windows (AHK)    JIRA- open selected story number
; ✦ m                   Windows (AHK)    Music/Spotify
; ✦ n                   Windows (AHK)    Notes (Typora)
; ✦ t                   Windows (AHK)    Terminal/Cmder/bash
; ✦ v                   Windows (AHK)    Visual Studio Code
; PrintScreen           Windows (AHK)    Windows screenshot tool
;
;
; Personal Shortcuts
; ------------------
; ✦ p                   Windows (AHK)    Personal computer (Parsec)
;                                        Problem is that sometimes pewrsonal computer is locked and need to enter pin.
;                                        I want the pin, so can't automate this. So simply a hotkey to connect to that
;                                        computer.
; ~~✦ F12                 Windows (AHK)    Browser - Open websites of stuff I'm price watching~~
; ~~✦ ! b                 Windows (AHK)    Browser~~
; ~~✦ ! n                 Windows (AHK)    Notes (Typora)~~
; ~~✦ ! t                 Windows (AHK)    Terminal/Cmder/bash~~
; ~~✦ ! v                 Windows (AHK)    Visual Studio Code~~
;
;
; Other Stuff
; -----------
; ✦ RShift              Windows (AHK)    Cycle selected text between lower/upper/sentence/title case
; ✦ u                   Windows (AHK)    Generate a random UUID (lowercase)
; ✦ + u                 Windows (AHK)    Generate a random UUID (uppercase)
;
;
; Media Controls
; --------------
; ✦ WheelUp/WheelDown   Windows (AHK)    Volume up/down
; ✦ LButton             Windows (AHK)    Play/pause
; ✦ RButton             Windows (AHK)    Music app (Spotify)
; ✦ XButton1            Windows (AHK)    Previous track
; ✦ XButton2            Windows (AHK)    Next track
; Mute                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams/Zoom)
;
;
; Home Automation
; ---------------
; (keys listed are numeric keypad)
; ✦ +                   Windows (AHK)     Air cleaner: toggle on/off
; ✦ Enter               Windows (AHK)             Fan: toggle on/off
;
; ✦ 7|8|9               Windows (AHK)       Top light: brightness down|toggle on/off|brightness up
; ✦ 4|5|6               Windows (AHK)    Middle light: brightness down|toggle on/off|brightness up
; ✦ 1|2|3               Windows (AHK)    Bottom light: brightness down|toggle on/off|brightness up
;
; ✦ ^ 7|9               Windows (AHK)       Top light: brightness 1%|brightness 100%
; ✦ ^ 4|6               Windows (AHK)    Middle light: brightness 1%|brightness 100%
; ✦ ^ 1|3               Windows (AHK)    Bottom light: brightness 1%|brightness 100%
;
;
; Customizing Windows Behavior
; ---------------------------
; # Down                Windows (AHK)    Minimize active window (instead of unmaximize, then minimize)
; XButton1              Windows (AHK)    Minimize current application
; XButton2              Windows (AHK)    Minimize app or close window/tab or close app
; (auto-correct)        Windows (AHK)    Auto correct/capitalize lots of words, including first names
;
;
; Customizing App Behavior
; ------------------------
; Slack:
;   ^ mousewheel        Slack (AHK)      Decrease/increase font size
;   ^ k                 Slack (AHK)      Insert hyperlink
;   ✦ [                 Slack (AHK)      Toggle left sidebar
;   ✦ # b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb and presence to away.
;   ✦ # l               Slack (AHK)      Status - At lunch. Sets Slack statuses to lunch and presence to away.
;   ✦ # m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
;   ✦ # p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
;   ✦ # w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
; Typora
;   ^ mousewheel        Typora (AHK)     Decrease/increase font size
;   ✦ [                 Typora (AHK)     Toggle left sidebar
; VS Code
;   ^ mousewheel        VS Code (AHK)    Decrease/increase font size
;   ✦ [                 VS Code (AHK)    Toggle left sidebar
; IntelliJ
;   ✦ [                 IntelliJ (AHK)   Toggle left sidebar
; Visual Studio
;   ✦ [                 VS (AHK)         Make left sidebar (Solution Explorer) appear
;
;
; Code Structure
; --------------
; autohotkey/
; â”œâ”€ experiments/                Temporary things I'm experimenting with
; â”‚  â”œâ”€ trying-to-do-blah.ahk
; â”‚  â””â”€ can-i-do-this.ahk
; â”‚
; â”œâ”€ examples to keep/           Interesting stuff I want to keep but am not using
; â”‚  â””â”€ example1.ahk
; â”‚
; â”œâ”€ lib/                        Libraries of other people's work that I'm using
; â”‚  â”œâ”€ AutoCorrect.ahk
; â”‚  â”œâ”€ RunAsAdmin.ahk
; â”‚  â””â”€ FindText.ahk             ** TODO- AM I GOING TO USE THIS???
; â”‚
; â”œâ”€ Configure.bat               Batch file to configure by setting environment variables
; â”œâ”€ Main.ahk                    Main code, mostly hotkeys that call functions
; â”œâ”€ Functions.ahk               Majority of my code is here
; â”œâ”€ Convert Case.ahk            Cycle through lower/upper/sentence/title case
; â”œâ”€ Customize Windows.ahk       Code that customizes how Windows works
; â”œâ”€ My Auto Correct.ahk         My wrapper over AutoCorrect.ahk that includes my words to correct
; â”œâ”€ Slack.ahk                   Controlling Slack
; â””â”€ Utilities.ahk               Utility functions
;
;
;
; ============================================================================================
; TO DO ITEMS
; ============================================================================================
; HIGH PRIORITY
; MUTE                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams)
;             Look at how Hammerspoon plugin works?
;             - when in Teams meeting, window title is "... | Microsoft Teams"
;             - Also, if use Play/Pause media button also, then can use this from my headset-- don't
;               even have to touch the keyboard
;          https://github.com/stajp/Teams_mute_AHK
;          https://github.com/tdalon/ahk/blob/main/Lib/Teams.ahk
;          predictably, using nircmd does NOT cause Teams mute icon to toggle
;          https://greiginsydney.com/make-microsoft-teams-shortcuts-global/
;
;         THESE TWO LOOK LIKE **ONLY** OPTION
;         This 
;         https://stackoverflow.com/questions/66567191/how-to-get-the-microsoft-teams-active-meeting-window-with-autohotkey
;         is slightly stripped down version of this
;         https://github.com/tdalon/ahk/blob/main/Lib/Teams.ahk
;
;
; Why does CapsLock sometimes get stuck? Is that a big enough reason to abandon it?
;
;
; VISUAL STUDIO
;   - Moved Solution Explorer to left side, pinned
;   - ^!l shows it 
;   - +{Esc} makes it go away
;   - CAN I GET IT WORKING WITH AHK??? ✦ [
;        - Can't tell by the active window. maybe I can loop through all the active windows in
;
;
;
;
;
;
; Customizing App Behavior
; ------------------------
; Slack:
;   ✦ ! f               Slack (AHK)      Status - Focusing - what to do on Windows??
; VS Code
;   ~$^s                VS Code (AHK)    After save AHK file, reload current script
;
;
; standardize video keys for youtube and udemy
;
; LOW PRIORITY
; ✦ ^ v                 Windows (AHK)    VS Code- smart (create new doc, paste selected text, format it)
;
;
; EVALUATE ALL OF THIS
; ALL OF THIS IS TEMPORARY STUFF THAT WILL BE EVALUATED
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
; >> Most of this is in my old code: https://github.com/brianekummer/autohotkey/blob/master/My%20Automations.ahk
;
;   H âŒ˜ f          HS       Focusing. Starts Do Not Disturb timer for 30 minutes, 
;                           which also sets Slack statuses to heads-down.
;   H âŒ˜ s          HS       Studying. Starts Do Not Disturb timer for 60 minutes,
;                           which also sets Slack statuses to books and opens udemy.com.
;
; (on login/unlock)  Windows (AHK)       Set Slack status based on nearby wifi networks
; #numpadsub         Windows (AHK)       TEMP - price checks
; #space             Windows (AHK)       Toggle dark mode for active application
;
; GRAMMARLY? I CODED IT BEFORE, SO SHOULD LOOK INTO IF IT STILL WORKS !!
;
; Window management
; H left         HS       Snap active window to left half/third/two-thirds of the screen
; H right        HS       Snap active window to right half/third/two-thirds of the screen
; H up           HS       Snap active window to top half/third/two-thirds of the screen
; H down         HS       Snap active window to top half/third/two-thirds of the screen
; H return HS       Toggle full screen
; H âŒ˜ up         HS       Maximize window
; H âŒ˜ down       HS       Minimize window
; H âŒ˜ left       HS       Move active window to the previous screen
; H âŒ˜ right      HS       Move active window to the next screen
; ============================================================================================
;
;
; TODO-
;  For home automation, try having work computer SSH into my personal laptop to do the home
;  automation, which will remove the environmental variables on my work laptop that have my 
;  Wyze and VeSync usernames and passwords
;
;
;
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
;
;
; Decisions
; ---------
;   - For Chrome extensions
;       - I decided not to use "Add URL to Window Title" because there is no whitelist option, and
;         having URL on every toolbar is ugly. Adding the input field id and name is cool and could
;         be useful for multi-page logins (like timesheet) but that is not REQUIRED for what I need 
;         (yet). https://github.com/erichgoldman/add-url-to-window-title
;
;
; Credits
; -------
;   - CapsLock as a Windows modifier: https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
;                                     https://www.autohotkey.com/boards/viewtopic.php?t=70854
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
  Global variables
*/
global WindowsLocalAppDataFolder
global WindowsProgramFilesX86Folder
global WindowsProgramFilesFolder
global WindowsUserName
global WindowsUserDomain
global WindowsUserProfile
global MyDocumentsFolder
global UserEmailAddress
global IsWorkLaptop
WindowsLocalAppDataFolder := EnvGet("LOCALAPPDATA")
WindowsProgramFilesX86Folder := EnvGet("PROGRAMFILES(X86)")
WindowsProgramFilesFolder := EnvGet("PROGRAMFILES")
WindowsUserName := EnvGet("USERNAME")
WindowsUserDomain := EnvGet("USERDOMAIN")
WindowsUserProfile := EnvGet("USERPROFILE")
MyPersonalFolder := EnvGet("PERSONAL_FILES")
UserEmailAddress := EnvGet("USERNAME") "@" EnvGet("USERDNSDOMAIN")
IsWorkLaptop := true

; These come from my Windows environment variables. See "Configure.bat" for details
global MyPersonalFolder
global MyPersonalDocumentsFolder
global JiraUrl
global JiraMyProjectKeys
global JiraDefaultProjectKey
global JiraDefaultRapidKey
global JiraDefaultSprint
global SourceCodeUrl
global SourceSchemaUrl
global SlackStatusUpdate_OfficeNetworks
global ParsecPeerId
MyPersonalFolder := EnvGet("PERSONAL_FILES")
MyPersonalDocumentsFolder := MyPersonalFolder . "\Documents\"
JiraUrl := EnvGet("AHK_JIRA_URL")
JiraMyProjectKeys := EnvGet("AHK_JIRA_MY_PROJECT_KEYS")
JiraDefaultProjectKey := EnvGet("AHK_JIRA_DEFAULT_PROJECT_KEY")
JiraDefaultRapidKey := EnvGet("AHK_JIRA_DEFAULT_RAPID_KEY")
JiraDefaultSprint := EnvGet("AHK_JIRA_DEFAULT_SPRINT")
SourceCodeUrl := EnvGet("AHK_SOURCE_CODE_URL")
SourceSchemaUrl := EnvGet("AHK_SOURCE_CODE_SCHEMA_URL")
SlackStatusUpdate_OfficeNetworks := EnvGet("SLACK_OFFICE_NETWORKS")
ParsecPeerId := EnvGet("PARSEC_PEER_ID")


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
      ✦ # b              Status - Be Right Back. Sets Slack statuses to brb.
      ✦ # c              Status - Cleared. Clears Slack status.
      ✦ # e              Status - Eating. Sets Slack statuses to lunch/dinner.
                          Also locks my laptop and turns off my office lights if I'm at home.
      ✦ # m              Status - In a meeting. Sets Slack statuses to mtg.
      ✦ # p              Status - Playing. Sets home Slack status to 8bit.
      ✦ # w              Status - Working. Clears Slack statuses.
*/
CapsLock & k::           OpenSlack((GetKeyState("Ctrl") ? "^k" : ""))    

#HotIf WinActive("ahk_exe i)\\slack\.exe$", )
  ^wheelup::             SendInput("^{=}")
  ^wheeldown::           SendInput("^{-}")
  CapsLock & [::         SendInput("^+{d}")
  ^k::                   SendInput("^+{u}")
#HotIf

; Since upgrading to AHK v2, Windows key was opening the Start menu. So I switched to using
; the Alt key.
#HotIf GetKeyState("Alt")
  CapsLock & b::         SlackStatusUpdate_SetSlackStatusAndPresence("brb", "away")
  CapsLock & c::         SlackStatusUpdate_SetSlackStatusAndPresence("none", "auto")
  CapsLock & e::         SlackStatus_Eating()
  CapsLock & m::         SlackStatusUpdate_SetSlackStatusAndPresence("meeting", "auto")
  CapsLock & p::         SlackStatusUpdate_SetHomeSlackStatus("playing")
  CapsLock & w::         SlackStatus_Working()
#HotIf

OpenSlack(shortcut := "")
{
  RunOrActivateAppOrUrl("ahk_exe slack.exe", WindowsLocalAppDataFolder "\Slack\Slack.exe", 3, True)
  if (shortcut != "")
    SendInput(shortcut)
  return
}

SlackStatus_Eating()
{
  if (A_Hour < 15)   ; Before 3:00 pm
    SlackStatusUpdate_SetSlackStatusAndPresence("lunch", "away")
  else
    SlackStatusUpdate_SetSlackStatusAndPresence("dinner", "away")

  if AmNearWifiNetwork("(kummer)")
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom off")
  DllCall("user32.dll\LockWorkStation")
  return
}

SlackStatus_Working()
{
  if AmNearWifiNetwork(SlackStatusUpdate_OfficeNetworks)
    SlackStatusUpdate_SetSlackStatusAndPresence("workingInOffice", "auto")
  else
    SlackStatusUpdate_SetSlackStatusAndPresence("workingRemotely", "auto")
  return
}


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
  JIRA
    ✦ j                  Opens the current board
    ✦ ^ j                Opens the selected story number
                           * If the highlighted text looks like a JIRA story number (e.g. 
                             PROJECT-1234), then open that story
                           * If the Git Bash window has text that looks like a JIRA story number, 
                             then open that story
                           * Last resort is to open the current board
*/
CapsLock & j::           JIRA()


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
CapsLock & s:: 
{
  if GetKeyState("Ctrl")
    RunOrActivateAppOrUrl("eventschema", SourceSchemaUrl, 3, True, False)
  else
    RunOrActivateAppOrUrl("overview", SourceCodeUrl, 3, True, False)
  return
}


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
CapsLock & l::           RunOrActivateAppOrUrl("ahk_exe i)\\idea64\.exe$", WindowsProgramFilesFolder "\JetBrains\IntelliJ IDEA Community Edition 2021.2.3\bin\idea64.exe")
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
CapsLock & u::            GenerateGUID(GetKeyState("Shift"))




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