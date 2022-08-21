;--------------------------------------------------------------------------------------------------
; My AutoHotKey Automations - Work
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
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      â‡ª = CapsLock/Hyper
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
; â‡ª ^ ! Esc             Windows (AHK)    Reload AHK (emergency restart)
; â‡ª b                   Windows (AHK)    Browser
; â‡ª c                   Windows (AHK)    Calendar
; â‡ª i                   Windows (AHK)    Inbox
; â‡ª l                   Windows (AHK)    IntelliJ
; â‡ª j                   Windows (AHK)    JIRA- current project board
; â‡ª ^ j                 Windows (AHK)    JIRA- open selected story number
; â‡ª m                   Windows (AHK)    Music/Spotify
; â‡ª n                   Windows (AHK)    Notes (Typora)
; â‡ª t                   Windows (AHK)    Terminal/Cmder/bash
; â‡ª v                   Windows (AHK)    Visual Studio Code
; PrintScreen           Windows (AHK)    Windows screenshot tool
;
;
; Personal Shortcuts
; ------------------
; â‡ª p                   Windows (AHK)    Personal computer (Parsec)
;                                        Problem is that sometimes pewrsonal computer is locked and need to enter pin.
;                                        I want the pin, so can't automate this. So simply a hotkey to connect to that
;                                        computer.
; ~~â‡ª F12                 Windows (AHK)    Browser - Open websites of stuff I'm price watching~~
; ~~â‡ª ! b                 Windows (AHK)    Browser~~
; ~~â‡ª ! n                 Windows (AHK)    Notes (Typora)~~
; ~~â‡ª ! t                 Windows (AHK)    Terminal/Cmder/bash~~
; ~~â‡ª ! v                 Windows (AHK)    Visual Studio Code~~
;
;
; Other Stuff
; -----------
; â‡ª RShift              Windows (AHK)    Cycle selected text between lower/upper/sentence/title case
; â‡ª u                   Windows (AHK)    Generate a random UUID (lowercase)
; â‡ª + u                 Windows (AHK)    Generate a random UUID (uppercase)
;
;
; Media Controls
; --------------
; â‡ª WheelUp/WheelDown   Windows (AHK)    Volume up/down
; â‡ª LButton             Windows (AHK)    Play/pause
; â‡ª RButton             Windows (AHK)    Music app (Spotify)
; â‡ª XButton1            Windows (AHK)    Previous track
; â‡ª XButton2            Windows (AHK)    Next track
; Mute                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams/Zoom)
;
;
; Home Automation
; ---------------
; (keys listed are numeric keypad)
; â‡ª +                   Windows (AHK)     Air cleaner: toggle on/off
; â‡ª Enter               Windows (AHK)             Fan: toggle on/off
;
; â‡ª 7|8|9               Windows (AHK)       Top light: brightness down|toggle on/off|brightness up
; â‡ª 4|5|6               Windows (AHK)    Middle light: brightness down|toggle on/off|brightness up
; â‡ª 1|2|3               Windows (AHK)    Bottom light: brightness down|toggle on/off|brightness up
;
; â‡ª ^ 7|9               Windows (AHK)       Top light: brightness 1%|brightness 100%
; â‡ª ^ 4|6               Windows (AHK)    Middle light: brightness 1%|brightness 100%
; â‡ª ^ 1|3               Windows (AHK)    Bottom light: brightness 1%|brightness 100%
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
;   â‡ª [                 Slack (AHK)      Toggle left sidebar
;   â‡ª # b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb and presence to away.
;   â‡ª # l               Slack (AHK)      Status - At lunch. Sets Slack statuses to lunch and presence to away.
;   â‡ª # m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
;   â‡ª # p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
;   â‡ª # w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
; Typora
;   ^ mousewheel        Typora (AHK)     Decrease/increase font size
;   â‡ª [                 Typora (AHK)     Toggle left sidebar
; VS Code
;   ^ mousewheel        VS Code (AHK)    Decrease/increase font size
;   â‡ª [                 VS Code (AHK)    Toggle left sidebar
; IntelliJ
;   â‡ª [                 IntelliJ (AHK)   Toggle left sidebar
; Visual Studio
;   â‡ª [                 VS (AHK)         Make left sidebar (Solution Explorer) appear
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
;   - CAN I GET IT WORKING WITH AHK??? â‡ª [
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
;   â‡ª ! f               Slack (AHK)      Status - Focusing - what to do on Windows??
; VS Code
;   ~$^s                VS Code (AHK)    After save AHK file, reload current script
;
;
; standardize video keys for youtube and udemy
;
; LOW PRIORITY
; â‡ª ^ v                 Windows (AHK)    VS Code- smart (create new doc, paste selected text, format it)
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
;   - Definition of AutoHotKey keys: http://www.autohotkey.com/docs/KeyList.htm
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
;--------------------------------------------------------------------------------------------------



;---------------------------------------------------------------------------------------------------------------------
; AutoHotKey configuration options
;---------------------------------------------------------------------------------------------------------------------
; #Warn                         ; Enable warnings to assist with detecting common errors
#SingleInstance FORCE           ; Skip invocation dialog box and silently replace previously executing instance of this script
Persistent                       ; I ASSUME THIS IS NECESSARY W/V2???
SendMode("Input")               ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir)      ; Ensures a consistent starting directory

SetTitleMatchMode("RegEx")      ; Make windowing commands use regex
RunAsAdmin()

SetCapsLockState("AlwaysOff")   ; Disable the CapsLock LED on my keyboard
SetNumLockState("On")           ; Turn on Scroll Lock, so my macros with keypad work



;---------------------------------------------------------------------------------------------------------------------
; Global variables
;---------------------------------------------------------------------------------------------------------------------
Global WindowsLocalAppDataFolder
Global WindowsProgramFilesX86Folder
Global WindowsProgramFilesFolder
Global WindowsUserName
Global WindowsUserDomain
Global WindowsUserProfile
Global MyDocumentsFolder
Global UserEmailAddress
Global IsWorkLaptop
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
Global MyPersonalFolder
Global MyPersonalDocumentsFolder
Global JiraUrl
Global JiraMyProjectKeys
Global JiraDefaultProjectKey
Global JiraDefaultRapidKey
Global JiraDefaultSprint
Global SourceCodeUrl
Global SourceSchemaUrl
Global SlackStatusUpdate_OfficeNetworks
Global ParsecPeerId
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




;---------------------------------------------------------------------------------------------------------------------
; This code executes when the script starts
;---------------------------------------------------------------------------------------------------------------------

; Configure Slack status updates based on the network. *REQUIRES* several Windows environment variables - see 
; "Slack.ahk" for details
SlackStatusUpdate_Initialize()
SlackStatusUpdate_SetSlackStatusBasedOnNetwork()
Return



;--------------------------------------------------------------------------------------------------
; Toggle mute in VOIP apps (Slack/Microsoft Teams/Zoom/Google Meet)
;   Mute                 Activate the current VOIP call/meeting and toggles mute
;--------------------------------------------------------------------------------------------------
Volume_Mute::            ToggleMuteVOIPApps()


;--------------------------------------------------------------------------------------------------
; When looking at my personal laptop
;   â‡ª [                  On my personal laptop, toggle left sidebar
;--------------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe parsecd.exe", )
  CapsLock & [::         SendKeystrokesToPersonalLaptop("{CapsLock down}[{CapsLock up}")
#HotIf


;---------------------------------------------------------------------------------------------------------------------
; Slack
;   â‡ª k                  Open Slack
;   â‡ª ^ k                Open Slack and go to the "jump to" window
;   â‡ª [                  Toggle left sidebar
;   ^ mousewheel         Decrease/increase font size
;   ^ k                  Insert hyperlink (overrides Slack opening "jump to" window)
;   Statuses
;     â‡ª # b              Status - Be Right Back. Sets Slack statuses to brb.
;     â‡ª # c              Status - Cleared. Clears Slack status.
;     â‡ª # e              Status - Eating. Sets Slack statuses to lunch/dinner.
;                        Also locks my laptop and turns off my office lights if I'm at home.
;     â‡ª # m              Status - In a meeting. Sets Slack statuses to mtg.
;     â‡ª # p              Status - Playing. Sets home Slack status to 8bit.
;     â‡ª # w              Status - Working. Clears Slack statuses.
;---------------------------------------------------------------------------------------------------------------------
CapsLock & k::           OpenSlack((GetKeyState("Ctrl") ? "^k" : ""))    

#HotIf WinActive("ahk_exe i)\\slack\.exe$", )
  ^wheelup::  SendInput("^{=}")
  ^wheeldown::  SendInput("^{-}")
  CapsLock & [::  SendInput("^+{d}")
  ^k::  SendInput("^+{u}")
#HotIf

; Since upgrading to AHK v2, Windows key was opening the Start menu. So I switched to using
; the Alt key.
; Also couldn't get this working w/AHK v2: https://github.com/HelgeffegleH/longhotkey
; #HotIf GetKeyState("LWin")
;   CapsLock & b::         SlackStatusUpdate_SetSlackStatusAndPresence("brb", "away")
;   CapsLock & e::         SlackStatus_Eating()
;   CapsLock & m::         SlackStatusUpdate_SetSlackStatusAndPresence("meeting", "auto")
;   CapsLock & p::         SlackStatusUpdate_SetHomeSlackStatus("playing")
;   CapsLock & w::         SlackStatus_Working()
; #HotIf

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
  RunOrActivateAppOrUrl("ahk_exe slack.exe", WindowsLocalAppDataFolder . "\Slack\Slack.exe", 3, True)
  if (shortcut != "")
    SendInput(shortcut)
  Return
}

SlackStatus_Eating()
{
  If (A_Hour < 15)   ; Before 3:00 pm
  {
    SlackStatusUpdate_SetSlackStatusAndPresence("lunch", "away")
  }
  Else
  {
    SlackStatusUpdate_SetSlackStatusAndPresence("dinner", "away")
  }
  If AmNearWifiNetwork("(kummer)")
  {
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom off")
  }
  DllCall("user32.dll\LockWorkStation")
  Return
}

SlackStatus_Working()
{
  If AmNearWifiNetwork(SlackStatusUpdate_OfficeNetworks)
  {
    ;Msgbox Am in the office
    SlackStatusUpdate_SetSlackStatusAndPresence("workingInOffice", "auto")
  }
  Else
  {
    ;Msgbox Am at home
    SlackStatusUpdate_SetSlackStatusAndPresence("workingRemotely", "auto")
  }
  Return
}


;--------------------------------------------------------------------------------------------------
; Calendar
;   â‡ª c                  Run or activate Outlook and switch to the calendar, using an Outlook
;                        shortcut to switch to the calendar
;--------------------------------------------------------------------------------------------------
CapsLock & c::           ActivateOrStartMicrosoftOutlook("^2")


;--------------------------------------------------------------------------------------------------
; Inbox
;   â‡ª i                  Run or activate Outlook and switch to the inbox, using an Outlook shortcut
;                        to switch to the inbox
;--------------------------------------------------------------------------------------------------
CapsLock & i::           ActivateOrStartMicrosoftOutlook("^+I")


;--------------------------------------------------------------------------------------------------
; JIRA
;   â‡ª j                  Opens the current board
;   â‡ª ^ j                Opens the selected story number
;                          * If the highlighted text looks like a JIRA story number (e.g. 
;                            PROJECT-1234), then open that story
;                          * If the Git Bash window has text that looks like a JIRA story number, 
;                            then open that story
;                          * Last resort is to open the current board
;--------------------------------------------------------------------------------------------------
CapsLock & j::           JIRA()


;--------------------------------------------------------------------------------------------------
; Music/Spotify
;   â‡ª m                  Run or activate Spotify
;--------------------------------------------------------------------------------------------------
CapsLock & m::           RunOrActivateSpotify()
#HotIf WinActive("ahk_exe i)\\spotify\.exe$", )
  ^wheelup::  SendInput("^{=}")
  ^wheeldown::  SendInput("^{-}")
#HotIf
  


;--------------------------------------------------------------------------------------------------
; Personal computer
;   â‡ª p                  Connect to personal computer
;--------------------------------------------------------------------------------------------------
CapsLock & p::           ConnectToPersonalComputer()



;--------------------------------------------------------------------------------------------------
; Source code
;   â‡ª s                  Source code/BitBucket
;   â‡ª ^ s                Source code/BitBucket- schemas
;--------------------------------------------------------------------------------------------------
CapsLock & s:: 
{
  If GetKeyState("Ctrl")
  {
    RunOrActivateAppOrUrl("eventschema", SourceSchemaUrl, 3, true, false)
  }
  Else
  {
    RunOrActivateAppOrUrl("overview", SourceCodeUrl, 3, true, false)
  }
  Return
}


;--------------------------------------------------------------------------------------------------
; Visual Studio
;   â‡ª [                  Toggle left sidebar
;                        Use Shift+Esc to exit, or click outside
;                        I could not find a way to determine if the Solution Explorer was open or 
;                        not, to determine if I should do â‡ª[ or +{Esc}
;--------------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe i)\\devenv\.exe$", )
  CapsLock & [::  SendInput("^!l")
#HotIf


;--------------------------------------------------------------------------------------------------
; IntelliJ
;   â‡ª l                  Start IntelliJ
;   â‡ª [                  Toggle left sidebar
;--------------------------------------------------------------------------------------------------
CapsLock & l::           RunOrActivateAppOrUrl("ahk_exe i)\\idea64\.exe$", WindowsProgramFilesFolder . "\JetBrains\IntelliJ IDEA Community Edition 2021.2.3\bin\idea64.exe")
#HotIf WinActive("ahk_exe i)\\idea64\.exe$", )
  CapsLock & [::  SendInput("!1")
#HotIf


;--------------------------------------------------------------------------------------------------
; Home automation
;   (keys listed are on the numeric keypad)
;   â‡ª +                   Air cleaner: toggle on/off
;
;   â‡ª Enter                       Fan: toggle on/off
;
;   â‡ª 7|8|9                 Top light: brightness down|toggle on/off|brightness up
;   â‡ª ^ 7|9                 Top light: brightness 1%|brightness 100%
;
;   â‡ª 4|5|6              Middle light: brightness down|toggle on/off|brightness up
;   â‡ª ^ 4|6              Middle light: brightness 1%|brightness 100%
;
;   â‡ª 1|2|3              Bottom light: brightness down|toggle on/off|brightness up
;   â‡ª ^ 1|3              Bottom light: brightness 1%|brightness 100%
;
;
; DISABLED
;  â‡ª ^ +                 Air cleaner: cycle between fan speeds
;                        THIS IS VALID FOR VESYNC AIR CLEANER, NOT WYZE PLUG
;--------------------------------------------------------------------------------------------------
CapsLock & NumpadAdd::   HomeAutomationCommand("officeac  toggle")     
CapsLock & NumpadEnter:: HomeAutomationCommand("officefan toggle")

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


;---------------------------------------------------------------------------------------------------------------------
; Generate a UUID/GUID
;   â‡ª u                  Generate random UUID (lowercase)
;   â‡ª + u                Generate random UUID (uppercase)
;---------------------------------------------------------------------------------------------------------------------
CapsLock & u::             GenerateGUID(GetKeyState("Shift"))




;--------------------------------------------------------------------------------------------------
; Include all libraries, utilities, and other AutoHotKey scripts
;
; I have to put this at the bottom of my script, or else it interferes with other code in this script
;--------------------------------------------------------------------------------------------------
#Include "%A_ScriptDir%\Shared_v2.ahk"
#Include "%A_ScriptDir%\Functions_v2.ahk"
#Include "%A_ScriptDir%\Utilities_v2.ahk"
#Include "%A_ScriptDir%\Customize Windows_v2.ahk"
#Include "%A_ScriptDir%\My Auto Correct_v2.ahk"
#Include "%A_ScriptDir%\Convert Case_v2.ahk"

#Include "%A_ScriptDir%\Slack_v2.ahk"
#Include "%A_ScriptDir%\Mute VOIP Apps_v2.ahk"

#Include "%A_ScriptDir%\lib\RunAsAdmin_v2.ahk"
