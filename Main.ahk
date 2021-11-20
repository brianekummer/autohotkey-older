;--------------------------------------------------------------------------------------------------
; My AutoHotKey Automations
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
Global MyPersonalFolder
Global MyPersonalDocumentsFolder
EnvGet, WindowsLocalAppDataFolder, LOCALAPPDATA
EnvGet, WindowsProgramFilesX86Folder, PROGRAMFILES(X86)
EnvGet, WindowsProgramFilesFolder, PROGRAMFILES
EnvGet, WindowsUserName, USERNAME
EnvGet, WindowsUserDomain, USERDOMAIN
EnvGet, WindowsUserProfile, USERPROFILE
EnvGet, MyPersonalFolder, PERSONAL_FILES
MyDocumentsFolder = %WindowsUserProfile%\Documents\
MyPersonalDocumentsFolder = %MyPersonalFolder%\Documents\

; These come from my Windows environment variables. See "Configure.bat" for details
Global JiraUrl
Global JiraMyProjectKeys
Global JiraDefaultProjectKey
Global JiraDefaultRapidKey
Global JiraDefaultSprint
Global SourceCodeUrl
Global SourceSchemaUrl
EnvGet, JiraUrl, AHK_JIRA_URL
EnvGet, JiraMyProjectKeys, AHK_JIRA_MY_PROJECT_KEYS
EnvGet, JiraDefaultProjectKey, AHK_JIRA_DEFAULT_PROJECT_KEY
EnvGet, JiraDefaultRapidKey, AHK_JIRA_DEFAULT_RAPID_KEY
EnvGet, JiraDefaultSprint, AHK_JIRA_DEFAULT_SPRINT
EnvGet, SourceCodeUrl, AHK_SOURCE_CODE_URL
EnvGet, SourceSchemaUrl, AHK_SOURCE_CODE_SCHEMA_URL



;---------------------------------------------------------------------------------------------------------------------
; This code executes when the script starts
;---------------------------------------------------------------------------------------------------------------------

; Configure Slack status updates based on the network. *REQUIRES* several Windows environment variables - see 
; "Slack.ahk" for details
SlackStatusUpdate_Initialize()
;***** SKIP THIS FOR NOW ***** SlackStatusUpdate_SetSlackStatusBasedOnNetwork()
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
  Run, "https://www.ups.com/track?loc=null&tracknum=1Z1825750314671222&requester=WT/trackdetails",, Max   ; Jabra
  ;Run, "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=9361289720407048821746",, Max           ; New Amazon order- flash drive, dishwasher tabs, cable holder
  ;Run, "https://www.amazon.com/gp/css/order-history?ref_=nav_orders_first",, Max                          ; New Amazon order
  
  ;Run, "https://www.amazon.com/s?k=jabra+link+380",, Max
  ;Run, "https://www.staples.com/jabra-link-380-14208-24-network-adapter/product_24447112",, Max
  Run, "https://www.amazon.com/s?k=penoval+chromebook",, Max
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




















;--------------------------------------------------------------------------------------------------
; Toggle mute in VOIP apps (Slack/Microsoft Teams/Zoom/Google Meet)
;   Mute                 Activate the current VOIP call/meeting and toggles mute
;--------------------------------------------------------------------------------------------------
Volume_Mute::            ToggleMuteVOIPApps()


; TEAMS TEST CASES
;   1. PASSED- Not in a call, just have calendar open
;   2. PASSED- In a mtg like standup, with no screen sharing
;   3. PASSED- In a planned mtg with screen share, like preplanning, etc
;   4. PASSED- 1-on-1 with BA, he sharing
;   5. 1-on-1 with BA, I'm sharing
;
; IMPROVEMENTS
;   - Can I used FindText to determine if there is a "Leave" button?
;
; CAN I DETERMINE WHAT STATUS OF MUTE IS?
;   - Use ImageSearch to look for muted or unmuted icon
;
; ONCE I get this working wire it up to
;   - the play/pause media key on my headset which will be great
;   - Looks like headset doesn't always send {Media_Play_Pause}, 
;     AND it sends WM_APPCOMMAND every OTHER time... not sure how to fix this
;   - Does this work better as headphones instead of headset?
;     It needs to work as headset, but might help troubleshoot
;
;
;
; SLACK INFO
;
; WHERE DOES THIS GO? REGULAR CALL, OR HUDDLE?
;   - When I'm presenting, is a little window with mute button and "Stop Sharing" button. Title is simply "Slack"
;
;
;   - Not on a call, window title is "Slack | <channel name> | teletracking"
;   - Regular slack call, can do this with home account (unpaid)
;       - Window titles
;          - Audio only: "Slack | Slack call with xxxxx | m:ss"
;          - When other side sharing: "Slack | Slack call with xxxxx | m:ss"
;          - When I'm sharing: xxxxxxxxxxxxxxxxx
;       - Mute by "SendInput m"
;   - Huddles, requires paid account
;       - WIndow titles
;          - Audio only: xxxxxxxxxxxxxxxxx
;          - When other side sharing: "Kiran Jaghni screen share"
;          - When I'm sharing: xxxxxxxxxxxxxxxxx
;       - Mute by "SendInput ^+{space}", works if on Slack main window or screen share window has focus
;
; SLACK TEST CASES
;   1. Not in a call, not in a huddle, Slack not open
;   2. Not in a call, not in a huddle, Slack is open
;   3. In a huddle, audio only
;   4. In a huddle, someone sharing screen
;   5  In a huddle, I'm sharing screen
;   6. On a call with BA, he sharing
;   7. On a call with BA, I'm sharing
;
; IMPROVEMENTS
;   - Can I used FindText to determine if there is a "Leave" button?
;
; CAN I DETERMINE WHAT STATUS OF MUTE IS?
;   - Use ImageSearch to look for muted or unmuted icon
;   - Is it worth the amount of work?
;
;
;
; GOOGLE MEET (in a Chrome tab)
; Window title: "Meet - xxx-xxxx-xxx - Google Chrome"
; ctrl-d to mute
; Does NOT search through open tabs. But if the Meet is the active tab in any instance of Chrome, then it finds it
ToggleMuteVOIPApps() {
  ; Microsoft Teams
  If ActivateWindowByIdAndSendKeystroke(GetTeamsMeetingWindowId(), "^+m")
    Return

  ; Slack call
  If ActivateWindowByIdAndSendKeystroke(GetSlackCallWindowId(), "m")
    Return

  ; Slack huddle
  If ActivateWindowByIdAndSendKeystroke(GetSlackHuddleWindowId(), "^+{space}")
    Return

  ; Zoom
  If ActivateWindowByIdAndSendKeystroke(GetZoomMeetingWindowId(), "!a")
    Return

  ; Google Meet, in a Chrome tab
  If ActivateWindowByIdAndSendKeystroke(GetGoogleMeetWindowId(), "^d")
    Return

  MsgBox Muting NOTHING
}

GetTeamsMeetingWindowId() {
  ; Make sure title is not the notification
  ; Screen sharing window uses null title, make sure the win does not have a null title
  ; No idea why other window(s?) end with "[QSP]"", but the meeting window does not (as of Oct 2021)
  ;
  ; I tried to simplify this using a single regex, but doing NOT is ugly in regex, and excluding the
  ; null title made this very confusing. This code is MUCH simpler.
  WinGet, id, List, ahk_exe Teams.exe
  Loop, %id%
  {
    thisId := id%A_Index%
    WinGetTitle, title, ahk_id %thisId%
    
    If (title <> Microsoft Teams Notification) And (title <> "") And (Not RegExMatch(title, "\[QSP\]$"))
    {
      ;msgbox TEAMS Window: %title%
      Return %thisId%
    }
  }
  
  Return
}
GetSlackCallWindowId() {
  WinGet, windowId, ID, Slack call with .* \| \d+:\d\d
  ; I don't believe I can get multiple windows, so I think this code is unnecessary
  ;WinGet, callWindowIds, List, Slack call with .* \| \d+:\d\d
  ;windowId := callWindowIds1    ; Return 1st matching window
  Return windowId
}
GetSlackHuddleWindowId() {
  WinGet, windowId, ID, (.* screen share)
  ; I don't believe I can get multiple windows, so I think this code is unnecessary
  ;WinGet, huddleWindowIds, List, (.* screen share)
  ;windowId := huddleWindowIds1    ; Return 1st matching window
  Return windowId
}
GetZoomMeetingWindowId() {
  WinGet, windowId, ID, ahk_class ZPContentViewWndClass
  Return windowId
}
GetGoogleMeetWindowId() {
; Does NOT search through open tabs. But if the Meet is the active tab in any instance of Chrome, then it finds it
  WinGet, windowId, ID, Meet - \w{3}\-\w{4}\-\w{3} \- Google Chrome
  Return windowId
}








;~Media_Play_Pause::
;  ; Looks like this only recognizes the keyboard's play/pause button. 
;  ; This is of no value because I have the {Volume_Mute} key above.
;  ;msgbox "Play/pause"
;  ToggleMuteVOIPApps()
;  Return






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
; Slack
;   ⇪ k                  Open Slack
;   ⇪ ^ k                Open Slack and go to the "jump to" window
;   ⇪ [                  Toggle left sidebar
;   ^ mousewheel         Decrease/increase fomnt size
;   ^ k                  Insert hyperlink (overrides Slack opening "jump to" window)
;   Statuses
;     ⇪ # b              Status - Be Right Back. Sets Slack statuses to brb.
;     ⇪ # l              Status - At lunch. Sets Slack statuses to lunch.
;     ⇪ # m              Status - In a meeting. Sets Slack statuses to mtg.
;     ⇪ # p              Status - Playing. Sets home Slack status to 8bit.
;     ⇪ # w              Status - Working. Clears Slack statuses.
;---------------------------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe i)\\slack\.exe$ 
  ^wheelup::          SendInput ^{=}
  ^wheeldown::     SendInput ^{-}
  CapsLock & [::   SendInput ^+{d}
  ^k::             SendInput ^+{u}
#IfWinActive

#If GetKeyState("Alt")
  CapsLock & b::   SlackStatusUpdate_SetSlackStatusAndPresence("brb", "away")
  CapsLock & l::   
    SlackStatusUpdate_SetSlackStatusAndPresence("lunch", "away")
    HomeAutomationCommand("litetop off")
    HomeAutomationCommand("litemiddle off")
    HomeAutomationCommand("litebottom off")
    Return
  CapsLock & m::   SlackStatusUpdate_SetSlackStatusAndPresence("meeting", "auto")
  CapsLock & p::   SlackStatusUpdate_SetHomeSlackStatus("playing")
  CapsLock & w::   SlackStatusUpdate_SetSlackStatusAndPresence("none", "auto")
#If

CapsLock & k::
  ; If Ctrl is pressed send shortcut "^k" else send shortcut ""
  OpenSlack((GetKeyState("Ctrl") ? "^k" : ""))    
  Return

OpenSlack(shortcut := "")
{
  RunOrActivateAppOrUrl("ahk_exe slack.exe", WindowsLocalAppDataFolder . "\Slack\Slack.exe", 3, True)
  If shortcut <>
    SendInput %shortcut%

  Return
}


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
; Inbox
;   ⇪ i                  Run or activate Outlook and switch to the inbox, using an Outlook shortcut
;                        to switch to the inbox
;--------------------------------------------------------------------------------------------------
CapsLock & i::           ActivateOrStartMicrosoftOutlook("^+I")


;--------------------------------------------------------------------------------------------------
; JIRA
;   ⇪ j                  Opens the current board
;   ⇪ ^ j                Opens the selected story number
;                          * If the highlighted text looks like a JIRA story number (e.g. 
;                            PROJECT-1234), then open that story
;                          * If the Git Bash window has text that looks like a JIRA story number, 
;                            then open that story
;                          * Last resort is to open the current board
;--------------------------------------------------------------------------------------------------
CapsLock & j::           JIRA()


;--------------------------------------------------------------------------------------------------
; Music/Spotify
;   ⇪ m                  Run or activate Spotify
;--------------------------------------------------------------------------------------------------
CapsLock & m::           RunOrActivateSpotify()
  

;--------------------------------------------------------------------------------------------------
; Source code
;   ⇪ s                  Source code/BitBucket
;   ⇪ ^ s                Source code/BitBucket- schemas
;--------------------------------------------------------------------------------------------------
CapsLock & s:: 
  If GetKeyState("Ctrl")
  {
    RunAppOrUrl("eventschema", SourceSchemaUrl)
  }
  Else
  {
    RunAppOrUrl("overview", SourceCodeUrl)
  }
  Return


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
; Visual Studio
;   ⇪ [                  Toggle left sidebar
;                        Use Shift+Esc to exit, or click outside
;                        I could not find a way to determine if the Solution Explorer was open or 
;                        not, to determine if I should do ⇪[ or +{Esc}
;--------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe i)\\devenv\.exe$ 
  CapsLock & [::         SendInput ^!l
#IfWinActive


;--------------------------------------------------------------------------------------------------
; IntelliJ
;   ⇪ [                  Toggle left sidebar
;--------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe i)\\idea64\.exe$ 
  CapsLock & [::         SendInput !1
#IfWinActive


;--------------------------------------------------------------------------------------------------
; Home automation
;   (keys listed are on the numeric keypad)
;   ⇪ +                   Air cleaner: toggle on/off
;
;   ⇪ Enter                       Fan: toggle on/off
;
;   ⇪ 7|8|9                 Top light: brightness down|toggle on/off|brightness up
;   ⇪ ^ 7|9                 Top light: brightness 1%|brightness 100%
;
;   ⇪ 4|5|6              Middle light: brightness down|toggle on/off|brightness up
;   ⇪ ^ 4|6              Middle light: brightness 1%|brightness 100%
;
;   ⇪ 1|2|3              Bottom light: brightness down|toggle on/off|brightness up
;   ⇪ ^ 1|3              Bottom light: brightness 1%|brightness 100%
;
;
; DISABLED
;  ⇪ ^ +                 Air cleaner: cycle between fan speeds
;                        THIS IS VALID FOR VESYNC AIRE CLEANER, NOT WYZE PLUG
;--------------------------------------------------------------------------------------------------
CapsLock & numpadadd::   HomeAutomationCommand("ac  toggle")      ; HomeAutomationCommand("ac " . (GetKeyState("Ctrl") ? "speed cycle" : "toggle"))
CapsLock & numpadenter:: HomeAutomationCommand("fan toggle")

CapsLock & numpad7::     HomeAutomationCommand("litetop    brightness " . (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & numpad8::     HomeAutomationCommand("litetop    toggle")
CapsLock & numpad9::     HomeAutomationCommand("litetop    brightness " . (GetKeyState("Ctrl") ? "100" : "+"))

CapsLock & numpad4::     HomeAutomationCommand("litemiddle brightness " . (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & numpad5::     HomeAutomationCommand("litemiddle toggle")
CapsLock & numpad6::     HomeAutomationCommand("litemiddle brightness " . (GetKeyState("Ctrl") ? "100" : "+"))

CapsLock & numpad1::     HomeAutomationCommand("litebottom brightness " . (GetKeyState("Ctrl") ? "1"   : "-"))
CapsLock & numpad2::     HomeAutomationCommand("litebottom toggle")
CapsLock & numpad3::     HomeAutomationCommand("litebottom brightness " . (GetKeyState("Ctrl") ? "100" : "+"))





;--------------------------------------------------------------------------------------------------
; Include all libraries, utilities, and other AutoHotKey scripts
;
; I have to put this at the bottom of my script, or else it interferes with other code in this script
;--------------------------------------------------------------------------------------------------
#Include %A_ScriptDir%\Functions.ahk
#Include %A_ScriptDir%\Utilities.ahk
#Include %A_ScriptDir%\Slack.ahk
#Include %A_ScriptDir%\Customize Windows.ahk
#Include %A_ScriptDir%\My Auto Correct.ahk
#Include %A_ScriptDir%\Convert Case.ahk

#Include %A_ScriptDir%\lib\RunAsAdmin.ahk

; For muting MS Teams
;#Include %A_ScriptDir%\lib\Acc.ahk
;#Include %A_ScriptDir%\lib\FindText.ahk
;#Include %A_ScriptDir%\lib\Tooltip.ahk
;#Include %A_ScriptDir%\lib\WinListBox.ahk
;#Include %A_ScriptDir%\Microsoft Teams.ahk
