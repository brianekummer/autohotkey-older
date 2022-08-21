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
  JIRA
    ✦ j                  Opens the current board
    ✦ ^ j                Opens the selected story number
                           * If the highlighted text looks like a JIRA story number (e.g. 
                             PROJECT-1234), then open that story
                           * If the Git Bash window has text that looks like a JIRA story number, 
                             then open that story
                           * Last resort is to open the current board
*/
JIRA()
{
  global JiraUrl
  pos := 0

  if (GetKeyState("Ctrl"))
  {
    regexStoryNumberWithoutProject := "\b\d{1,5}\b"
    regexStoryNumberWithProject := "i)\b(" JiraMyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"

    selectedText := GetSelectedTextUsingClipboard()
    if (StrLen(selectedText) > 0)
    {
      ; Search the selected text for something like PROJECT-1234
      pos := RegExMatch(selectedText, regexStoryNumberWithProject, &matches)
      if (pos = 0)
      { 
        ; Search for just a number, and if found, add the default project name
        pos := RegExMatch(selectedText, regexStoryNumberWithoutProject, &matches)
        if (pos > 0)
          storyNumber := JiraDefaultProjectKey "-" matches[]
      }  
    }
    
    if (pos = 0)
    { 
      ; Search for a Cmder/ConEmu terminal with a title that contains a JIRA story number
      try {
        pos := RegExMatch(
          WinGetTitle("ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass"),
          regexStoryNumberWithProject, 
          &matches)
      } catch {
      }
    }

    if (pos = 0)
    { 
      ; Search for a Mintty (comes with Git) terminal with a title that contains a JIRA story number
      try {
        pos := RegExMatch(
          WinGetTitle("ahk_exe i)\\mintty\.exe$ ahk_class mintty"),
          regexStoryNumberWithProject, 
          &matches)
      } catch {
      }
    }  

    if (pos > 0)
    {
      if (!IsSet(storyNumber))
      {
        ; Handle if there is an underscore or space instead of a hyphen, or no hyphen
        storyNumber := RegExReplace(matches[], "[\s_]", "")
        If (InStr(storyNumber, "-") = 0)
          storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
      }
      
      title := "\[" storyNumber "\].*Jira"
      url := JiraUrl "/browse/" storyNumber
      RunOrActivateAppOrUrl(title, url, 5, True, False)
      return
    }
  }

  if (pos = 0)
  {
    ; Could not find any JIRA story number, so open the default JIRA board
    title := "Agile Board - Jira"
    url := JiraUrl "/secure/RapidBoard.jspa?rapidView=" JiraDefaultRapidKey "&projectKey=" JiraDefaultProjectKey "&sprint=" JiraDefaultSprint
    RunOrActivateAppOrUrl(title, url, 5, True, False)
  }
}


/*
  Run or activate Spotify

  Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
  run the shortcut. Since the window title changes depending if something is playing or not, so
  I am using the filename.
*/
RunOrActivateSpotify()
{
  RunOrActivateAppOrUrl("ahk_exe Spotify.exe", WindowsUserProfile "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\My Shortcuts\Spotify.lnk")
}


/*
  Outlook is whiny, and the "instant search" feature (press Ctrl+E to search your mail items) 
  refuses to run when Outlook is run as an administrator. Because we are running this AHK script as 
  an administrator, we cannot simply run Outlook. Instead, we must run it as a standard user.
*/
ActivateOrStartMicrosoftOutlook(shortcut := "")
{
  global UserEmailAddress
	global WindowsProgramFilesX86Folder
	
  outlookTitle := "i)" UserEmailAddress "\s-\sOutlook"
  if (!WinExist(outlookTitle))
  {
    outlookExe := WindowsProgramFilesFolder "\Microsoft Office\root\Office16\OUTLOOK.EXE"
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
  scriptName := MyPersonalFolder "\Code\git\home-automation\home_automation.py"
  workingFolder := MyPersonalFolder "\Code\git\home-automation"
  Run A_ComSpec ' /c " "python" "' scriptName '" ' command ' >"C:\Temp\Brian.log" " ', workingFolder, "Hide"

  ; This does not work
  ;ShellRun("C:\Python39\python.exe c:\users\brian-kummer\Personal\Code\git\home-automation\home_automation.py %command%")

  ; Try running python from within Git Bash (skip ha.sh), could add "&" to end of command to run in background- 
  ; this delays, but doesn't work
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" --hide c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% && sleep 10 &",, Hide
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% &",, Hide
}


/*
  Generate a GUID
*/
GenerateGUID(uppercase) 
{
  newGUID := CreateGUID()
  SendInput(uppercase ? StrUpper(newGUID) : StrLower(newGUID))
}