/**
 *  Functions to support Work.ahk
 *
 */



/**
 *  Connect to my personal computer
 */
 ConnectToPersonalComputer() {
  ; TODO- This appears to work if Parsec is not running, but fails if it is already open
  if (!WinExist("ahk_exe parsecd.exe")) {
    ;msgbox Parsec is NOT running
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
  
  WinMaximize()  ; Use the window found by WinExist|WinWaitActive
}


/**
 *  Am I at home?
 * 
 *  @return     True if I'm near any of my home wifi networks, else False
 */
AmAtHome() {
  return AmNearWifiNetwork(Configuration.Work.WifiNetworks.Home)
}


/**
 *  Am I at the office?
 * 
 *  @return     True if I'm near any of my employer's wifi networks, else False
 */
AmAtOffice() {
  return AmNearWifiNetwork(Configuration.Work.WifiNetworks.Office)
}


/**
 *  Price watch web sites
 *    - Sometimes I have to escape special characters like %
 *    - Edge is being a pain and sometimes launching here, so I'm explicitly saying to use Chrome
 */
PriceWatchWebsites() {
}


/**
 *  Sets my Slack status to "Be Right Back"
 * 
 *  If I am at the office, then lock my laptop
 */
SlackStatus_BeRightBack() {
  MySlack.SetStatusBeRightBack()

  if AmAtOffice() {
    LockWorkstation()
  }
}


/**
 *  Sets my status to either lunch or dinner, depending on the current time
 * 
 *  If I'm working at home, then turn off my smart devices in my office
 * 
 *  @param lunchIsBeforeHour     Any time before this hour is considered lunch
 */
SlackStatus_Eating(lunchIsBeforeHour) {
  MySlack.SetStatusEating(lunchIsBeforeHour)

  if AmAtHome() {
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom off")
  }

  LockWorkstation()
}


/**
 *  Opens source code 
 * 
 *  - If Ctrl is not pressed, then the dashboard/overview is opened
 *  - If Ctrl is pressed, a pop-up menu lets me select between
 *      - Searching for code that matches the selected text
 *      - Searching for a repository whose name matches the selected text
 *      - Our event schema repository
 * 
 *  @param ctrlPressed
 */
OpenSourceCode(ctrlPressed) {
  if (ctrlPressed) {
    SourceCodeMenu.Show()
  } else {
    RunOrActivateApp("Overview", Configuration.Work.SourceCode.Url)
  }
}


/**
 *  Creates the source code pop-up menu
 * 
 *  This only needs created when the script starts, it is merely shown/hidden
 *  each time it is needed.
 */
CreateSourceCodeMenu() {
  SourceCodeMenu.Add("Search &Code", SourceCodeMenuHandler)
  SourceCodeMenu.Add("Search &Repositories", SourceCodeMenuHandler)
  SourceCodeMenu.Add()  ; Add a separator
  SourceCodeMenu.Add("&Event Schema Repository", SourceCodeMenuHandler)
  SourceCodeMenu.Add()  ; Add a separator
  SourceCodeMenu.Add("Cance&l", SourceCodeMenuHandler)
}


/**
 *  The handler for the source code pop-up menu
 */
SourceCodeMenuHandler(itemName, *) {
  selectedText := GetSelectedTextUsingClipboard()

  if (itemName ~= "Code") {
    searchCriteria := Configuration.Work.SourceCode.SearchCodePrefix " " selectedText
    AlwaysRunApp("Search — Bitbucket", Configuration.Work.SourceCode.SearchCodeUrl URI_Encode(searchCriteria))
  } else if (itemName ~= "Repositories") {
    AlwaysRunApp("Repositories — Bitbucket", Configuration.Work.SourceCode.SearchRepositoriesUrl URI_Encode(GetSelectedTextUsingClipboard()))
  } else if (itemName ~= "Schema") {
    RunOrActivateApp("eventschema", Configuration.Work.SourceCode.SchemaUrl)
  } else if (itemName ~= "Cance&l") {
    SendInput("{Escape}")
  }
}


/**
 *  Runs or activates the Spotify app
 *
 *  Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
 *  run the shortcut.  Since the window title changes, depending if something is playing or not, 
 *  I am using the filename to find the window.
 */
RunOrActivateSpotify() {
  RunOrActivateApp("ahk_exe Spotify.exe", A_StartMenu "\Programs\My Shortcuts\Spotify.lnk", False)
}


/**
 *  Runs or activates Outlook
 * 
 *  Outlook is whiny, and the "instant search" feature (press Ctrl+E to search your mail items) 
 *  refuses to run when Outlook is run as an administrator.  Because we are running this AHK script 
 *  as an administrator, we cannot simply run Outlook.  Instead, we must run it as a standard user.
 *  
 *  @param shortcut       If passed, is the shortcut/keystrokes that should be sent to Outlook
 *                        after it has been run or activated
 */
RunOrActivateOutlook(shortcut := "") {
  outlookTitle := "i)" Configuration.Work.UserEmailAddress "\s-\sOutlook"
  if (!WinExist(outlookTitle)) {
    outlookExe := Configuration.WindowsProgramFilesFolder "\Microsoft Office\root\Office16\OUTLOOK.EXE"
	  ShellRun(outlookExe)
	  WinWaitActive("outlookTitle", , 5)
  }
  WinActivate()

  if (shortcut != "") {
    SendInput(shortcut)
  }
}	


/**
 *  Executes a home automation command
 * 
 *  This code works synchronously, so I don't love it, but at least it does not display a console box
 *
 *  I'd love to get this working asynchronously, so I could pound the key a couple of times instead of 
 *  having to wait for each one.
 *    - This does not work
 *       ShellRun("C:\Python39\python.exe c:\users\brian-kummer\Personal\Code\git\home-automation\home_automation.py %command%")
 *    - Try running python from within Git Bash (skip ha.sh), could add "&" to end of command to run in
 *      background- this delays, but doesn't work
 *        Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" --hide c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% && sleep 10 &",, Hide
 *        Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% &",, Hide
 * 
 *  @param command        The command to execute
 */
HomeAutomationCommand(command) {
  workingFolder := Configuration.MyPersonalFolder "\Code\git\home-automation"
  scriptName := workingFolder "\home_automation.py"
  Run A_ComSpec ' /c " "python" "' scriptName '" ' command ' " ', workingFolder, "Hide"
}


/**
 *  Creates a random GUID
 * 
 *  @param wantUppercase        If True, GUID is all uppercase, else is all lowercase
 */
CreateRandomGUID(wantUppercase) {
  newGUID := ComObject("Scriptlet.TypeLib").Guid
	newGUID := StrReplace(NewGUID, "{")
	newGUID := StrReplace(NewGUID, "}")
 
  return wantUppercase ? StrUpper(newGUID) : StrLower(newGUID)
}