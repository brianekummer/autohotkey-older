/**
 *  Functions to support Work.ahk
 *
 */



/**
 *  Connect to my personal computer
 */
 CreatePersonalMenu() {
  PersonalMenu.Add("Personal &Chrome", PersonalMenuHandler)
  PersonalMenu.Add("&Start Workday", PersonalMenuHandler)
  PersonalMenu.Add("&Done with Workday", PersonalMenuHandler)
  PersonalMenu.Add()  ; Add a separator
  PersonalMenu.Add("Cance&l", PersonalMenuHandler)
}

ConnectToPersonalComputer(showPopupMenu) {
  if (showPopupMenu) {
    PersonalMenu.Show()
  
  ; TODO- This appears to work if Parsec is not running, but fails if it is already open
  } else {
    if (!WinExist("ahk_exe parsecd.exe")) {
      ;msgbox Parsec is NOT running
      Run('"' . A_StartMenu . '\Programs\Startup\Parsec.lnk" peer_id=' . Configuration.Work.ParsecPeerId)
    
      ErrorLevel := WinWaitActive("ahk_exe parsecd.exe", , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
      if (ErrorLevel) {
        MsgBox("WinWait timed out.")
        return
      }
    } else {
      ;Msgbox Parsec IS running
  
      ; Is Parsec connected?
      ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
      WinActivate
    }
  
    WinMaximize("A")  ; Use the window found by WinExist|WinWaitActive
  }

  CommonReturn()
}


/**
 *  The handler for the personal pop-up menu
 * 
 *  @param itemName                The name/text of the menu item
 */
PersonalMenuHandler(itemName, *) {
  if (itemName ~= "Chrome") {
    AlwaysRunApp("", "D:\Portable Apps\GoogleChromePortable\GoogleChromePortable.exe")

  } else if (itemName ~= "Start") {
    ; 1. Turn on air cleaner, top and bottom lights
    ; 2. Set Slack status to working
    HomeAutomationCommand("officeac,officelite,officelitetop,officelitebottom", "on")
    MySlack.SetStatusWorking()

  } else if (itemName ~= "Done") {
    ; 1. Set Slack status of all my accounts to away
    ; 2. Sleep for 30 seconds so I can leave the room
    ; 3. Turn off all smart devices
    ; 4. Put the computer to sleep
    MySlack.SetPresenceAway()
    Sleep(30000)
    HomeAutomationCommand("officeac,officefan,officelite,officelitetop,officelitemiddle,officelitebottom", "off")
    PutLaptopToSleep()

  } else if (itemName ~= "Cance&l") {
    SendInput("{Escape}")
  }

  CommonReturn()
}


/**
 *  Am I at home? Am I at the office?
 * 
 *  @return     True/False
 */
AmAtHome()   => AmNearWifiNetwork(Configuration.Work.WifiNetworks.Home)
AmAtOffice() => AmNearWifiNetwork(Configuration.Work.WifiNetworks.Office)


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

  CommonReturn()
}


/**
 *  Sets my Slack status to either lunch or dinner, depending on the current time
 * 
 *  If I'm working at home, then turn off my smart devices in my office
 * 
 *  @param lunchIsBeforeHour       Any time before this hour is considered lunch
 */
SlackStatus_Eating(lunchIsBeforeHour) {
  MySlack.SetStatusEating(lunchIsBeforeHour)

  if AmAtHome() {
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom", "off")
  }

  LockWorkstation()

  CommonReturn()
}


/**
 *  Opens source code 
 * 
 *  @param showPopupMenu           If set, the source code popup menu is shown
 *                                 else the dashboard/overview is opened
 */
OpenSourceCode(showPopupMenu) {
  if (showPopupMenu) {
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
 * 
 *  @param itemName                The name/text of the menu item
 */
SourceCodeMenuHandler(itemName, *) {
  clipboard := A_Clipboard
  selectedText := Rtrim(GetSelectedTextUsingClipboard())

  if (itemName ~= "Code") {
    ; More often than not, I want to search for the selected text as a phrase, instead 
    ; of as individual words, so I want the selected text enclosed in double quotes. But,
    ; our source code search doesn't want the double quotes URL encoded. So I must 
    ; separately URL encode the prefix and the selected text and mash them together.
    searchCriteria := UriEncode(Configuration.Work.SourceCode.SearchCodePrefix . " ") . '"' . UriEncode(selectedText) . '"'
    AlwaysRunApp("Search — Bitbucket", Configuration.Work.SourceCode.SearchCodeUrl . searchCriteria)

  } else if (itemName ~= "Repositories") {
    ; I expect to often use this from within a terminate window, which doesn't return
    ; the selected text, so instead, I'll copy the text to the clipboard and THEN initiate
    ; this hotkey.
    if (StrLen(selectedText) = 0) {
      selectedText := clipboard
    }
    AlwaysRunApp("Repositories — Bitbucket", Configuration.Work.SourceCode.SearchRepositoriesUrl . UriEncode(selectedText))

  } else if (itemName ~= "Schema") {
    RunOrActivateApp("eventschema", Configuration.Work.SourceCode.SchemaUrl)

  } else if (itemName ~= "Cance&l") {
    SendInput("{Escape}")
  }

  CommonReturn()
}


/**
 *  Creates the identifiers pop-up menu
 * 
 *  This only needs created when the script starts, it is merely shown/hidden
 *  each time it is needed.
 */
 CreateIdentifiersMenu() {
  for i, item in StrSplit(EnvGet("AHK_CONSTANTS"), "|") {
    kv := StrSplit(item, ",")

    ; Add to the menu
    IdentifiersMenu.Add(kv[1], IdentifiersMenuHandler)

    ; Save for IdentifiersMenuHandler
    identifiers.push({key: kv[1], value: kv[2]})
  }

  IdentifiersMenu.Add()         ; Add a separator
  IdentifiersMenu.Add("Cance&l", IdentifiersMenuHandler)
}


/**
 *  The handler for the identifiers pop-up menu
 * 
 *  @param itemName                The name/text of the menu item
 */
IdentifiersMenuHandler(itemName, *) {
  for i, item in identifiers {
    if (itemName == item.key) {
      SendInput(item.value)
      break
    }
  }

  CommonReturn()
}


/**
 *  Runs or activates Outlook
 * 
 *  Outlook is whiny, and the "instant search" feature (press Ctrl+E to search your mail items) 
 *  refuses to run when Outlook is run as an administrator.  Because we are running this AHK script 
 *  as an administrator, we cannot simply run Outlook.  Instead, we must run it as a standard user.
 *  
 *  @param shortcut                If passed, is the shortcut/keystrokes that should be sent to Outlook
 *                                 after it has been run or activated
 */
RunOrActivateOutlook(shortcut := "") {
  outlookTitle := "i)" . Configuration.Work.UserEmailAddress . "\s-\sOutlook"
  if (!WinExist(outlookTitle)) {
    outlookExe := Configuration.WindowsProgramFilesFolder . "\Microsoft Office\root\Office16\OUTLOOK.EXE"
	  ShellRun(outlookExe)
	  WinWaitActive("outlookTitle", , 5)
  }
  WinActivate()

  if (shortcut != "") {
    SendInput(shortcut)
  }

  CommonReturn()
}	


/**
 *  Executes a home automation command
 * 
 *  @param deviceNames             The device(s) to act upon
 *  @param action                  The action to take
 *  @param actionValue             An optional parameter for some actions
 */
HomeAutomationCommand(deviceNames, action, actionValue := "") {
  webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
  data := '"action": "' . action . '"'
  if (actionValue  != "") {
    data .= ', "action_value": "' . actionValue . '"'
  }

  webRequest.Open("PUT", Configuration.Work.HomeAutomationUrl . "/devices/" . deviceNames)
  webRequest.SetRequestHeader("Content-Type", "application/json")
  webRequest.Send("{" . data . "}")

  CommonReturn()
}


/**
 *  Creates a random GUID
 * 
 *  @param wantUppercase           If True, GUID is all uppercase, else is all lowercase
 */
CreateRandomGUID(wantUppercase) {
  newGUID := ComObject("Scriptlet.TypeLib").Guid
	newGUID := StrReplace(NewGUID, "{")
	newGUID := StrReplace(NewGUID, "}")
 
  return wantUppercase ? StrUpper(newGUID) : StrLower(newGUID)
}


/**
 *  Opens the wiki
 * 
 *  @param searchForSelectedText   If set and text is selected, then the selected text is 
 *                                 searched for in the wiki, else the wiki home page is opened
 */
OpenWiki(searchForSelectedText) {
  if (searchForSelectedText) {
    selectedText := GetSelectedTextUsingClipboard()
    if (StrLen(selectedText) > 0) {
      RunOrActivateApp("Search - Confluence", UriEncode(Configuration.Work.Wiki.SearchUrl . selectedText))
      return
    } 
  }
  RunOrActivateApp("Home - Confluence", Configuration.Work.Wiki.Url)
}