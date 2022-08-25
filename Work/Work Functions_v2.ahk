/*
  The body of most everything is here
  do not include re-usable utility type functions
*/


/*
  Price watch web sites

  Note that sometimes I have to escape special characters like %
  Edge is being a pain and sometimes launching here, so I'm explicitly saying to use Chrome
*/
PriceWatchWebsites()
{
}


/*

*/
SlackStatus_Eating(lunchIsBeforeHour)
{
  MySlack.SetStatusEating(lunchIsBeforeHour)

  if AmNearWifiNetwork(Configuration.Work.WifiNetworks.Home)
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom off")

  DllCall("user32.dll\LockWorkStation")
}


/*

*/
OpenSourceCode(ctrlPressed)
{
  if (ctrlPressed)
    SourceCodeMenu.Show()
  else
    RunOrActivateApp("Overview", Configuration.Work.SourceCode.Url)
}

CreateSourceCodeMenu() 
{
  SourceCodeMenu.Add("Search &Code", MenuHandlerSearchCode)
  SourceCodeMenu.Add("Search &Repositories", MenuHandlerSearchRepositories)
  SourceCodeMenu.Add()  ; Add a separator
  SourceCodeMenu.Add("&Event Schema Repository", MenuHandlerEventSchema)
  SourceCodeMenu.Add()  ; Add a separator
  SourceCodeMenu.Add("Cance&l", MenuHandlerCancel)
}

MenuHandlerSearchCode(*) 
{
  ; TODO- FIX not always able to use keyboard

  selectedText := GetSelectedTextUsingClipboard()
  searchCriteria := Configuration.Work.SourceCode.SearchCodePrefix " " selectedText

  ; TODO- LATER, COULD, if there is no search criteria, open the page w/no search criteria, 
  ; select the input w/class "css-13hc3dd" and type in the search criteria (NOT ...)
  ; NOT SURE how I can find that textbox because it has no id. Would have to automate Chrome 
  ; to do this, but would be cool
  ;if (StrLen(selectedText) = 0)
  ;{
    /* Do automation of chrome. 
        - Open Configuration.Work.SourceCode.SearchCodeUrl
        - select the input w/class "css-13hc3dd" - NOT SURE how I can find that textbox because it has no id
        - SendInput(searchCriteria)
    */
  ;}
  ;else
  ;{
    AlwaysRunApp("Search — Bitbucket", Configuration.Work.SourceCode.SearchCodeUrl URI_Encode(searchCriteria))
  ;}
}
MenuHandlerSearchRepositories(*) 
{
  selectedText := GetSelectedTextUsingClipboard()

  ;if (StrLen(selectedText) = 0)
  ;{
    /* Do automation of chrome. 
      - Open Configuration.Work.SourceCode.SearchRepositoriesUrl
      - Set focus to textbox id = search_repository-input (may have to send Tab 2x)
      
      - Alternative
          - Open Configuration.Work.SourceCode.Url 
          - SendInput("/") so user can type name there
    */
  ;}
  ;else
  ;{
    AlwaysRunApp("Repositories — Bitbucket", Configuration.Work.SourceCode.SearchRepositoriesUrl URI_Encode(GetSelectedTextUsingClipboard()))
  ;}


}
MenuHandlerEventSchema(*)
{
  RunOrActivateApp("eventschema", Configuration.Work.SourceCode.SchemaUrl)
}
MenuHandlerCancel(*)
{
  SendInput("{Escape}")
}
  








/*
  Run or activate Spotify

  Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
  run the shortcut. Since the window title changes depending if something is playing or not, so
  I am using the filename.
*/
RunOrActivateSpotify()
{
  RunOrActivateApp("ahk_exe Spotify.exe", A_StartMenu "\Programs\My Shortcuts\Spotify.lnk", False)
}


/*
  Outlook is whiny, and the "instant search" feature (press Ctrl+E to search your mail items) 
  refuses to run when Outlook is run as an administrator. Because we are running this AHK script as 
  an administrator, we cannot simply run Outlook. Instead, we must run it as a standard user.
*/
RunOrActivateOutlook(shortcut := "")
{
  outlookTitle := "i)" Configuration.Work.UserEmailAddress "\s-\sOutlook"
  if (!WinExist(outlookTitle))
  {
    outlookExe := Configuration.WindowsProgramFilesFolder "\Microsoft Office\root\Office16\OUTLOOK.EXE"
	  ShellRun(outlookExe)
	  WinWaitActive("outlookTitle", , 5)
  }
  WinActivate()

  if (shortcut != "")
    SendInput(shortcut)
}	


/*
  Execute a home automation command
*/
HomeAutomationCommand(command) 
{
  ; I'd love to get this working asynchronously, so I could pound the key a couple
  ; of times instead of having to wait for each one.

  ; This works. It's synchronous, so don't love it, but at least it does not display a DOS box.
  workingFolder := Configuration.MyPersonalFolder "\Code\git\home-automation"
  scriptName := workingFolder "\home_automation.py"
  Run A_ComSpec ' /c " "python" "' scriptName '" ' command ' " ', workingFolder, "Hide"

  ; This does not work
  ;ShellRun("C:\Python39\python.exe c:\users\brian-kummer\Personal\Code\git\home-automation\home_automation.py %command%")

  ; Try running python from within Git Bash (skip ha.sh), could add "&" to end of command to run in background- 
  ; this delays, but doesn't work
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" --hide c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% && sleep 10 &",, Hide
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% &",, Hide
}


/*
  Create a random GUID
*/
CreateRandomGUID(wantUppercase) 
{
  newGUID := ComObject("Scriptlet.TypeLib").Guid
	newGUID := StrReplace(NewGUID, "{")
	newGUID := StrReplace(NewGUID, "}")
 
  return wantUppercase ? StrUpper(newGUID) : StrLower(newGUID)
}