;--------------------------------------------------------------------------------------------------
; My AutoHotKey Automations - Home
;
;
; Keep in Mind While Developing This
; ----------------------------------
;   - Any use for text-to-speech? ComObjCreate("SAPI.SpVoice").Speak("Speak this phrase")
;   - Popup menus are useful- can I use them elsewhere?
;   - Are timed tooltips useful somewhere?
;   - Are classes useful anywhere?
;
;
; Modifiers
; ---------
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ⇪ = CapsLock/Hyper
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
; ⇪ ^ ! Esc             Windows (AHK)    Reload AHK (emergency restart)
; ⇪ b                   Windows (AHK)    Browser
; ⇪ c                   Windows (AHK)    Calendar
; ⇪ i                   Windows (AHK)    Inbox
; ⇪ j                   Windows (AHK)    JIRA- current project board
; ⇪ ^ j                 Windows (AHK)    JIRA- open selected story number
; ⇪ m                   Windows (AHK)    Music/Spotify
; ⇪ t                   Windows (AHK)    Terminal/Cmder/bash
; PrintScreen           Windows (AHK)    Windows screenshot tool
;
;
; Other Stuff
; -----------
; ⇪ RShift              Windows (AHK)    Cycle selected text between lower/upper/sentence/title case
; ⇪ u                   Windows (AHK)    Generate a random UUID (lowercase)
; ⇪ + u                 Windows (AHK)    Generate a random UUID (uppercase)
;
;
; Media Controls
; --------------
; ⇪ WheelUp/WheelDown   Windows (AHK)    Volume up/down
; ⇪ LButton             Windows (AHK)    Play/pause
; ⇪ RButton             Windows (AHK)    Music app (Spotify)
; ⇪ XButton1            Windows (AHK)    Previous track
; ⇪ XButton2            Windows (AHK)    Next track
; Mute                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams/Zoom)
;
;
; ?????
;^#pause::        Run, nircmd setdefaultsounddevice "Headphones",, Hide      ; ^numlock = ^pause
;^#numpadsub::    Run, nircmd setdefaultsounddevice "Headset",, Hide
;
;
; Home Automation
; ---------------
; (keys listed are numeric keypad)
; ⇪ +                   Windows (AHK)     Air cleaner: toggle on/off
; ⇪ Enter               Windows (AHK)             Fan: toggle on/off
;
; ⇪ 7|8|9               Windows (AHK)       Top light: brightness down|toggle on/off|brightness up
; ⇪ 4|5|6               Windows (AHK)    Middle light: brightness down|toggle on/off|brightness up
; ⇪ 1|2|3               Windows (AHK)    Bottom light: brightness down|toggle on/off|brightness up
;
; ⇪ ^ 7|9               Windows (AHK)       Top light: brightness 1%|brightness 100%
; ⇪ ^ 4|6               Windows (AHK)    Middle light: brightness 1%|brightness 100%
; ⇪ ^ 1|3               Windows (AHK)    Bottom light: brightness 1%|brightness 100%
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
;   ⇪ [                 Slack (AHK)      Toggle left sidebar
;   ⇪ ! b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb and presence to away.
;   ⇪ ! l               Slack (AHK)      Status - At lunch. Sets Slack statuses to lunch and presence to away.
;   ⇪ ! m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
;   ⇪ ! p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
;   ⇪ ! w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
; Typora
;   ^ mousewheel        Typora (AHK)     Decrease/increase font size
;   ⇪ [                 Typora (AHK)     Toggle left sidebar
; VS Code
;   ^ mousewheel        VS Code (AHK)    Decrease/increase font size
;   ⇪ [                 VS Code (AHK)    Toggle left sidebar
; IntelliJ
;   ⇪ [                 IntelliJ (AHK)   Toggle left sidebar
; Visual Studio
;   ⇪ [                 VS (AHK)         Make left sidebar (Solution Explorer) appear
;
;
; Code Structure
; --------------
; autohotkey/
; ├─ experiments/                Temporary things I'm experimenting with
; │  ├─ trying-to-do-blah.ahk
; │  └─ can-i-do-this.ahk
; │
; ├─ examples to keep/           Interesting stuff I want to keep but am not using
; │  └─ example1.ahk
; │
; ├─ lib/                        Libraries of other people's work that I'm using
; │  ├─ AutoCorrect.ahk
; │  ├─ RunAsAdmin.ahk
; │  └─ FindText.ahk             ** TODO- AM I GOING TO USE THIS???
; │
; ├─ Configure.bat               Batch file to configure by setting environment variables
; ├─ Main.ahk                    Main code, mostly hotkeys that call functions
; ├─ Functions.ahk               Majority of my code is here
; ├─ Convert Case.ahk            Cycle through lower/upper/sentence/title case
; ├─ Customize Windows.ahk       Code that customizes how Windows works
; ├─ My Auto Correct.ahk         My wrapper over AutoCorrect.ahk that includes my words to correct
; ├─ Slack.ahk                   Controlling Slack
; └─ Utilities.ahk               Utility functions
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
;   - CAN I GET IT WORKING WITH AHK??? ⇪ [
;        - Can't tell by the active window. maybe I can loop through all the active windows in
;
;
;
;
; ⇪ v                   Windows (AHK)    VS Code
; ⇪ ^ v                 Open VS Code, create a new doc, paste selected text, then format it
;
;
; Customizing App Behavior
; ------------------------
; Slack:
;   ⇪ ! f               Slack (AHK)      Status - Focusing - what to do on Windows??
; VS Code
;   ~$^s                VS Code (AHK)    After save AHK file, reload current script
;
;
; standardize video keys for youtube and udemy
;
; LOW PRIORITY
; ⇪ ^ v                 Windows (AHK)    VS Code- smart (create new doc, paste selected text, format it)
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
;   H ⌘ f          HS       Focusing. Starts Do Not Disturb timer for 30 minutes, 
;                           which also sets Slack statuses to heads-down.
;   H ⌘ s          HS       Studying. Starts Do Not Disturb timer for 60 minutes,
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
; H return       HS       Toggle full screen
; H ⌘ up         HS       Maximize window
; H ⌘ down       HS       Minimize window
; H ⌘ left       HS       Move active window to the previous screen
; H ⌘ right      HS       Move active window to the next screen
; ============================================================================================
;
;
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
#NoEnv                        ; Recommended for performance and compatibility with future AutoHotkey releases
; #Warn                       ; Enable warnings to assist with detecting common errors
#SingleInstance FORCE         ; Skip invocation dialog box and silently replace previously executing instance of this script
SendMode Input                ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%   ; Ensures a consistent starting directory

SetTitleMatchMode RegEx       ; Make windowing commands use regex
RunAsAdmin()

; If I don't want CapsLock at all, disable the keyboard LED
; THIS DOESN'T WORK- NOT SURE WHY...
SetCapsLockState, AlwaysOff
;SetStoreCapsLockMode, Off

SetNumLockState, On    ; So my macros with keypad work



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
EnvGet, WindowsLocalAppDataFolder, LOCALAPPDATA
EnvGet, WindowsProgramFilesX86Folder, PROGRAMFILES(X86)
EnvGet, WindowsProgramFilesFolder, PROGRAMFILES
EnvGet, WindowsUserName, USERNAME
EnvGet, WindowsUserDomain, USERDOMAIN
EnvGet, WindowsUserProfile, USERPROFILE
MyDocumentsFolder = %WindowsUserProfile%\Documents\

; These come from my Windows environment variables. See "Configure.bat" for details
Global MyPersonalFolder
Global MyPersonalDocumentsFolder
EnvGet, MyPersonalFolder, PERSONAL_FILES
MyPersonalDocumentsFolder = %MyPersonalFolder%\Documents\


;---------------------------------------------------------------------------------------------------------------------
; This code executes when the script starts
;---------------------------------------------------------------------------------------------------------------------

Return




;--------------------------------------------------------------------------------------------------
; Emergency Reload
;   ⇪ ^ ! Esc            Reload this script
;
; I have had scenarios where CapsLock was stuck on, so every left click of the mouse was play/pause
; for music, so I couldn't terminate AHK. This is the same as closing and restarting AHK.
;--------------------------------------------------------------------------------------------------
#If GetKeyState("Alt") and GetKeyState("Ctrl")
CapsLock & Esc::         Reload
#If 



;--------------------------------------------------------------------------------------------------
; Price Watch
;   ⇪ F12                Load stuff I'm watching
;
; Note that sometimes I have to escape special characters like %
;--------------------------------------------------------------------------------------------------
CapsLock & F12::
  Run, "https://www.amazon.com/s?k=penoval+chromebook",, Max
  Run, "https://www.amazon.com/Computer-International-BW-16D1X-U-Powerful-Blu-ray/dp/B071VP89X1",, Max
  Return










;--------------------------------------------------------------------------------------------------
; Standardize the keys for video playback (speed and skipping forward and 
; backward) in video apps and web sites like Youtube and Udemy
;--------------------------------------------------------------------------------------------------
;hyper:bind({}, "pad7",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_BACKWARD_BIG") end end)
;hyper:bind({}, "pad9",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_FORWARD_BIG") end end)
;hyper:bind({}, "pad4",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_BACKWARD_SMALL") end end)
;hyper:bind({}, "pad6",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_FORWARD_SMALL") end end)
;hyper:bind({}, "pad1",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_SLOWER") end end)
;hyper:bind({}, "pad3",  function() if isVideoAppOrSite() then executeActionInVideo("VIDEO_FASTER") end end)


#backspace::  
  ;getDomainNameFromUrl("https://google.com")
  ;getDomainNameFromUrl("https://www.youtube.com/watch?v=JAuCaFVS9FU")

  msgbox % isVideoAppOrSite()
  Return


;getDomainNameFromUrl(url)
;{
;  ; url="https://google.com" => "google.com"
;  ; url="https://www.youtube.com/watch?v=JAuCaFVS9FU" => "youtube.com"
;
;  ; This isn't very pretty, only handles prefix of "www"
;  RegexMatch(url, InStr(url, "//www") ? "\.(.+?)\/" : "^\w+://([^/]+)", domain)
;  Return domain1
;}



;-----------------------------------------------------------------------------
;-- Return true if the current app or web site is for video, and that my key
;-- standardization should be used. The apps/websites are:
;--   * VLC
;--   * Chrome: youtube.com
;--   * Chrome: udemy.com
; This Chrome extension can set the window title to include the URL for a whitelisted set of sites
; "URL in title": https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb
; Configuration:
;    Tab Title Format: {title} ({hostname})
;    Page URL filtering: Whitelist
;    URL filters: https://app.grammarly.com
;                 https://.*youtube.com
; So Window title looks like this: "Peyton Manning reacts to Patrick Mahomes' INT - YouTube (www.youtube.com) - Google Chrome"

; Rejected options
;   1. https://github.com/G33kDude/Chrome.ahk is one way to getting url from chrome, but requires a lot of
;      steps and starting chrome in debug mode, which I can do
;   2. This Chrome extension can be set to a hotkey to copy the current url to 
;      the clipboard: https://chrome.google.com/webstore/detail/copy-url-to-clipboard/miancenhdlkbmjmhlginhaaepbdnlllc/related?hl=en
;-----------------------------------------------------------------------------
isVideoAppOrSite()
{
  ; So Window title looks like this: "Peyton Manning reacts to Patrick Mahomes' INT - YouTube (www.youtube.com) - Google Chrome"
  WinGetTitle, title, A
  RegexMatch(title, "\((.*)\) - Google Chrome", fullDomain)

  domainWithoutPrefix1 := ""
  if fullDomain
  {
    RegexMatch(fullDomain, "(\w+\.\w+)\) - Google Chrome$", domainWithoutPrefix)
  }
  
  if (domainWithoutPrefix1 = "youtube.com" or domainWithoutPrefix1 = "udemy.com")
  {
    return True
  }
  else 
  {
    WinGet, id, List, ahk_exe vlc.exe
    if id
    {
      return True
    }
    Else
    {
      return False
    }
  }
}

;-----------------------------------------------------------------------------
;-- Standardizing keys for video playback for video apps and web sites,
;-- specifically for speeding up/down video and skipping forward/backward.
;-- I'm doing this for Youtube, VLC, and Udemy.
;--
;-- These keys are already standard
;--   play/pause                                  space
;--   full screen                                 F
;-- My code standardizes these keys
;--   VIDEO_BACKWARD_BIG/VIDEO_FORWARD_BIG        H+keypad 7 / H+keypad 9
;--   VIDEO_BACKWARD_SMALL/VIDEO_FORWARD_SMALL    H+keypad 4 / H+keypad 6
;--   VIDEO_SLOWER/VIDEO_FASTER                   H+keypad 1 / H+keypad 3
;-----------------------------------------------------------------------------
;executeActionInVideo = function(keyRemappingName)
;  local VIDEO_APP_KEY_MAPPINGS = {
;    [ "VIDEO_SLOWER,com.google.Chrome,youtube.com"         ] = { keyModifiers={"shift"},        key=","     },  -- <
;    [ "VIDEO_FASTER,com.google.Chrome,youtube.com"         ] = { keyModifiers={"shift"},        key="."     },  -- >
;    [ "VIDEO_BACKWARD_SMALL,com.google.Chrome,youtube.com" ] = { keyModifiers={},               key="left"  },
;    [ "VIDEO_FORWARD_SMALL,com.google.Chrome,youtube.com"  ] = { keyModifiers={},               key="right" },
;    [ "VIDEO_BACKWARD_BIG,com.google.Chrome,youtube.com"   ] = { keyModifiers={},               key="j"     },
;    [ "VIDEO_FORWARD_BIG,com.google.Chrome,youtube.com"    ] = { keyModifiers={},               key="l"     },
;
;    [ "VIDEO_SLOWER,com.google.Chrome,udemy.com"           ] = { keyModifiers={"shift"},        key="left"  },
;    [ "VIDEO_FASTER,com.google.Chrome,udemy.com"           ] = { keyModifiers={"shift"},        key="right" },
;    [ "VIDEO_BACKWARD_SMALL,com.google.Chrome,udemy.com"   ] = { keyModifiers={},               key="left"  },
;    [ "VIDEO_FORWARD_SMALL,com.google.Chrome,udemy.com"    ] = { keyModifiers={},               key="right" },
;    -- Udemy doesn't have equivalent of VIDEO_BACKWARD_BIG and VIDEO_FORWARD_BIG
;
;    [ "VIDEO_SLOWER,org.videolan.vlc"                      ] = { keyModifiers={},               key="["     },
;    [ "VIDEO_FASTER,org.videolan.vlc"                      ] = { keyModifiers={},               key="]"     },
;    [ "VIDEO_BACKWARD_SMALL,org.videolan.vlc"              ] = { keyModifiers={"cmd","option"}, key="left"  },
;    [ "VIDEO_FORWARD_SMALL,org.videolan.vlc"               ] = { keyModifiers={"cmd","option"}, key="right" },
;    [ "VIDEO_BACKWARD_BIG,org.videolan.vlc"                ] = { keyModifiers={"cmd","shift"},  key="left"  },
;    [ "VIDEO_FORWARD_BIG,org.videolan.vlc"                 ] = { keyModifiers={"cmd","shift"},  key="right" }
;  }
;
;  local app = hs.application.frontmostApplication()
;  local appBundleId = hs.application.frontmostApplication():bundleID()
;  local searchKey
;
;  if appBundleId == "com.google.Chrome" then 
;    local result, url = hs.osascript.applescript('tell application "Google Chrome" to return URL of active tab of front window')
;    local domainName = getDomainNameFromUrl(url)
;
;    searchKey = keyRemappingName .. ",com.google.Chrome," .. domainName 
;  else
;    searchKey = keyRemappingName .. "," .. appBundleId
;  end
;
;  local found = VIDEO_APP_KEY_MAPPINGS[searchKey]
;  --local inspect = require('lib.inspect')
;  --print("found=" .. inspect(found))
;
;  if found ~= nil then
;    hyper.triggered = true
;    if tableLength(found.keyModifiers) == 0 and found.key:len() == 1 then
;      -- Don't want to use this for "left", or else it will send the characters
;      -- "l", "e", "f", "t"
;      hs.eventtap.keyStrokes(found.key)
;    else
;      hs.eventtap.keyStroke(found.keyModifiers, found.key)
;    end
;  end
;end









;---------------------------------------------------------------------------------------------------------------------
; Convert case of selected text
;   ⇪ RShift             Cycle selected text between lower/upper/sentence/title case
;---------------------------------------------------------------------------------------------------------------------
CapsLock & RShift::      ConvertCase()


;---------------------------------------------------------------------------------------------------------------------
; Generate a UUID/GUID
;   ⇪ u                  Generate random UUID (lowercase)
;   ⇪ + u                Generate random UUID (uppercase)
;---------------------------------------------------------------------------------------------------------------------
CapsLock & u::           GenerateLowercaseGUID()
#If GetKeyState("Shift")
CapsLock & u::           GenerateUppercaseGUID()
#If


;---------------------------------------------------------------------------------------------------------------------
; Screen shot
;   PrintScreen          Open the Windows screenshot tool by using the Windows hotkey
;---------------------------------------------------------------------------------------------------------------------
PrintScreen::            SendInput #+s



;---------------------------------------------------------------------------------------------------------------------
; Typora
;   ^ mousewheel         Decrease/increase font size
;   ⇪ [                  Toggle left sidebar
;---------------------------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe i)\\typora\.exe$ 
  ^wheelup::             SendInput {Blind}^+{=}
  ^wheeldown::           SendInput {Blind}^+{-}
  Capslock & [::         SendInput ^+{l}
#IfWinActive


;---------------------------------------------------------------------------------------------------------------------
; Chrome
;   ⇪ b                  Run or activate Chrome
;---------------------------------------------------------------------------------------------------------------------
CapsLock & b::           RunOrActivateAppOrUrl("- Google Chrome", WindowsProgramFilesFolder . "\Google\Chrome\Application\chrome.exe")


;--------------------------------------------------------------------------------------------------
; Calendar
;   ⇪ c                  Run or activate Outlook and switch to the calendar, using an Outlook
;                        shortcut to switch to the calendar
;--------------------------------------------------------------------------------------------------
CapsLock & c::           ActivateOrStartMicrosoftOutlook("^2")


;--------------------------------------------------------------------------------------------------
; Terminal/Cmder/bash
;   ⇪ t                  Run or activate the terminal
;--------------------------------------------------------------------------------------------------
CapsLock & t::           RunOrActivateAppOrUrl("Cmder", "C:\tools\Cmder\Cmder.exe")


;--------------------------------------------------------------------------------------------------
; Visual Studio Code
;   ^ mousewheel         Decrease/increase font size
;   ⇪ [                  Toggle left sidebar
;   ⇪ v                  Open VS Code
;
; TODO-
;   ⇪ ^ v                Open VS Code, create a new doc, paste selected text, then format it
;--------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe i)\\code\.exe$ 
  ^wheelup::             SendInput {Blind}^{=}
  ^wheeldown::           SendInput {Blind}^{-}
  CapsLock & [::         SendInput ^b
#IfWinActive



;--------------------------------------------------------------------------------------------------
; Include all libraries, utilities, and other AutoHotKey scripts
;
; I have to put this at the bottom of my script, or else it interferes with other code in this script
;--------------------------------------------------------------------------------------------------
#Include %A_ScriptDir%\Functions.ahk
#Include %A_ScriptDir%\Utilities.ahk
#Include %A_ScriptDir%\Customize Windows.ahk
#Include %A_ScriptDir%\My Auto Correct.ahk
#Include %A_ScriptDir%\Convert Case.ahk

#Include %A_ScriptDir%\lib\RunAsAdmin.ahk
