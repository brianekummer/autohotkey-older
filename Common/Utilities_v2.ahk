/*
  Utilities

  Some of this code may assume "SetTitleMatchMode RegEx" was set
  Very generic code
*/


RunOrActivateAppAsAdmin(appTitle, whatToRun, maximizeWindow := True, timeToWait := 10)
{
  RunOrActivateApp(appTitle, whatToRun, maximizeWindow, True, timeToWait)
}

RunOrActivateApp(appTitle, whatToRun, maximizeWindow := True, asAdminUser := False, timeToWait := 10)
{
  if (!WinExist(appTitle))
  {
    if asAdminUser
      Run(whatToRun)
    else
  	  ShellRun(whatToRun)
	  ErrorLevel := WinWaitActive(appTitle, , timeToWait)
  }
  else 
  {
    WinActivate()
  }

  WinShow()
  if (maximizeWindow)
    WinMaximize()
}


/*

*/
ActivateWindowByIdAndSendKeystroke(windowId, keystroke) {
  if (windowId)
  {
    WinActivate("ahk_id " windowId)
    Sleep(150)
    SendInput(keystroke)
    return True
  }
  else
  {
    return False
  }
}


/*
  Get the text that is currently selected by using the A_Clipboard, while preserving the A_Clipboard's 
  current contents.
*/
GetSelectedTextUsingClipboard()
{
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


/*
  Run a DOS command. This code taken from AutoHotkey website: https://autohotkey.com/docs/commands/Run.htm
*/
RunWaitOne(command)
{
  shell := ComObject("WScript.Shell")           ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
  exec := shell.Exec(A_ComSpec " /C " command)  ; Execute a single command via cmd.exe
  return exec.StdOut.ReadAll()                  ; Read and return the command's output 
}


/*
  ShellRun by Lexikos

	https://autohotkey.com/board/topic/72812-run-as-standard-limited-user/page-2#entry522235
  requires: AutoHotkey_L
  license: http://creativecommons.org/publicdomain/zero/1.0/

  Credit for explaining this method goes to BrandonLive:
  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/

  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
*/
; ShellRun(prms*)
; {
;     shellWindows := ComObject("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")

;     desktop := shellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                

;     ; Retrieve top-level browser object.
;     if ptlb := ComObjQuery(desktop
;         , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
;         , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
;     {
;         ; IShellBrowser.QueryActiveShellView -> IShellView
;         if DllCall(NumGet(NumGet(ptlb+0, "UPtr")+15*A_PtrSize, "UPtr"), "ptr", ptlb, "ptr*", &psv:=0) = 0
;         {
;             ; Define IID_IDispatch.
;             VarSetStrCapacity(&IID_IDispatch, 16) ; V1toV2: if 'IID_IDispatch' is NOT a UTF-16 string, use 'IID_IDispatch := Buffer(16)'
;             NumPut("int64", 0x46000000000000C0, IID_IDispatch)

;             ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
;             DllCall(NumGet(NumGet(psv+0, "UPtr")+15*A_PtrSize, "UPtr"), "ptr", psv, "uint", 0, "ptr", IID_IDispatch, "ptr*", &pdisp:=0)

;             ; Get Shell object.
;             shell := ComObj(9,pdisp,1).Application

;             ; IShellDispatch2.ShellExecute
;             shell.ShellExecute(prms*)

;             ObjRelease(psv)
;         }
;         ObjRelease(ptlb)
;     }
; }

; new version from https://www.autohotkey.com/boards/viewtopic.php?t=78190
ShellRun(prms*)
{
  shellWindows := ComObject("Shell.Application").Windows
  desktop := shellWindows.FindWindowSW(0, 0, 8, 0, 1) ; SWC_DESKTOP, SWFO_NEEDDISPATCH
   
  ; Retrieve top-level browser object.
  tlb := ComObjQuery(desktop,
      "{4C96BE40-915C-11CF-99D3-00AA004AE837}", ; SID_STopLevelBrowser
      "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    
  ; IShellBrowser.QueryActiveShellView -> IShellView
  ComCall(15, tlb, "ptr*", sv := ComValue(13, 0)) ; VT_UNKNOWN
    
  ; Define IID_IDispatch.
  NumPut("int64", 0x20400, "int64", 0x46000000000000C0, IID_IDispatch := Buffer(16))
   
  ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
  ComCall(15, sv, "uint", 0, "ptr", IID_IDispatch, "ptr*", sfvd := ComValue(9, 0)) ; VT_DISPATCH
   
  ; Get Shell object.
  shell := sfvd.Application
   
  ; IShellDispatch2.ShellExecute
  shell.ShellExecute(prms*)
}


/*
  Two issues addressed here:
    1. Running D:\Portable Apps\Parsec\parsecd.exe didn't work, so I'm running the shortcut
    2. I could not get RunOrActivateApp() to work with the parameter I'm passing to parsecd, so I just replicated the
       relevant parts of that function here

*/


/*
  Run a DOS command
*/
RunWaitHidden(cmd)
{
	Sleep(250)                  ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  clipSaved := ClipboardAll()	; Save the entire clipboard
  A_Clipboard := ""

	RunWait(cmd " | clip", , "hide")
  output := A_Clipboard
	
	Sleep(250)                ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  A_Clipboard := clipSaved  ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  clipSaved := ""			      ; Free the memory in case the clipboard was very large

	return output
}


/*
  wifiNetworks is regex like "(mycompany|mycobyod)"
*/
AmNearWifiNetwork(wifiNetworks)
{
  nearWifiNetwork := False
  wifiNetworksPattern := "i)" wifiNetworks

	allNetworks := RunWaitHidden(A_ComSpec " /c netsh wlan show networks")

  pos := 1
  match := [""]
  While !nearWifiNetwork && pos := RegExMatch(allNetworks, "i)\Rssid.+?:\s(\V+)\R", &match, pos+StrLen(match[1]))
  {
    ; match is the line like "SSID x : network_ssid", so parse out the network's SSID
    networkSSID := RegExReplace(match[1], "\R.*?:\s(\V+)\R", "$1")

    if (RegExMatch(networkSSID, wifiNetworksPattern))
      nearWifiNetwork := True
  }

	return nearWifiNetwork
}	


/*
  https://www.autohotkey.com/board/topic/80587-how-to-find-internet-connection-status/
*/
AmConnectedToInternet(flag := 0x40) { 
  return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0) 
}