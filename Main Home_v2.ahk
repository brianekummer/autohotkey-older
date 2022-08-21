/*
  My AutoHotKey Automations - Home
 
 
  Keep in Mind While Developing This
  ----------------------------------
    - Any use for text-to-speech? ComObject("SAPI.SpVoice").Speak("Speak this phrase")
    - Popup menus are useful- can I use them elsewhere?
    - Are timed tooltips useful somewhere?
    - Are classes useful anywhere?


  Modifiers
  ---------
  ^ = Ctrl     ! = Alt     + = Shift     # = Windows      â‡ª = CapsLock/Hyper


  Windows Provided
  ----------------
  # -                   Windows          Windows Magnifier -
  # =                   Windows          Windows Magnifier +
  # a                   Windows          Windows Action Center
  # d                   Windows          Windows desktop
  # e                   Windows          Windows Explorer
  # l                   Windows          Lock workstation
  # p                   Windows          Project (duplicate, extend, etc)
  # up                  Windows          Maximize active window


  Shortcuts
  ---------
  â‡ª ^ ! Esc             Windows (AHK)    Reload AHK (emergency restart)
  â‡ª b                   Windows (AHK)    Browser
  â‡ª c                   Windows (AHK)    Calendar
  â‡ª i                   Windows (AHK)    Inbox
  â‡ª j                   Windows (AHK)    JIRA- current project board
  â‡ª ^ j                 Windows (AHK)    JIRA- open selected story number
  â‡ª m                   Windows (AHK)    Music/Spotify
  â‡ª t                   Windows (AHK)    Terminal/Cmder/bash
  PrintScreen           Windows (AHK)    Windows screenshot tool


  Other Stuff
  -----------
  â‡ª RShift              Windows (AHK)    Cycle selected text between lower/upper/sentence/title case
  â‡ª u                   Windows (AHK)    Generate a random UUID (lowercase)
  â‡ª + u                 Windows (AHK)    Generate a random UUID (uppercase)


  Media Controls
  --------------
  â‡ª WheelUp/WheelDown   Windows (AHK)    Volume up/down
  â‡ª LButton             Windows (AHK)    Play/pause
  â‡ª RButton             Windows (AHK)    Music app (Spotify)
  â‡ª XButton1            Windows (AHK)    Previous track
  â‡ª XButton2            Windows (AHK)    Next track
  Mute                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams/Zoom)


  ?????
 ^#pause::Run("nircmd setdefaultsounddevice `"Headphones`"", , "Hide")      ; ^numlock = ^pause
 ^#numpadsub::Run("nircmd setdefaultsounddevice `"Headset`"", , "Hide")


  Home Automation
  ---------------
  (keys listed are numeric keypad)
  â‡ª +                   Windows (AHK)     Air cleaner: toggle on/off
  â‡ª Enter               Windows (AHK)             Fan: toggle on/off

  â‡ª 7|8|9               Windows (AHK)       Top light: brightness down|toggle on/off|brightness up
  â‡ª 4|5|6               Windows (AHK)    Middle light: brightness down|toggle on/off|brightness up
  â‡ª 1|2|3               Windows (AHK)    Bottom light: brightness down|toggle on/off|brightness up

  â‡ª ^ 7|9               Windows (AHK)       Top light: brightness 1%|brightness 100%
  â‡ª ^ 4|6               Windows (AHK)    Middle light: brightness 1%|brightness 100%
  â‡ª ^ 1|3               Windows (AHK)    Bottom light: brightness 1%|brightness 100%


  Customizing Windows Behavior
  ---------------------------
  # Down                Windows (AHK)    Minimize active window (instead of unmaximize, then minimize)
  XButton1              Windows (AHK)    Minimize current application
  XButton2              Windows (AHK)    Minimize app or close window/tab or close app
  (auto-correct)        Windows (AHK)    Auto correct/capitalize lots of words, including first names


  Customizing App Behavior
  ------------------------
  Slack:
    ^ mousewheel        Slack (AHK)      Decrease/increase font size
    ^ k                 Slack (AHK)      Insert hyperlink
    â‡ª [                 Slack (AHK)      Toggle left sidebar
    â‡ª ! b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb and presence to away.
    â‡ª ! c               Slack (AHK)      Status - Clear. Clears my Slack statuses.
    â‡ª ! l               Slack (AHK)      Status - At lunch. Sets Slack statuses to lunch and presence to away.
    â‡ª ! m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
    â‡ª ! p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
    â‡ª ! w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
  Typora
    ^ mousewheel        Typora (AHK)     Decrease/increase font size
    â‡ª [                 Typora (AHK)     Toggle left sidebar
  VS Code
    ^ mousewheel        VS Code (AHK)    Decrease/increase font size
    â‡ª [                 VS Code (AHK)    Toggle left sidebar
  IntelliJ
    â‡ª [                 IntelliJ (AHK)   Toggle left sidebar
  Visual Studio
    â‡ª [                 VS (AHK)         Make left sidebar (Solution Explorer) appear


  Code Structure
  --------------
  autohotkey/
  â”œâ”€ experiments/                Temporary things I'm experimenting with
  â”‚  â”œâ”€ trying-to-do-blah.ahk
  â”‚  â””â”€ can-i-do-this.ahk
  â”‚
  â”œâ”€ examples to keep/           Interesting stuff I want to keep but am not using
  â”‚  â””â”€ example1.ahk
  â”‚
  â”œâ”€ lib/                        Libraries of other people's work that I'm using
  â”‚  â”œâ”€ AutoCorrect.ahk
  â”‚  â”œâ”€ RunAsAdmin.ahk
  â”‚  â””â”€ FindText.ahk             ** TODO- AM I GOING TO USE THIS???
  â”‚
  â”œâ”€ Configure.bat               Batch file to configure by setting environment variables
  â”œâ”€ Main.ahk                    Main code, mostly hotkeys that call functions
  â”œâ”€ Functions.ahk               Majority of my code is here
  â”œâ”€ Convert Case.ahk            Cycle through lower/upper/sentence/title case
  â”œâ”€ Customize Windows.ahk       Code that customizes how Windows works
  â”œâ”€ My Auto Correct.ahk         My wrapper over AutoCorrect.ahk that includes my words to correct
  â”œâ”€ Slack.ahk                   Controlling Slack
  â””â”€ Utilities.ahk               Utility functions


  ============================================================================================
  TO DO ITEMS
  ============================================================================================
  HIGH PRIORITY
  MUTE                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams)
             Look at how Hammerspoon plugin works?
             - when in Teams meeting, window title is "... | Microsoft Teams"
             - Also, if use Play/Pause media button also, then can use this from my headset-- don't
               even have to touch the keyboard
          https://github.com/stajp/Teams_mute_AHK
          https://github.com/tdalon/ahk/blob/main/Lib/Teams.ahk
          predictably, using nircmd does NOT cause Teams mute icon to toggle
          https://greiginsydney.com/make-microsoft-teams-shortcuts-global/

          THESE TWO LOOK LIKE **ONLY** OPTION
          This 
          https://stackoverflow.com/questions/66567191/how-to-get-the-microsoft-teams-active-meeting-window-with-autohotkey
          is slightly stripped down version of this
          https://github.com/tdalon/ahk/blob/main/Lib/Teams.ahk


  VISUAL STUDIO
    - Moved Solution Explorer to left side, pinned
    - ^!l shows it 
    - +{Esc} makes it go away
    - CAN I GET IT WORKING WITH AHK??? â‡ª [
         - Can't tell by the active window. maybe I can loop through all the active windows in




  â‡ª v                   Windows (AHK)    VS Code
  â‡ª ^ v                 Open VS Code, create a new doc, paste selected text, then format it


  Customizing App Behavior
  ------------------------
  Slack:
    â‡ª ! f               Slack (AHK)      Status - Focusing - what to do on Windows??
  VS Code
    ~$^s                VS Code (AHK)    After save AHK file, reload current script
  

  standardize video keys for youtube and udemy

  LOW PRIORITY
  â‡ª ^ v                 Windows (AHK)    VS Code- smart (create new doc, paste selected text, format it)


  EVALUATE ALL OF THIS
  ALL OF THIS IS TEMPORARY STUFF THAT WILL BE EVALUATED

  DEPENDENCIES
  ------------
  * IntelliJ
      - Plugin "macOS Dark Mode Sync" by Johnathan Gilday automatically 
        switches between Darcula and Intellij when OS changes
  * Chrome extension "Dark Reader"
  * VS Code extension "theme-switcher" by latusinski to toggle between light
   and dark mode

>> Most of this is in my old code: https://github.com/brianekummer/autohotkey/blob/master/My%20Automations.ahk

    H âŒ˜ f          HS       Focusing. Starts Do Not Disturb timer for 30 minutes, 
                            which also sets Slack statuses to heads-down.
    H âŒ˜ s          HS       Studying. Starts Do Not Disturb timer for 60 minutes,
                            which also sets Slack statuses to books and opens udemy.com.

  (on login/unlock)  Windows (AHK)       Set Slack status based on nearby wifi networks
  #numpadsub         Windows (AHK)       TEMP - price checks
  #space             Windows (AHK)       Toggle dark mode for active application

  GRAMMARLY? I CODED IT BEFORE, SO SHOULD LOOK INTO IF IT STILL WORKS !!

  Window management
  H left         HS       Snap active window to left half/third/two-thirds of the screen
  H right        HS       Snap active window to right half/third/two-thirds of the screen
  H up           HS       Snap active window to top half/third/two-thirds of the screen
  H down         HS       Snap active window to top half/third/two-thirds of the screen
  H return HS       Toggle full screen
  H âŒ˜ up         HS       Maximize window
  H âŒ˜ down       HS       Minimize window
  H âŒ˜ left       HS       Move active window to the previous screen
  H âŒ˜ right      HS       Move active window to the next screen
  





  Notes
  -----
    - Near the bottom of this script are a number of #include statements to include libraries of 
      utility functions
    - Using regex in "#IfWinActive ahk_exe i)\\xxxx\.exe$" requires "SetTitleMatchMode RegEx"
    - This script must be run as an admin or else any app run as an admin (i.e. Visual Studio,
      Visual Studio Code, etc.) will intercept the keystrokes before this script.
    - Definition of AutoHotKey keys: http://www.autohotkey.com/docs/KeyList.htm
    - This looks helpful: http://www.daviddeley.com/autohotkey/xprxmp/autohotkey_expression_examples.htm


  Dependencies
  ------------
    - IntelliJ
        - Enabled option: Editor > General > Change font size (Zoom) with Ctrl+MouseWheel
    - nircmd, for "setdefaultsounddevice" to switch between headphones and headset


  Decisions
  ---------
    - For Chrome extensions
        - I decided not to use "Add URL to Window Title" because there is no whitelist option, and
          having URL on every toolbar is ugly. Adding the input field id and name is cool and could
          be useful for multi-page logins (like timesheet) but that is not REQUIRED for what I need 
          (yet). https://github.com/erichgoldman/add-url-to-window-title


  Credits
  -------
    - CapsLock as a Windows modifier: https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
                                      https://www.autohotkey.com/boards/viewtopic.php?t=70854
*/


/*
  AutoHotKey configuration options
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
global WindowsLocalAppDataFolder
global WindowsProgramFilesX86Folder
global WindowsProgramFilesFolder
global WindowsUserName
global WindowsUserDomain
global WindowsUserProfile
global MyDocumentsFolder
WindowsLocalAppDataFolder := EnvGet("LOCALAPPDATA")
WindowsProgramFilesX86Folder := EnvGet("PROGRAMFILES(X86)")
WindowsProgramFilesFolder := EnvGet("PROGRAMFILES")
WindowsUserName := EnvGet("USERNAME")
WindowsUserDomain := EnvGet("USERDOMAIN")
WindowsUserProfile := EnvGet("USERPROFILE")
MyDocumentsFolder := WindowsUserProfile . "\Documents\"

; These come from my Windows environment variables. See "Configure.bat" for details
global MyPersonalFolder
global MyPersonalDocumentsFolder
MyPersonalFolder := EnvGet("PERSONAL_FILES")
MyPersonalDocumentsFolder := MyPersonalFolder . "\Documents\"


/*
  This code executes when the script starts
*/
return




/*
  Emergency Reload
    â‡ª ^ ! Esc            Reload this script

  I have had scenarios where CapsLock was stuck on, so every left click of the mouse was play/pause
  for music, so I couldn't terminate AHK. This is the same as closing and restarting AHK.
*/
#HotIf GetKeyState("Alt") && GetKeyState("Ctrl")
  CapsLock & Esc::         Reload
#HotIf


/*
  Price Watch
    â‡ª F12                Load stuff I'm watching

  Note that sometimes I have to escape special characters like %
*/
CapsLock & F12::
{
  Run("`"https://www.amazon.com/s?k=penoval+chromebook`"", , "Max")
  Run("`"https://www.amazon.com/Computer-International-BW-16D1X-U-Powerful-Blu-ray/dp/B071VP89X1`"", , "Max")
  return
}


/*
  Screen shot
    PrintScreen          Open the Windows screenshot tool by using the Windows hotkey
*/
PrintScreen::SendInput("#+s")



/*
  Typora
    ^ mousewheel         Decrease/increase font size
    â‡ª [                  Toggle left sidebar
*/
#HotIf WinActive("ahk_exe i)\\typora\.exe$", )
  ^wheelup::             SendInput("{Blind}^+{=}")
  ^wheeldown::           SendInput("{Blind}^+{-}")
  Capslock & [::         SendInput("^+{l}")
#HotIf


/*
  Chrome
    â‡ª b                  Run or activate Chrome
*/
CapsLock & b::           RunOrActivateAppOrUrl("- Google Chrome", WindowsProgramFilesFolder "\Google\Chrome\Application\chrome.exe")


/*
  Calendar
    â‡ª c                  Run or activate Outlook and switch to the calendar, using an Outlook
                           shortcut to switch to the calendar
CapsLock & c::           ActivateOrStartMicrosoftOutlook("^2")


/*
  Terminal/Cmder/bash
    â‡ª t                  Run or activate the terminal
*/
;--------------------------------------------------------------------------------------------------
CapsLock & t::           RunOrActivateAppOrUrl("Cmder", "C:\tools\Cmder\Cmder.exe")


/*
  Visual Studio Code
    ^ mousewheel         Decrease/increase font size
    â‡ª [                  Toggle left sidebar
    â‡ª v                  Open VS Code

  TODO-
    â‡ª ^ v                Open VS Code, create a new doc, paste selected text, then format it
*/
#HotIf WinActive("ahk_exe i)\\code\.exe$", )
  ^wheelup::             SendInput("{Blind}^{=}")
  ^wheeldown::           SendInput("{Blind}^{-}")
  CapsLock & [::         SendInput("^b")
#HotIf



/*
  Include all libraries, utilities, and other AutoHotKey scripts

  I have to put this at the bottom of my script, or else it interferes with other code in this script
*/
#Include "%A_ScriptDir%\Functions_v2.ahk"
#Include "%A_ScriptDir%\Utilities_v2.ahk"
#Include "%A_ScriptDir%\Customize Windows_v2.ahk"
#Include "%A_ScriptDir%\My Auto Correct_v2.ahk"
#Include "%A_ScriptDir%\Convert Case_v2.ahk"

#Include "%A_ScriptDir%\lib\RunAsAdmin_v2.ahk"