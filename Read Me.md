# My AutoHotkey Automations for Work & Home


## Modifiers
  ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper


## Hotkeys
### Windows Provided
\# -                   Windows          Windows Magnifier -
\# =                   Windows          Windows Magnifier +
\# a                   Windows          Windows Action Center
\# d                   Windows          Windows desktop
\# e                   Windows          Windows Explorer
\# l                   Windows          Lock workstation
\# p                   Windows          Project (duplicate, extend, etc)
\# up                  Windows          Maximize active window

### Shortcuts
✦ ^ ! Esc             Windows (AHK)    Reload AHK (emergency restart)
✦ b                   Windows (AHK)    Browser (if a url is selected, open it)
✦ c                   Windows (AHK)    Calendar
✦ g                   Windows (AHK)    Google search for selected text
✦ i                   Windows (AHK)    Inbox
✦ j                   Windows (AHK)    JIRA- current project board
✦ ^ j                 Windows (AHK)    JIRA- open selected story number
✦ m                   Windows (AHK)    Music/Spotify
✦ p                   Windows (AHK)    Parsec/Personal computer
✦ s                   Windows (AHK)    Source code- dashboard/overview
✦ ^ s                 Windows (AHK)    Source code- popup menu
                                         - Search code for selected text
                                         - Search repositories for selected text
                                         - Event schema repository
✦ t                   Windows (AHK)    Terminal/Cmder/bash
PrintScreen           Windows (AHK)    Windows screenshot tool

### Other Stuff
✦ RShift              Windows (AHK)    Cycle selected text between lower/upper/sentence/title case
✦ u                   Windows (AHK)    Generate a random UUID (lowercase)
✦ + u                 Windows (AHK)    Generate a random UUID (uppercase)
✦ ^! Esc              Windows (AHK)    Emergency reset
AppsKey               Windows (AHK)    Using it for debugging something
✦ F12                 Windows (AHK)    Price watch

### Media Controls
✦ WheelUp/WheelDown   Windows (AHK)    Volume up/down
✦ LButton             Windows (AHK)    Play/pause
✦ RButton             Windows (AHK)    Music app (Spotify)
✦ XButton1            Windows (AHK)    Previous track
✦ XButton2            Windows (AHK)    Next track
Mute                  Windows (AHK)    Toggle mute in the current VOIP app (Slack/Teams/Zoom)

### Home Automation
(keys listed are numeric keypad)
✦ +                   Windows (AHK)     Air cleaner: toggle on/off
✦ Enter               Windows (AHK)             Fan: toggle on/off

✦ 7|8|9               Windows (AHK)       Top light: brightness down|toggle on/off|brightness up
✦ 4|5|6               Windows (AHK)    Middle light: brightness down|toggle on/off|brightness up
✦ 1|2|3               Windows (AHK)    Bottom light: brightness down|toggle on/off|brightness up

✦ ^ 7|9               Windows (AHK)       Top light: brightness 1%|brightness 100%
✦ ^ 4|6               Windows (AHK)    Middle light: brightness 1%|brightness 100%
✦ ^ 1|3               Windows (AHK)    Bottom light: brightness 1%|brightness 100%

### Customizing Windows Behavior
\# Down               Windows (AHK)    Minimize active window (instead of unmaximize, then minimize)
XButton1              Windows (AHK)    Minimize current application
XButton2              Windows (AHK)    Minimize app or close window/tab or close app
(auto-correct)        Windows (AHK)    Auto correct/capitalize lots of words, including first names

### Customizing App Behavior
#### IntelliJ
  ✦ [                 IntelliJ (AHK)   Toggle left sidebar
#### Slack
  ^ mousewheel        Slack (AHK)      Decrease/increase font size
  ^ k                 Slack (AHK)      Insert hyperlink
  ✦ [                 Slack (AHK)      Toggle left sidebar
  ✦ ! b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb. If I'm in
                                       the office, also locks my workstation.
  ✦ ! c               Slack (AHK)      Status - cleared. Clears Slack status.
  ✦ ! e               Slack (AHK)      Status - Eating. Sets Slack statuses to lunch/dinner.
                                       Locks my workstation. If I'm at home, also turns off my office lights.
  ✦ ! m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
  ✦ ! p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
  ✦ ! w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
#### Spotify
  ^ mousewheel        Spotify (AHK)     Decrease/increase font size
#### Typora
  ^ mousewheel        Typora (AHK)     Decrease/increase font size
  ✦ [                 Typora (AHK)     Toggle left sidebar
#### Visual Studio
  ✦ [                 VS (AHK)         Make left sidebar (Solution Explorer) appear
#### VS Code
  ^ mousewheel        VS Code (AHK)    Decrease/increase font size
  ✦ [                 VS Code (AHK)    Toggle left sidebar


## Code Structure
├── Home.ahk                    ; root only has runnable scripts, ideally only
├── Work.ahk                    ;   hotkeys, etc. and should not have blocks of code
├── Read Me.md
├── Configure.bat               ; template to set all necessary environment variables
│
├── Lib                         ; third party scripts
│   ├── AutoCorrect.ahk
│   └── RunAsAdmin.ahk
│
├── Common                      ; scripts used by both work and home computers
│   ├── Common.ahk              ; hotkeys that are common to both work and home
│   ├── Common Functions.ahk    ; script to support Common.ahk
│   ├── Convert Case.ahk        ; converts string between lower/upper/sentence/title case
│   ├── Customize Windows.ahk   ; adds features to Windows (hyper key, media controls, etc.)
│   ├── My Auto Correct.ahk     ; My wrapper around auto-correction
│   └── Utilities.ahk
│
├── Home                        ; scripts to support Home.ahk
│   └── Home Functions.ahk
│
├── Work                        ; scripts to support Work.ahk
│   ├── Jira.ahk
│   ├── Mute VOIP Apps.ahk
│   ├── Slack.ahk
│   └── Work Functions.ahk
│
└── Non-Production Code         ; scripts for research/experimentation/POC
    ├── Examples to keep
    └── Experiments


## Dependencies
- IntelliJ
  - Plugin "macOS Dark Mode Sync" by Johnathan Gilday automatically switches between Darcula and Intellij when OS changes
  - Enabled option: Editor > General > Change font size (Zoom) with Ctrl+MouseWheel
- Chrome extension "Dark Reader"
- VS Code extension "theme-switcher" by latusinski to toggle between light and dark mode


## To Do's
### Evaluate Status of What I Have
- Do I have problems w/some apps activating? Find the pattern!!
- Does CapsLock still get stuck? Is it "fixed"?
- Does Spotify now always open? YES
### Definitely Do These Things
- How easily update new sprint variable? Does this work?
    Would be great to add another hotkey (MAYBE ✦ ^ + J) where I open the new sprint board, select the url, and hit the hotkey. It'd parse out the sprint #, set the env var, and run this script.
      Code for setting env var is here: https://github.com/iseahound/Environment.ahk
      Can I just use SETX ??
      "HKEY_CURRENT_USER\Environment\AHK_JIRA_DEFAULT_SPRINT". 
      SendMessage 0x1A, 0, "Environment",, ahk_id 0xFFFF ; 0x1A is WM_SETTINGCHANGE
Add new user env variable: reg add "HKEY_CURRENT_USER\Environment" /v shared_dir /d "c:\shared" /t REG_SZ. Use REG_EXPAND_SZ for paths containing other %% variables.
    MUST stop and restart AutoHotkey- reload the script doesn't work. Work\Restart.bat.
    DON'T NEED TO DO THIS: "taskkill /IM explorer.exe /F" and "explorer.exe"
- Other automation ideas
    - Window management
        H left         HS       Snap active window to left half/third/two-thirds of the screen
        H right        HS       Snap active window to right half/third/two-thirds of the screen
        H up           HS       Snap active window to top half/third/two-thirds of the screen
        H down         HS       Snap active window to top half/third/two-thirds of the screen
    - Focusing/studying   : Most of this is in my old code: https://github.com/brianekummer/autohotkey/blob/master/My%20Automations.ahk
        - Should be able to do this in AHK GUI
        H ^ f ??       HS       Focusing. Starts Do Not Disturb timer for 30 minutes, 
                                which also sets Slack statuses to heads-down.
        H ^ s ??       HS       Studying. Starts Do Not Disturb timer for 60 minutes,
                                which also sets Slack statuses to books and opens udemy.com.
- Watch YouTube AHK playlist
- Learn about UIA, specifically for improving my Mute VOIP
    - https://www.the-automator.com/automate-any-program-with-ui-automation/
### Maybe Do These
- Is there any use for AppsKey (context menu)?
- GUIs are so good w/AHK, what can I do with it?
- Other automation ideas
    - Visual Studio
        - Moved Solution Explorer to left side, pinned
        - ^!l shows it 
        - +{Esc} makes it go away
        - Can I get it working with AHK??? ✦ [
            - Can't tell by the active window. maybe I can loop through all the active windows in
    - VS Code
        ✦ v    Windows (AHK)    VS Code
        ✦ ^ v  Open VS Code, create a new doc, paste selected text, then format it
    - Customizing App Behavior
        - Slack:
           ✦ ! f               Slack (AHK)      Status - Focusing - what to do on Windows??
        - VS Code - IF this is the editor I'm going to use
        ~$^s                VS Code (AHK)    After save AHK file, reload current script
    - Standardize video keys for youtube and udemyI
    - Grammarly? I coded it before, so should look into if it still works. Not sure how much I'd use Grammarly, but if
      it's EASY, I'd use it more
    - ✦ numpadsub         Windows (AHK)       TEMP - price checks
    - ✦ space             Windows (AHK)       Toggle dark mode for active application


## Future Ideas
- Any use for text-to-speech? ComObject("SAPI.SpVoice").Speak("Speak this phrase")
- Popup menus are useful- can I use them elsewhere?
- GUIs in AHK v2 are easier- anythijng to do here?
- Are timed tooltips useful somewhere?


## Decisions
- Coding style: "one true brace" (1TBS or OTB[S]) turns a single controlled statement into a compound statement by enclosing it in braces:
    if (x) {
      a();
    } else {
      b();
      c();
    }
- For Chrome extensions
    - I decided not to use "Add URL to Window Title" because there is no whitelist option, and
      having URL on every toolbar is ugly. Adding the input field id and name is cool and could
      be useful for multi-page logins (like timesheet) but that is not REQUIRED for what I need 
      (yet). https://github.com/erichgoldman/add-url-to-window-title
- Using VS Code for IDE since I'm used to it
    - These extensioons recommended by The Automator in 2022
        - AutoHotkey Plus Plus
        - AutoHotkey2 Language Support
        - vscode-autohotkey-debug [if you need better debugging support than is built into AutoHotkey Plus Plus]
    - Did not evaluate these extensions
        - Autokey Debug by Helsmy
    - Fonts - can evaluate these here: https://www.programmingfonts.org
        - My 2 favorites
            - Fira Code - Using this for now
            - Monoid - https://larsenwork.com/monoid/
        - Others
            - JetBrains Mono - https://www.jetbrains.com/lp/mono/
            - Adobe Source Code Pro - https://github.com/adobe-fonts/source-code-pro  [ I think these letters are too thin ]
            - Cascadia Code - https://windowsloop.com/download-install-cascadia-code-font/
            - Hack - https://sourcefoundry.org/hack/
- Automating browsers
    - For interacting with the code search functions, it'd be great to be able to interact with
      the web page, set focus to specific text boxes, and type text.
        - When searching for specific code, and the user did not select any text to search for, 
          it'd be great to open the page, select the search box, and enter my default search 
          text ("NOT project:abc NOT project:def")
        - When searching for a repository, and the user did not select any text to search for,
          it'd be great to open the page and set focus on the search box
    - But automating Chrome is difficult:  I cannot find code that works with AHK v2, and what
      I do find seems like it breaks often. It's not worth the work for these features.
    - Can I automate another browser easier? 
        - Since Edge is just Chromium, it's no easier. 
        - Firefox doesn't seem to have any better options. 
        - IE is easy to automate, but ick, and getting harder in Windows 11
    - I could build my own GUI in AHK and use a WebView, but that's a lot of work
    - Selenium is far more work than this feature warrants
    - Chrome has "fragments" so you can do "https://mysite.com/#section-number-two" which
        will move to the element with id "section-number-two". You cannot use this to set 
        focus on input fields, etc.
    - Chrome now has "Scroll to text fragment" that will highlight parts of the web page, 
        but that also doesn't apply to input fields


## Research
- For source code popup menu, my keyboard navigation problem is because I move the
  mouse while popping up the menu.
    - If I want to use the keyboard to navigate the popup menu, take my hand off the
    mouse


## Credits
- CapsLock as a Windows modifier: https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
                                  https://www.autohotkey.com/boards/viewtopic.php?t=70854


## VS Code Tips
- Bottom left of Explorer view is Outline
- Ctrl-Shift-P for command pallet


## Useful AutoHotkey Tips, Links, Documentation
- https://www.the-automator.com/com-and-autohotkey/
- When sending lots of text, SendInput is slow. Instead, set the text into the clipboard and send ^v. Don't' forget to save the clipboard before you start.
- Best options for automation are COM objects, then API, then UIA (UI Automation), using send/post messages, lastly SendInput/click/etc