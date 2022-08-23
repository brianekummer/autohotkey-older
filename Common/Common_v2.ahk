/*
  My AutoHotkey Automations - Common Between Work and Home

  THIS IS FOR HOTKEYS, ETC. FUNCTIONS SHOULD BE IN Common Functions_v2.ahk




REQUIREMENTS FOR CODE IN COMMON FOLDER
- All code must compile/be-happy on both machines, not try to access env vars that don'ty exist on one machine, etc


; Modifiers
; ---------
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper
;
;
; ============================================================================================
; TO DO ITEMS
; ============================================================================================
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
*/



/*
  Emergency Reload
    ✦ ^ ! Esc            Reload this script

  I have had scenarios where CapsLock was stuck on, so every left click of the mouse was play/pause
  for music, so I couldn't terminate AHK. This is the same as closing and restarting AHK.
*/
#HotIf GetKeyState("Alt") and GetKeyState("Ctrl")
  CapsLock & Esc::
  {
    if (WinActive("ahk_exe parsecd.exe"))      ; When using personal laptop at work, tell personal laptop to reload
      SendKeystrokesToPersonalLaptop("{Alt down}{Control down}{CapsLock down}{Esc}{CapsLock up}{Control up}{Alt up}")
    else
      Reload                                   ; Reload AHK on either work or personal laptop

    return
  }
#HotIf


/*
  Price Watch
    ✦ F12                Load stuff I'm watching

  Note that sometimes I have to escape special characters like %
*/
#HotIf Configuration.IsWorkLaptop
  CapsLock & F12::       SendKeystrokesToPersonalLaptop("{CapsLock down}{F12}{CapsLock up}")
#HotIf !Configuration.IsWorkLaptop
  CapsLock & F12::       PriceWatchWebsites()
#HotIf


/*
  Convert case of selected text
    ✦ RShift             Cycle selected text between lower/upper/sentence/title case

; Since you cannot send RShift key to another window, I am using F17 here
*/
#HotIf WinActive("ahk_exe parsecd.exe", )          ; Work laptop when working on personal laptop
  CapsLock & RShift::    SendKeystrokesToPersonalLaptop("{CapsLock down}{F17}{CapsLock up}")
#HotIf
CapsLock & RShift::      ConvertCase()    ; Work laptop reacts to this
CapsLock & F17::         ConvertCase()    ; Personal laptop reacts to this


/*
  Screen shot
    PrintScreen          Open the Windows screenshot tool by using the Windows hotkey
*/
#HotIf WinActive("ahk_exe parsecd.exe", )          ; Work laptop when working on personal laptop
  PrintScreen::          SendKeystrokesToPersonalLaptop("{LWin down}{Shift down}s{Shift up}{LWin up}")
#HotIf
PrintScreen::SendInput("#+s")


/*
  Typora
    ✦ n                  Run or activate my notes in Typora on my work laptop
    ✦ ! n                Run or activate my notes in Typora on my personal laptop

    ^ mousewheel         Decrease/increase font size
    ✦ [                  Toggle left sidebar
*/
;#If IsWorkLaptop && GetKeyState("Alt")
;  CapsLock & n::         SendKeystrokesToPersonalLaptop("{CapsLock down}n{CapsLock up}")
;#If
CapsLock & n::           RunOrActivateApp("ahk_exe i)\\typora\.exe$", Configuration.WindowsProgramFilesFolder "\Typora\Typora.exe")

#HotIf WinActive("ahk_exe i)\\typora\.exe$", )
  ^wheelup::                        SendInput("{Blind}^+{=}")
  ^wheeldown::                      SendInput("{Blind}^+{-}")
  Capslock & [::                    SendInput("^+{l}")
#HotIf


/*
  Chrome
    ✦ b                  Run or activate Chrome on my work laptop
    ✦ ! b                Run or activate Chrome on my personal laptop
*/
;#If IsWorkLaptop && GetKeyState("Alt")
;  CapsLock & b::         SendKeystrokesToPersonalLaptop("{CapsLock down}b{CapsLock up}")
;#If
CapsLock & b::           RunOrActivateApp("- Google Chrome", Configuration.WindowsProgramFilesFolder "\Google\Chrome\Application\chrome.exe")


/*
  Terminal/Cmder/bash
    ✦ t                  Run or activate the terminal on my work laptop
    ✦ ! t                Run or activate the terminal on my personal laptop
*/
;#If IsWorkLaptop && GetKeyState("Alt")
;  CapsLock & t::         SendKeystrokesToPersonalLaptop("{CapsLock down}t{CapsLock up}")
;#If
CapsLock & t::           RunOrActivateAppAsAdmin("Cmder", "C:\tools\Cmder\Cmder.exe", False)


/*
  Visual Studio Code
    ✦ v                  Open VS Code on my work laptop
    ✦ ! v                Open VS Code on my personal laptop

    ^ mousewheel         Decrease/increase font size
    ✦ [                  Toggle left sidebar

  TODO-
    ✦ ^ v                Open VS Code, create a new doc, paste selected text, then format it
*/
;#If IsWorkLaptop && GetKeyState("Alt")
;  CapsLock & v::         SendKeystrokesToPersonalLaptop("{CapsLock down}v{CapsLock up}")
;#If
CapsLock & v::           RunOrActivateAppAsAdmin("ahk_exe i)\\code\.exe$", Configuration.WindowsProgramFilesFolder "\Microsoft VS Code\Code.exe")

#HotIf WinActive("ahk_exe i)\\code\.exe$", )
  ^wheelup::                 SendInput("{Blind}^{=}")
  ^wheeldown::               SendInput("{Blind}^{-}")
  CapsLock & [::             SendInput("^b")
#HotIf













/*
  EXPERIMENTAL CODE
*/

/*
  Standardizing keys for video playback for video apps and web sites,
  specifically for speeding up/down video and skipping forward/backward.
  I'm doing this for Youtube, VLC, and Udemy.

  These keys are already standard
    play/pause                                  space
    full screen                                 F
  My code standardizes these keys
    VIDEO_BACKWARD_BIG/VIDEO_FORWARD_BIG        H+keypad 7 / H+keypad 9
    VIDEO_BACKWARD_SMALL/VIDEO_FORWARD_SMALL    H+keypad 4 / H+keypad 6
    VIDEO_SLOWER/VIDEO_FASTER                   H+keypad 1 / H+keypad 3
*/
/*
executeActionInVideo = function(keyRemappingName)
  local VIDEO_APP_KEY_MAPPINGS = {
    [ "VIDEO_SLOWER,com.google.Chrome,youtube.com"         ] = { keyModifiers={"shift"},        key=","     },  -- <
    [ "VIDEO_FASTER,com.google.Chrome,youtube.com"         ] = { keyModifiers={"shift"},        key="."     },  -- >
    [ "VIDEO_BACKWARD_SMALL,com.google.Chrome,youtube.com" ] = { keyModifiers={},               key="left"  },
    [ "VIDEO_FORWARD_SMALL,com.google.Chrome,youtube.com"  ] = { keyModifiers={},               key="right" },
    [ "VIDEO_BACKWARD_BIG,com.google.Chrome,youtube.com"   ] = { keyModifiers={},               key="j"     },
    [ "VIDEO_FORWARD_BIG,com.google.Chrome,youtube.com"    ] = { keyModifiers={},               key="l"     },

    [ "VIDEO_SLOWER,com.google.Chrome,udemy.com"           ] = { keyModifiers={"shift"},        key="left"  },
    [ "VIDEO_FASTER,com.google.Chrome,udemy.com"           ] = { keyModifiers={"shift"},        key="right" },
    [ "VIDEO_BACKWARD_SMALL,com.google.Chrome,udemy.com"   ] = { keyModifiers={},               key="left"  },
    [ "VIDEO_FORWARD_SMALL,com.google.Chrome,udemy.com"    ] = { keyModifiers={},               key="right" },
    -- Udemy doesn't have equivalent of VIDEO_BACKWARD_BIG and VIDEO_FORWARD_BIG

    [ "VIDEO_SLOWER,org.videolan.vlc"                      ] = { keyModifiers={},               key="["     },
    [ "VIDEO_FASTER,org.videolan.vlc"                      ] = { keyModifiers={},               key="]"     },
    [ "VIDEO_BACKWARD_SMALL,org.videolan.vlc"              ] = { keyModifiers={"cmd","option"}, key="left"  },
    [ "VIDEO_FORWARD_SMALL,org.videolan.vlc"               ] = { keyModifiers={"cmd","option"}, key="right" },
    [ "VIDEO_BACKWARD_BIG,org.videolan.vlc"                ] = { keyModifiers={"cmd","shift"},  key="left"  },
    [ "VIDEO_FORWARD_BIG,org.videolan.vlc"                 ] = { keyModifiers={"cmd","shift"},  key="right" }
  }

  local app = hs.application.frontmostApplication()
  local appBundleId = hs.application.frontmostApplication():bundleID()
  local searchKey

  if appBundleId == "com.google.Chrome" then 
    local result, url = hs.osascript.applescript('tell application "Google Chrome" to return URL of active tab of front window')
    local domainName = getDomainNameFromUrl(url)

    searchKey = keyRemappingName .. ",com.google.Chrome," .. domain["Name"] 
  else
    searchKey = keyRemappingName .. "," .. appBundleId
  end

  local found = VIDEO_APP_KEY_MAPPINGS[searchKey]
  --local inspect = require('lib.inspect')
  --print("found=" .. inspect(found))

  if found ~= nil then
    hyper.triggered = true
    if tableLength(found.keyModifiers) == 0 and found.key:len() == 1 then
      -- Don't want to use this for "left", or else it will send the characters
      -- "l", "e", "f", "t"
      hs.eventtap.keyStrokes(found.key)
    else
      hs.eventtap.keyStroke(found.keyModifiers, found.key)
    end
  end
end


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


;#backspace::  
;  ;getDomainNameFromUrl("https://google.com")
;  ;getDomainNameFromUrl("https://www.youtube.com/watch?v=JAuCaFVS9FU")
;
;  msgbox % isVideoAppOrSite()
;  Return


;getDomainNameFromUrl(url)
;{
;  ; url="https://google.com" => "google.com"
;  ; url="https://www.youtube.com/watch?v=JAuCaFVS9FU" => "youtube.com"
;
;  ; This isn't very pretty, only handles prefix of "www"
;  RegExMatch(url, InStr(url, "//www") ? "\.(.+?)\/" : "^\w+://([^/]+)", &domain)
;  Return domain[1]
;}


;-----------------------------------------------------------------------------
; TODO- This WHOL ETHING needs re-evaluated
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
;      the A_Clipboard: https://chrome.google.com/webstore/detail/copy-url-to-A_Clipboard/miancenhdlkbmjmhlginhaaepbdnlllc/related?hl=en
;-----------------------------------------------------------------------------
;isVideoAppOrSite()
;{
;  ; So Window title looks like this: "Peyton Manning reacts to Patrick Mahomes' INT - YouTube (www.youtube.com) - Google Chrome"
;  title := WinGetTitle("A")
;  RegExMatch(title, "\((.*)\) - Google Chrome", &fullDomain)

;   ;domain["WithoutPrefix1"] := ""
;   if fullDomain[0]
;   {
;     RegExMatch(fullDomain[0], "(\w+\.\w+)\) - Google Chrome$", &domainWithoutPrefix)
;   }
  
;   if (domain["WithoutPrefix1"] = "youtube.com" or domain["WithoutPrefix1"] = "udemy.com")
;   {
;     return True
;   }
;   else 
;   {
;     oid := WinGetList("ahk_exe vlc.exe",,,)
;     aid := Array()
;     id := oid.Length
;     For v in oid
;     {   aid.Push(v)
;     }
;     if aid.Length
;     {
;       return True
;     }
;     Else
;     {
;       return False
;     }
;   }
; }

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
;    searchKey = keyRemappingName .. ",com.google.Chrome," .. domain["Name"] 
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
*/





/*
  Include all libraries, utilities, and other AutoHotkey scripts

  I have to put this at the bottom of my script, or else it interferes with other code in this script
*/
#Include "%A_ScriptDir%\Common\Common Functions_v2.ahk"