; The body of most everything is here
; do not include re-usable utility type functions


;--------------------------------------------------------------------------------------------------
; Price watch web sites
;
; Note that sometimes I have to escape special characters like %
; Edge is being a pain and sometimes launching here, so I'm explicitly saying to use Chrome
;--------------------------------------------------------------------------------------------------
PriceWatchWebsites()
{
}


;--------------------------------------------------------------------------------------------------
; JIRA
;   â‡ª j                  Opens the current board
;   â‡ª ^ j                Opens the selected story number
;                          * If the highlighted text looks like a JIRA story number (e.g. 
;                            PROJECT-1234), then open that story
;                          * If the Git Bash window has text that looks like a JIRA story number, 
;                            then open that story
;                          * Last resort is to open the current board
;--------------------------------------------------------------------------------------------------
JIRA()
{
  Global JiraUrl
  pos := 0

  If (GetKeyState("Ctrl"))
  {
    regexStoryNumberWithoutProject := "\b\d{1,5}\b"
    regexStoryNumberWithProject := "i)\b(" JiraMyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"

    selectedText := GetSelectedTextUsingClipboard()
    If (StrLen(selectedText) > 0)
    {
      ; Search the selected text for something like PROJECT-1234
      pos := RegExMatch(selectedText, regexStoryNumberWithProject, &matches)
      If (pos = 0)
      { 
        ; Search for just a number, and if found, add the default project name
        pos := RegExMatch(selectedText, regexStoryNumberWithoutProject, &matches)
        If (pos > 0)
        {
          storyNumber := JiraDefaultProjectKey "-" matches[]
          msgbox("Found story # without project = " storyNumber)
        }
      }  
    }
    
    If (pos = 0)
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

    If (pos = 0)
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

    If (pos > 0)
    {
      if !IsSet(storyNumber)
      {
        ; Handle if there is an underscore or space instead of a hyphen, or no hyphen
        storyNumber := RegExReplace(matches[], "[\s_]", "")
        If (InStr(storyNumber, "-") = 0)
        {
          storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
        }
      }
      
      RunOrActivateAppOrUrl(
        "\[" storyNumber "\].*Jira", 
        JiraUrl "/browse/" storyNumber, 
        5, true, false)
      Return
    }
  }

  If (pos = 0)
  {
    ; Could not find any JIRA story number, so open the default JIRA board
    RunOrActivateAppOrUrl(
      "Agile Board - Jira", 
      JiraUrl "/secure/RapidBoard.jspa?rapidView=" JiraDefaultRapidKey "&projectKey=" JiraDefaultProjectKey "&sprint=" JiraDefaultSprint, 
      5, true, false)
  }
}


JIRA_OLD()
{
  Global JiraUrl
  If GetKeyState("Ctrl")
  {
    regexStoryNumberWithoutProject := "\b\d{1,5}\b"
    regexStoryNumberWithProject := "i)\b(" JiraMyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"
    pathBrowse := "/browse/"
    pathDefaultBoard := "/secure/RapidBoard.jspa?rapidView=" JiraDefaultRapidKey "&projectKey=" JiraDefaultProjectKey "&sprint=" JiraDefaultSprint

    selectedText := GetSelectedTextUsingClipboard()
    msgbox("Selected text = " selectedText)

    ; Search the selected text for something like PROJECT-1234
    pos := RegExMatch(selectedText, regexStoryNumberWithProject, &matches)
    msgbox("First pos = " pos)

    If pos = 0
    { 
      ; Search for just a number, and if found, add the default project name
      pos := RegExMatch(selectedText, regexStoryNumberWithoutProject, &matches)
      msgbox("Matches = " matches.Count " len = " matches.Len " , pos = " pos)
      msgbox(matches[])

      If pos > 0
      {
        storyNumber := JiraDefaultProjectKey "-" matches[]
        msgbox("Found story # without project = " storyNumber)
      }
    }  
    
    If pos = 0
    { 
      ; Search for a ConEmu terminal with a JIRA story number
      git_window_title := WinGetTitle("ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass")
      pos := RegExMatch(git_window_title, regexStoryNumberWithProject, &matches)
      msgbox("Searched for ConEmu window, pos = " pos)
    }

    If pos = 0
    { 
      ; Search for a Mintty terminal (comes with Git) with a JIRA story number
      git_window_title := WinGetTitle("ahk_exe i)\\mintty\.exe$ ahk_class mintty")
      pos := RegExMatch(git_window_title, regexStoryNumberWithProject, &matches)
      msgbox("Searched for Mintty window, pos = " pos)
    }  

    If pos = 0
    {
      ; Could not find any JIRA story number, go to a default JIRA board
      msgbox("couldn't find a story #, so opening default board")
      url := JiraUrl pathDefaultBoard
      RunOrActivateAppOrUrl("Agile Board - Jira", url, 5, true, false)
    }
    Else
    {
      msgbox("found something")
      if !IsSet(storyNumber)
      {
        msgbox("Have something, not yet a story = " matches[])
        ; Handle if there is an underscore or space instead of a hyphen, or no hyphen
        storyNumber := RegExReplace(matches[], "[\s_]", "")
        msgbox("A # = " storyNumber)
        If Not RegExMatch(storyNumber, "-")
        {
          msgbox("B # = " storyNumber)
          storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
          msgbox("C # = " storyNumber)
        }
      }
      
      url := JiraUrl "" pathBrowse "" storyNumber
      title := "\[" storyNumber "\]"
      msgbox("DONE. Story # = " storyNumber " , url=" url " , title=" title)
      RunOrActivateAppOrUrl(title, url, 5, true, false)
    }
  }
  Else  ; Ctrl is not pressed
  {
    ; FIXED
  	pathDefaultBoard := "/secure/RapidBoard.jspa?rapidView=" JiraDefaultRapidKey "&projectKey=" JiraDefaultProjectKey "&sprint=" JiraDefaultSprint
    url := JiraUrl pathDefaultBoard
    RunOrActivateAppOrUrl("Agile Board - Jira", url, 5, true, false)
  }
}





;--------------------------------------------------------------------------------------------------
; Run or activate Spotify
;   Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
;   run the shortcut. Since the window title changes depending if something is playing or not, so
;   I am using the filename.
;--------------------------------------------------------------------------------------------------
RunOrActivateSpotify()
{
  RunOrActivateAppOrUrl("ahk_exe Spotify.exe", WindowsUserProfile "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\My Shortcuts\Spotify.lnk")
}


;--------------------------------------------------------------------------------------------------
; Outlook is whiny, and the "instant search" feature (press Ctrl+E to search your mail items) 
; refuses to run when Outlook is run as an administrator. Because we are running this AHK script as 
; an administrator, we cannot simply run Outlook. Instead, we must run it as a standard user.
;--------------------------------------------------------------------------------------------------
ActivateOrStartMicrosoftOutlook(shortcut := "")
{
  Global UserEmailAddress
	Global WindowsProgramFilesX86Folder
	
  outlookTitle := "i)" UserEmailAddress "\s-\sOutlook"
  If Not WinExist(outlookTitle)	
  {
    outlookExe := WindowsProgramFilesFolder "\Microsoft Office\root\Office16\OUTLOOK.EXE"
	  ShellRun(outlookExe)
	  WinWaitActive("outlookTitle", , 5)
  }
  WinActivate()

  if (shortcut != "")
    SendInput(shortcut)
}	


;--------------------------------------------------------------------------------------------------
; Execute a home automation command
;--------------------------------------------------------------------------------------------------
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


;--------------------------------------------------------------------------------------------------
; Generate a GUID
;--------------------------------------------------------------------------------------------------
GenerateGUID(uppercase) 
{
  newGUID := CreateGUID()
  SendInput(uppercase ? StrUpper(newGUID) : StrLower(newGUID))
}
