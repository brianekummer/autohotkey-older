/**
 *  Functions to support Common.ahk
 *
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
      Run('"' A_StartMenu '\Programs\Parsec.lnk" peer_id=' Configuration.Work.ParsecPeerId)
      
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
}


/**
 *  Google Search for the selected text
 */
GoogleSearch() {
  selectedText := GetSelectedTextUsingClipboard()
  selectedText := RegExReplace(RegExReplace(selectedText, "\r?\n", " "), "(^\s+|\s+$)")
  RunOrActivateApp("- Google Chrome", "https://www.google.com/search?hl=en&q=" selectedText)
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
    RunOrActivateApp("- Google Chrome", Configuration.WindowsProgramFilesFolder "\Google\Chrome\Application\chrome.exe")
  }
}