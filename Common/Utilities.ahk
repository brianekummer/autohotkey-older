/**
 *  Utilities
 * 
 *  The intent is for these to be very generic functions that are not specific
 *  to my needs.
 *  
 *  Notes
 *    - Some of this code may assume "SetTitleMatchMode RegEx" was set
 */


/**
 *  Verify this is running as admin, else point me to this code for tips.
 *   
 *  I've stopped installing AHK and am instead using AHK Portable, so I cannot 
 *  use the old RunAsAdmin() function that I used to use, since (I believe) it
 *  requires that Windows has a program association for the .ahk extension.
 *  So I see two options:
 *    1. Create a Windows shortcut to the AutoHotkey*.exe I'm using and pass
 *       it the name of the script to run:
 *         - "Target" is the exe name and parameters, like this:
 *             "D:\...\AutoHotkey64.exe" /script "D:\...Work.ahk"
 *         - ADDITIONALLY, the shortcut must run AHK as an admin, which is 
 *           achieved by clicking the "Advanced" button and checking "Run as admin"
 *         - HOWEVER, this does not work if AHK is on a removable drive, like a
 *           flash drive, or a SD card
 *    2. Use Windows Task Scheduler to start the script every time I log in.
 *         - Start Task Scheduler
 *         - Action => Create Task (not a Basic task)
 *         - General tab:
 *             Select "Run only when user is logged in"
 *         - Triggers tab:
 *             At log on of ...\Brian-Kummer
 *         - Actions tab:  (quote it exactly as shown below)
 *             Start a program
 *               Program/script: "D:\Portable Apps\AHK v2\AutoHotkey64.exe"
 *               Add arguments:  /script "D:\Personal\Code\git\autohotkey\Work.ahk"
 *               Start in:       D:\Personal\Code\git\autohotkey
 *           If the script doesn't start the next time I log in, then look in the 
 *           event log for details:  
 *             Applications and Services Logs => Microsoft => Windows => TaskScheduler => Operational
 */
VerifyRunningAsAdmin() {
  if (! A_IsAdmin) {
    MsgBox("This script must be run as administrator. See comments in function VerifyRunningAsAdmin() for tips on how to accomplish this.", "Must Run as Admin", "OK Iconx")
    ExitApp()
  }
}


/**
 *  Run or activate an app or url
 * 
 *  There are a large number of options, all are defaulted to what I most commonly use.
 *  Overrides are provided for other commonly needed scenarios.
 * 
 *  My original code used WinWaitActive() and then WinMaximize(), but sometimes Windows
 *  wouldn't set focus to the app. This post from Lexikos (from 2013!) suggested using 
 *  WinWait() and WinActivate(), because WinActivate() is very aggressive. So far, this
 *  has worked very well for me. 
 *    https://www.autohotkey.com/boards/viewtopic.php?style=17&t=93937&p=416313#post_content416637
 * 
 *  @param winTitle         Title of the window to activate, or to find once the app has started
 *  @param whatToRun        The exe/url to rul
 *  @param maximizeWindow   Should it be maximized? True|False
 *  @param asAdminUser      Should it be run as administrator? True|False 
 *  @param timeToWait       When running the app/url, how long to wait (seconds)?
 *  @param runEvenIfOpen    Run the app even if it's already open? True|False
 */
RunOrActivateApp(winTitle, whatToRun, maximizeWindow := True, asAdminUser := False, timeToWait := 10, runEvenIfOpen := False) {
  if (!WinExist(winTitle) || runEvenIfOpen) {
    ; THE BEST WAY TO RUN THIS IN A SEPARATE THREAD is to break the contents of this IF block
    ; into a separate script, since that's the only code that needs split out to be run as a 
    ; separate process. 
    ;
    ; This prevents me from needing to make any changes to any code that calls this function.
    ;
    ; IS IT WORTH WRAPPING THIS IN A SetTimer ?? MAYBE??? CAN TRY IT IN HERE AND SEE
    Run('"' . A_AHKPATH . '" Common\RunApp.ahk "' . winTitle . '" "' . whatToRun . '" ' . maximizeWindow . ' ' . asAdminUser . ' ' . timeToWait)
  } else {
    WinActivate(winTitle)

    if (maximizeWindow) {
      WinMaximize(winTitle)
    }
  }

  ; TODO- Is this a problem?
  CommonReturn()
}

/***** Run the app as admin user *****/
RunOrActivateAppAsAdmin(winTitle, whatToRun, maximizeWindow := True, timeToWait := 10) {
  RunOrActivateApp(winTitle, whatToRun, maximizeWindow, True, timeToWait)
}

/***** Always run the app/url, even if it's already open *****/
AlwaysRunApp(winTitle, whatToRun, maximizeWindow := True, timeToWait := 10) {
  RunOrActivateApp(winTitle, whatToRun, maximizeWindow,, timeToWait, True)
}


/**
 *  Activate a window and send it keystrokes
 * 
 *  @param windowId              The window id of the window to activate and send keystrokes to
 *  @param keystroke             The keystrokes to send
 *  @return 
 */
ActivateWindowByIdAndSendKeystroke(windowId, keystroke) {
  if (windowId) {
    WinActivate("ahk_id " . windowId)
    Sleep(150)
    SendInput(keystroke)
    return True
  } else {
    return False
  }

  CommonReturn()
}


/**
 *  Get the text that is currently selected by using the clipboard, while preserving the clipboard's 
 *  current contents.
 *  
 *  @return                      The text that was selected when this function was called
 */
GetSelectedTextUsingClipboard() {
  selectedText := ""
  ClipSaved := A_Clipboard  
  A_Clipboard := ""
  SendInput("^c")
  Errorlevel := !ClipWait(1)
  selectedText := A_Clipboard
  Sleep(250)                 ; This seems to get rid of weird behavior
  A_Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  ClipSaved := ""			       ; Free the memory in case the clipboard was very large
  
  return selectedText
}


/**
 *  Runs a DOS command and returns its output
 *    - This is very simple code, but it shows the command box as it runs
 *    - From https://autohotkey.com/docs/commands/Run.htm
 * 
 *  @param command               The command to run
 *  @return                      The standard output from running command
 */
RunWaitOne(command) {
  shell := ComObject("WScript.Shell")           ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
  exec := shell.Exec(A_ComSpec . " /C " . command)  ; Execute a single command via cmd.exe
  
  return exec.StdOut.ReadAll()                  ; Read and return the command's output 
}


/**
 *  Runs a DOS command and returns the output
 *    - No console is visible while this runs
 *    - The output is redirected to the clipboard, where this script can get it and return
 *
 *  @param command               The command to run
 *  @return                      The standard output from running command
 */
RunWaitHidden(command) {
	Sleep(250)                     ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  clipSaved := ClipboardAll()	   ; Save the entire clipboard
  A_Clipboard := ""

	RunWait(command . " | clip", , "hide")
  output := A_Clipboard
	
	Sleep(250)                     ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  A_Clipboard := clipSaved       ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  clipSaved := ""			           ; Free the memory in case the clipboard was very large

  CommonReturn()

	return output
}


/**
 *  ShellRun by Lexikos
 *
 * 	https://autohotkey.com/board/topic/72812-run-as-standard-limited-user/page-2#entry522235
 *  license: http://creativecommons.org/publicdomain/zero/1.0/
 *
 *  Credit for explaining this method goes to BrandonLive:
 *  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
 *
 *  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
 *  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
 * 
 *  When I upgraded AHK to v2, this no longer worked for me, so I found a modified version:
 *  https://www.autohotkey.com/boards/viewtopic.php?t=78190
 *
 *  @param prms*                 The parameters to pass to the shell
 */
ShellRun(prms*) {
  shellWindows := ComObject("Shell.Application").Windows
  desktop := shellWindows.FindWindowSW(0, 0, 8, 0, 1) ; SWC_DESKTOP, SWFO_NEEDDISPATCH
   
  ; Retrieve top-level browser object
  tlb := ComObjQuery(desktop,
      "{4C96BE40-915C-11CF-99D3-00AA004AE837}", ; SID_STopLevelBrowser
      "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    
  ; IShellBrowser.QueryActiveShellView -> IShellView
  ComCall(15, tlb, "ptr*", sv := ComValue(13, 0)) ; VT_UNKNOWN
    
  ; Define IID_IDispatch
  NumPut("int64", 0x20400, "int64", 0x46000000000000C0, IID_IDispatch := Buffer(16))
   
  ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
  ComCall(15, sv, "uint", 0, "ptr", IID_IDispatch, "ptr*", sfvd := ComValue(9, 0)) ; VT_DISPATCH
   
  ; Get Shell object
  shell := sfvd.Application
   
  ; IShellDispatch2.ShellExecute
  shell.ShellExecute(prms*)

  CommonReturn()
}


/**
 *  Am I near one of the specified networks?
 *
 *  @param wifiNetworks          List of wifi network names as a regex string, such as "(mycompany|mycobyod)" 
 *  @return                      True if am near any of the wifi networks, else False
 */
AmNearWifiNetwork(wifiNetworks) {
  ;msgbox "Checking if near wifi - " . wifiNetworks
  nearWifiNetwork := False
  wifiNetworksPattern := "i)" . wifiNetworks

	allNetworks := RunWaitHidden(A_ComSpec . " /c netsh wlan show networks")
  ;msgbox "Found these networks: " . allNetworks

  pos := 1
  match := [""]
  while !nearWifiNetwork && pos := RegExMatch(allNetworks, "i)\Rssid.+?:\s(\V+)\R", &match, pos+StrLen(match[1])) {
    ; match is the line like "SSID x : network_ssid", so parse out the network's SSID
    networkSSID := RegExReplace(match[1], "\R.*?:\s(\V+)\R", "$1")

    if (RegExMatch(networkSSID, wifiNetworksPattern)) {
      nearWifiNetwork := True
    }
  }

  ;msgbox "Returning " . nearWifiNetwork
	return nearWifiNetwork
}	


/**
 *  Am I connected to the internet?
 *    https://www.autohotkey.com/board/topic/80587-how-to-find-internet-connection-status/ 
 * 
 *  @return                      Returns 1 if connected to internet, else returns 0
 */
AmConnectedToInternet(flag := 0x40) { 
  return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0) 
}


/**
 *  Functions to URL encode/decode a string
 *  https://www.autohotkey.com/boards/viewtopic.php?t=86419
 * 
 *  @param str                   The string to encode/decode
 *  @return                      The URL-encoded/decoded string
 */
UriEncode(str)
{
  ( obj := ComObject("HTMLfile") ).write('<p>/</p><script>document.getElementsByTagName("p")[0].innerHTML=encodeURI("' . str . '");</script>')
  return obj.getElementsByTagName("p")[0].innerHTML
}
UriDecode(str)
{
  ( obj := ComObject("HTMLfile") ).write('<p>/</p><script>document.getElementsByTagName("p")[0].innerHTML=decodeURI("' . str . '");</script>')
  return obj.getElementsByTagName("p")[0].innerHTML
}


/**
 *  Locks my workstation
 */
LockWorkstation() {
  DllCall("user32.dll\LockWorkStation")

  CommonReturn()
}


/**
 *  Convert date/time to Unix timestamp
 * 
 *  @param dateTimeInUtc         The date/time to convert, in UTC               
 *  @return                      The Unix date/time (epoch)
 */
ConvertDateTimeToUnixTimestamp(dateTimeInUtc) {
  return DateDiff(dateTimeInUtc, 19700101000000, 'seconds')
}


/**
 *  Put the laptop to sleep
 */
PutLaptopToSleep() {
  DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
}