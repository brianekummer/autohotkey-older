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
;   ⇪ j                  Opens the current board
;   ⇪ ^ j                Opens the selected story number
;                          * If the highlighted text looks like a JIRA story number (e.g. 
;                            PROJECT-1234), then open that story
;  TODO- FIX THIS!!!       * If the Git Bash window has text that looks like a JIRA story number, 
;                            then open that story
;                          * Last resort is to open the current board
;--------------------------------------------------------------------------------------------------
JIRA()
{
  Global JiraUrl
  If GetKeyState("Ctrl")
  {
    regexStoryNumberWithoutProject = \b\d{1,5}\b
    regexStoryNumberWithProject = i)\b(%JiraMyProjectKeys%)([-_ ]|( - ))?\d{1,5}\b
    pathBrowse = /browse/
    pathDefaultBoard = /secure/RapidBoard.jspa?rapidView=%JiraDefaultRapidKey%&projectKey=%JiraDefaultProjectKey%&sprint=%JiraDefaultSprint%

    selectedText := GetSelectedTextUsingClipboard()

    ; Search the selected text for something like PROJECT-1234
    RegExMatch(selectedText, regexStoryNumberWithProject, storyNumber)

    If StrLen(storyNumber) = 0
    { 
      ; Search for just a number, and if found, add the default project name
      RegExMatch(selectedText, regexStoryNumberWithoutProject, storyNumber)
      If StrLen(storyNumber) > 0
      {
        storyNumber = %JiraDefaultProjectKey%-%storyNumber%
      }
    }  
    
    If StrLen(storyNumber) = 0
    { 
      ; Search for a ConEmu terminal with a JIRA story number
      WinGetTitle, git_window_title, ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass
      RegExMatch(git_window_title, regexStoryNumberWithProject, storyNumber)
    }

    If StrLen(storyNumber) = 0
    { 
      ; Search for a Mintty terminal (comes with Git) with a JIRA story number
      WinGetTitle, git_window_title, ahk_exe i)\\mintty\.exe$ ahk_class mintty
      RegExMatch(git_window_title, regexStoryNumberWithProject, storyNumber)
    }  

    If StrLen(storyNumber) = 0
    {
      ; Could not find any JIRA story number, go to a default JIRA board
      url = %JiraUrl%%pathDefaultBoard%
      RunOrActivateAppOrUrl("Agile Board - Jira", url, 3, true, false)
    }
    Else
    {
      ; Handle if there is an underscore or space instead of a hyphen, or no hyphen
      storyNumber := RegExReplace(storyNumber, "[\s_]", "")
      If Not RegExMatch(storyNumber, "-")
      {
        storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
      }
      
      url = %JiraUrl%%pathBrowse%%storyNumber%
      title = [%storyNumber%]
      RunOrActivateAppOrUrl(title, url, 3, true, false)
    }
  }
  Else                             ; Ctrl is not pressed
  {
  	pathDefaultBoard = /secure/RapidBoard.jspa?rapidView=%JiraDefaultRapidKey%&projectKey=%JiraDefaultProjectKey%&sprint=%JiraDefaultSprint%
    url = %JiraUrl%%pathDefaultBoard%
    RunOrActivateAppOrUrl("Agile Board - Jira", url, 3, true, false)
  }
}


;--------------------------------------------------------------------------------------------------
; Run or activate Spotify
;   Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
;   run the shortcut.
;--------------------------------------------------------------------------------------------------
RunOrActivateSpotify()
{
  RunOrActivateAppOrUrl("Spotify Premium", WindowsUserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\My Shortcuts\Spotify.lnk")
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
	
  outlookTitle = i)%UserEmailAddress%\s-\sOutlook
  If Not WinExist(outlookTitle)	
  {
    outlookExe = %WindowsProgramFilesFolder%\Microsoft Office\root\Office16\OUTLOOK.EXE
	  ShellRun(outlookExe)
	  WinWaitActive, outlookTitle,,5
  }
  WinActivate

  If shortcut <>
    SendInput %shortcut%
}	


;--------------------------------------------------------------------------------------------------
; Execute a home automation command
;--------------------------------------------------------------------------------------------------
HomeAutomationCommand(command) 
{
  ; I'd love to get this working asynchronously, so I could pound the key a couple
  ; of times instead of having to wait for each one.

  ; This works. It's synchronous, so don't love it, but at least it does not display a DOS box.
  ;Run, %ComSpec% /c "python c:\users\brian-kummer\Personal\Code\git\home-automation\home_automation.py %command%", "C:\Users\brian-kummer\Personal\Code\git\home-automation", Hide
  Run, %ComSpec% /c "python %MyPersonalFolder%\Code\git\home-automation\home_automation.py %command%", "%MyPersonalFolder%\Code\git\home-automation", Hide


  ; This does not work
  ;ShellRun("C:\Python39\python.exe c:\users\brian-kummer\Personal\Code\git\home-automation\home_automation.py %command%")

  ; Try running python from within Git Bash (skip ha.sh), could add "&" to end of command to run in background- 
  ; this delays, but doesn't work
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" --hide c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% && sleep 10 &",, Hide
  ;Run, %ComSpec% /c ""C:\Program Files\Git\git-bash.exe" c:\users\brian-kummer\Personal\Code\git\home-automation\ha.sh %command% &",, Hide
}


;--------------------------------------------------------------------------------------------------
; Generate a lowercase GUID
;--------------------------------------------------------------------------------------------------
GenerateLowercaseGUID() 
{
  newGUID := CreateGUID()
	StringLower, newGUID, newGUID
  SendInput %newGUID%
}


;--------------------------------------------------------------------------------------------------
; Generate an uppercase GUID
;--------------------------------------------------------------------------------------------------
GenerateUppercaseGUID()
{
  newGUID := CreateGUID()
	StringUpper, newGUID, newGUID
  SendInput %newGUID%
}


;--------------------------------------------------------------------------------------------------
; Switch audio output
;   I originally created this to switch my Jabra headphones between "headphones" and "headset", but
;   this is unnecessary with my Jabra Link.
;--------------------------------------------------------------------------------------------------
;SwitchAudioOutput(audioDevice) 
;{
;  Run, nircmd setdefaultsounddevice %audioDevice%,, Hide
;}