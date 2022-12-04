/**
 *  Functions to support Common.ahk
 * 
 *  Dependencies
 *    - Customize Windows.FixCapsLockIfBroken()
 */



/**
 *  Initializes global variables for both work and home
 * 
 *  Requires several environment variables, see "Configure.bat" for details
 */
InitializeCommonGlobalVariables() {
  global Configuration := {
    WindowsAppDataFolder: EnvGet("APPDATA"),
    WindowsLocalAppDataFolder: EnvGet("LOCALAPPDATA"),
    WindowsProgramFilesFolder: EnvGet("PROGRAMFILES"),
    WindowsUserName: EnvGet("USERNAME"),
    WindowsUserDomain: EnvGet("USERDOMAIN"),
    WindowsUserProfile: EnvGet("USERPROFILE"),
    MyDocumentsFolder: EnvGet("USERPROFILE") "\Documents\",

    MyPersonalFolder: EnvGet("AHK_PERSONAL_FILES"),
    MyPersonalDocumentsFolder: EnvGet("AHK_PERSONAL_FILES") "\Documents\",
    
    ; For home laptop, USERDOMAIN = COMPUTERNAME = "BRIAN-DESKTOP"
    IsWorkLaptop: EnvGet("USERDOMAIN") != EnvGet("COMPUTERNAME")
  }
}


/**
 *  Send keystrokes to my personal computer, optionally activating the window first
 * 
 *  @param keystrokes      The keystrokes to send
 *  @param activateFirst   Should the window be activated before sending the keystrokes?
 */
SendKeystrokesToPersonalLaptop(keystrokes, activateFirst := True) {
  if (activateFirst) {
    ; Two issues addressed here:
    ;   1. Running D:\Portable Apps\Parsec\parsecd.exe didn't work, so I'm running the shortcut
    ;   2. I could not get RunOrActivateApp() to work with the parameter I'm passing to parsecd, so I just replicated the
    ;      relevant parts of that function here

    ;Run('"' A_StartMenu '\Programs\Parsec.lnk" peer_id=' Configuration.Work.ParsecPeerId)

    ;WinWaitActive, ahk_exe parsecd.exe,, 5
    ;If ErrorLevel
    ;{
    ;  MsgBox, WinWait timed out.
    ;  Return
    ;}

    ; TODO- This appears to work if Parsec is not running, but fails if it is already open
    if (!WinExist("ahk_exe parsecd.exe")) {
      MsgBox("Parsec is NOT running")
      Run('"' . A_StartMenu . '\Programs\Parsec.lnk" peer_id=' . Configuration.Work.ParsecPeerId)
      
      ErrorLevel := WinWaitActive("ahk_exe parsecd.exe", , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
      if (ErrorLevel) {
        MsgBox("WinWait timed out.")
        return
      }
    } else {
      ;Msgbox Parsec IS running
    
      ; Is Parsec connected?
      ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
      WinActivate()
    }
    WinMaximize()   ; Use the window found by WinExist|WinWaitActive
  }
  
  ; Wait for "brianekummer#xxxxxxx" or "Connect to your computers or a friend's computer in low latency desktop mode" to disappear
  ; Also beware having to log into computer w/pin code
  ;   - I changed NUC to be same pic all the time- find "I forgot my pin"
  ;Sleep 500    ; If Parsec is connected, this is enough time. If not connected, it is not
  ;WaitForParsecToConnect() 

  ;ControlSend,, %keystrokes%, ahk_exe parsecd.exe
  
  ; OLD STUFF I DON'T NEED
  ;OLD- ControlSend,, %keystrokes%, Parsec
  ;SendInput {Blind}%keystrokes%


  CommonReturn()
}


/**
 *  Google Search for the selected text
 */
GoogleSearch() {
  selectedText := GetSelectedTextUsingClipboard()
  selectedText := RegExReplace(RegExReplace(selectedText, "\r?\n", " "), "(^\s+|\s+$)")
  RunOrActivateApp("- Google Chrome", "https://www.google.com/search?hl=en&q=" . selectedText)
}


/**
 *  Run or activate the browser
 *    - If there is selected text that is a url, then it it opened
 *    - If the browser is already opened, switch to it
 */
RunOrActivateBrowser() {
  selectedText := GetSelectedTextUsingClipboard()
  if (selectedText ~= "https?:\/\/") {
    AlwaysRunApp("- Google Chrome", selectedText)
  } else {
    RunOrActivateApp("- Google Chrome", Configuration.WindowsProgramFilesFolder . "\Google\Chrome\Application\chrome.exe")
  }
}


/**
 *  Runs or activates the Spotify app
 *
 *  Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
 *  run the shortcut.  Since the window title changes, depending if something is playing or not, 
 *  I am using the filename to find the window.
 * 
 *  Although this is only used on my work laptop, it is referenced by Customize Windows.ahk, which 
 *  means it must be available for Home.ahk to compile, so I moved it into Common Functions.ahk.
 */
RunOrActivateSpotify() {
  RunOrActivateApp("ahk_exe Spotify.exe", A_StartMenu . "\Programs\My Shortcuts\Spotify.lnk", False)
  FixCapsLockIfBroken()
}


/**
 *  Run or activate VS Code
 * 
 *  Run or activate VS Code. If there is selected text, and it is a format we know, then create a new file,
 *  insert the selected text, and format it using the default formatter for that file type
 */
RunOrActivateVSCode() {
  ; Save the selected text into the clipboard, based on code in Utilities.GetSelectedTextUsingClipboard().
  ; Later, in VSCodeNewFile(), we'll paste the clipboard into the new file because, for large amounts of text, that's 
  ; much faster than SendInput(selectedText)
  selectedText := ""
  clipSaved := A_Clipboard  
  A_Clipboard := ""
  SendInput("^c")
  Errorlevel := !ClipWait(1)
  selectedText := A_Clipboard
  Sleep(100)
  
  RunOrActivateAppAsAdmin("ahk_exe i)\\code\.exe$", Configuration.WindowsProgramFilesFolder . "\Microsoft VS Code\Code.exe")

  if (StrLen(selectedText) > 0) {
    ; There is selected text, so create a new file, paste the selected text into the new file, and format it using
    ; the default formatter
    Sleep(500)
    VSCodeNewFile(selectedText)
  }

  A_Clipboard := clipSaved
  clipSaved := ""
}


/**
 *  Optionally, create a new document in VSCode
 * 
 *  If the provided fileContents is a known file type, then create a new VS Code file, insert the provided contents,
 *  and format it
 *
 *  ASSUMES fileContents is still in the clipboard, because it is much faster to paste the clipboard than to
 *  use SendInput() for large amounts of text
 * 
 *  @param fileContents            The text to insert into the new file
 */
VSCodeNewFile(fileContents) {
  ; List the formats we recognize, a regular expression to recognize that format, and either 
  ; a "language" whose formatter we should use, or a "command" to execute that will format the 
  ; document.
  ;   - The order of these matters. Xml also matches html, and html with some JavaScript could match 
  ;     the Json regex.
  ;   - Identifying SQL is complex. As a rough guess, look for any one of the following:
  ;       CREATE|ALTER...FUNCTION|PROCEDURE|VIEW|INDEX...AS BEGIN
  ;       DROP...FUNCTION|PROCEDURE|VIEW|INDEX
  ;       SELECT...FROM
  knownFormats := [
    {
      name:     "html",                       ; VSC Extension: "HTML formatter" by Nikolaos Georgiou
      regex:    "s).*<html>.*/.*>",
      language: "html"
    }, 
    {
      name:     "xml",                        ; VSC Extension: "XML Tools" by Josh Johnson
      regex:    "s)^\s*<.*>.*/.*>",
      language: "xml"
    },
    {
      name:     "json",                       ; Built-in formatter?
      regex:    "s)^\s*\[?\{.*\:.*\,.*\}",
      language: "json"
    },
    {
      name:     "sql",                        ; VSC Extension: "SQL Formatter" by adpyke
      regex:    "is)("
                . "(\b(create|alter)\b.*\b(function|procedure|view|index)\b.*\bas\s+begin\b)|"
                . "(\bdrop\b.*\b(function|procedure|view|index)\b)|"
                . "(\bselect\b.*\bfrom\b)"
              . ")+",
      language: "sql"
    },
    {
      name:     "stacktrace",                 ; VSC Extension: "stacktrace-formatter" by polston
      regex:    "\bat.*\(.*\) in .*:line",
      command:  "Format Stack Trace"
    }
  ]

  for format in knownFormats {
    if (RegExMatch(fileContents, format.regex)) {
      ; YES- the format of the selected text is known

      ; Create a new document and paste in the selected text
      SendInput("^n")
      SendInput("^v")
      Sleep(1000)
      
      if (format.HasProp("language")) {
        ; Set the language for the document, then format the document using the default formatter
        SendInput("^{k}m")
        Sleep(250)
        SendInput(format.language . "{Enter}")
        Sleep(1500)

        SendInput("+!{f}")
 
      } else if (StrLen(format.command) > 0) {
        ; Open the command palette, type the command, and press Enter
        SendInput("^+p")
        Sleep(250)
        SendInput(format.command . "{Enter}")
      }

      ; Scroll back to the start of the document
      Sleep(250)
      SendInput("^{Home}")

      break
    }
  }
}


/**
 *  We'll try this
 */
CommonReturn() {
  FixCapsLockIfBroken()
}