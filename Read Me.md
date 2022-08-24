# My AutoHotkey Automations for Work & Home


## Hotkeys



## Code Structure




## To Do's
### Evaluate Status of What I Have
- Does everything still work?
- Does CapsLock still get stuck? Is it "fixed"?
- Does Spotify now always open?
### Definitely Do These Things
- Watch YouTube AHK playlist
- Figure out what to do with "source code" - My current thoughts... I'm liking this idea...
    - ✦ s     Source code overview (BitBucket dashboard)
    - ✦ ^ s   Source code popup menu- choose between event schema, search code, search repo- make sure menu can be done w/keyboard. I don't use any
              of these enough to have a default, but they'd all be helpful.
                 - Search code- if no selected text, go to search page and set focus to window to enter search criteria
                 - Search repo- if no selected text, go to search page and set focus to window to enter search criteria
                 - Event schema
- Look into automating switching between home and work scripts. Options
    - Have 1 common script that both machines run, and then pull in appropriate file
    - Combine together and only enable appropriately
- Redo comments- content, formatting, move some comments from code into this readme
- Update Configure.bat
- Backup env vars to Google Drive
- Merge v2 into main branch
### Maybe Do These
- How can I get rid of HA on Tele laptop, specifically need for username and password as env vars?
    - Send command to my NUC? SSH?
    - Send command to a phone w/autoremote? My phone because of fixed IP? Work status phone? LR Pi?
    - How slow will it be?
- Is there any use for AppsKey (context menu)?
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
    - Standardize video keys for youtube and udemy
    - Grammarly? I coded it before, so should look into if it still works. Not sure how much I'd use Grammarly, but if
      it's EASY, I'd use it more
    - Window management
        H left         HS       Snap active window to left half/third/two-thirds of the screen
        H right        HS       Snap active window to right half/third/two-thirds of the screen
        H up           HS       Snap active window to top half/third/two-thirds of the screen
        H down         HS       Snap active window to top half/third/two-thirds of the screen
        H return       HS       Toggle full screen
        H ^ up         HS       Maximize window
        H ^ down       HS       Minimize window
        H ^ left       HS       Move active window to the previous screen
        H ^ right      HS       Move active window to the next screen
    - Focusing/studying
        H ^ f ??       HS       Focusing. Starts Do Not Disturb timer for 30 minutes, 
                                which also sets Slack statuses to heads-down.
        H ^ s ??       HS       Studying. Starts Do Not Disturb timer for 60 minutes,
                                which also sets Slack statuses to books and opens udemy.com.





## Future Ideas
- Any use for text-to-speech? ComObject("SAPI.SpVoice").Speak("Speak this phrase")
- Popup menus are useful- can I use them elsewhere?
- Are timed tooltips useful somewhere?
- Are classes useful anywhere?





## Old Stuff That Needs Cleaned Up
;
; There is often interaction between the work laptop and the personal laptop, so both bits of code
; are here, to simplify seeing how these interact. For example, when I press CapsLock+F12 to open
; the webpages I am price watching, the work laptop needs to send CapsLock+F12 to the personal 
; laptop, and the personal laptop has to react to that.
;
;
; Modifiers
; ---------
; ^ = Ctrl     ! = Alt     + = Shift     # = Windows      ✦ = CapsLock/Hyper
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
; ✦ j                   Windows (AHK)    JIRA- current project board
; ✦ ^ j                 Windows (AHK)    JIRA- open selected story number
; ✦ m                   Windows (AHK)    Music/Spotify
; ✦ t                   Windows (AHK)    Terminal/Cmder/bash
; PrintScreen           Windows (AHK)    Windows screenshot tool
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
; ?????
;^#pause::Run("nircmd setdefaultsounddevice `"Headphones`"", , "Hide")      ; ^numlock = ^pause
;^#numpadsub::Run("nircmd setdefaultsounddevice `"Headset`"", , "Hide")
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
;   ✦ ! b               Slack (AHK)      Status - Be Right Back. Sets Slack statuses to brb and presence to away.
;   ✦ ! l               Slack (AHK)      Status - At lunch. Sets Slack statuses to lunch and presence to away.
;   ✦ ! m               Slack (AHK)      Status - In a meeting. Sets Slack statuses to mtg and sets presence to auto.
;   ✦ ! p               Slack (AHK)      Status - Playing. Sets home Slack status to 8bit.
;   ✦ ! w               Slack (AHK)      Status - Working. Clears Slack statuses and sets presence to auto.
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
; â”œâ”€ Main Home.ahk               Main code for personal laptop, mostly hotkeys that call functions
; â”œâ”€ Main Work.ahk               Main code for work laptop, mostly hotkeys that call functions
; â”œâ”€ Shared.ahk                  Shared between personal and work laptops, mostly hotkeys that call functions
; â”œâ”€ Functions.ahk               Majority of my code is here
; â”œâ”€ Convert Case.ahk            Cycle through lower/upper/sentence/title case
; â”œâ”€ Customize Windows.ahk       Code that customizes how Windows works
; â”œâ”€ My Auto Correct.ahk         My wrapper over AutoCorrect.ahk that includes my words to correct
; â”œâ”€ Mute VOIP Apps.ahk          Functions to mute Microsoft Teams, Slack, and Zoom calls/meetings
; â”œâ”€ Slack.ahk                   Controlling Slack
; â””â”€ Utilities.ahk               Utility functions
;
;
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
;


## Decisions
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



## Credits
- CapsLock as a Windows modifier: https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
                                  https://www.autohotkey.com/boards/viewtopic.php?t=70854


## VS Code Tips
- Bottom left of Explorer view is Outline
- Ctrl-Shift-P for command pallet
