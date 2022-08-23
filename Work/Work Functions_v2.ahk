﻿/*
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

  if AmNearWifiNetwork("(kummer)")   ; TODO- move to env var
    HomeAutomationCommand("officelite,officelitetop,officelitemiddle,officelitebottom off")

  DllCall("user32.dll\LockWorkStation")
}


/*

*/
OpenSourceCode(ctrlPressed)
{
  if (ctrlPressed)
    RunOrActivateApp("eventschema", Configuration.Work.SourceSchemaUrl)
  else
    RunOrActivateApp("Overview", Configuration.Work.SourceCodeUrl)
}


/*
  Run or activate Spotify

  Since this is a Microsoft Store app, I needed to add a shortcut to me Start menu so that I can
  run the shortcut. Since the window title changes depending if something is playing or not, so
  I am using the filename.
*/
RunOrActivateSpotify()
{
  RunOrActivateApp("ahk_exe Spotify.exe", Configuration.WindowsUserProfile "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\My Shortcuts\Spotify.lnk")
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
  scriptName := Configuration.MyPersonalFolder "\Code\git\home-automation\home_automation.py"
  workingFolder := Configuration.MyPersonalFolder "\Code\git\home-automation"
  Run A_ComSpec ' /c " "python" "' scriptName '" ' command ' >"C:\Temp\Brian.log" " ', workingFolder, "Hide"      ; TODO- remove logging

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