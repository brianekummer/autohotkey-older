;--------------------------------------------------------------------------------------------------
; Utilities
;
; Some of this code may assume "SetTitleMatchMode RegEx" was set
;--------------------------------------------------------------------------------------------------






RunAppOrUrl(appTitle, whatToRun, timeToWait := 3, maximize := False)
{
  Run, %whatToRun%
  WinWaitActive, %appTitle%,, %timeToWait%

  If maximize
  {
    WinMaximize
  }
}



RunOrActivateAppOrUrl(appTitle, whatToRun, timeToWait := 3, maximize := False, asAdminUser := true)
{
  If Not WinExist(appTitle)
  {
    If asAdminUser
    {
      Run, %whatToRun%
    }
    Else
    {
  	  ShellRun(whatToRun)
    }

	  WinWaitActive, %appTitle%,, %timeToWait%
  }
  Else 
  {
    WinActivate
  }

  If maximize
  {
    WinMaximize
  }
}


ActivateWindowByIdAndSendKeystroke(windowId, keystroke) {
  If windowId
  {
    WinActivate, ahk_id %windowId%
    Sleep, 150
    SendInput, %keystroke%
    Return True
  }
  else
  {
    Return False
  }
}




;--------------------------------------------------------------------------------------------------
; Get the text that is currently selected by using the clipboard, while preserving the clipboard's 
; current contents.
;--------------------------------------------------------------------------------------------------
GetSelectedTextUsingClipboard()
{
  selectedText =
  ClipSaved := Clipboard  
  Clipboard = 
  SendInput ^c
  ClipWait, 1
  selectedText := Clipboard
  Sleep, 250                   ; This seems to get rid of weird behavior
  Clipboard := ClipSaved       ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  ClipSaved =			       ; Free the memory in case the clipboard was very large
  
  Return selectedText
}


;---------------------------------------------------------------------------------------------------------------------
; Run a DOS command. This code taken from AutoHotKey website: https://autohotkey.com/docs/commands/Run.htm
;---------------------------------------------------------------------------------------------------------------------
RunWaitOne(command)
{
  shell := ComObjCreate("WScript.Shell")      ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
  exec := shell.Exec(ComSpec " /C " command)  ; Execute a single command via cmd.exe
  Return exec.StdOut.ReadAll()                ; Read and return the command's output 
}


;--------------------------------------------------------------------------------------------------
;  ShellRun by Lexikos
;	   https://autohotkey.com/board/topic/72812-run-as-standard-limited-user/page-2#entry522235
;    requires: AutoHotkey_L
;    license: http://creativecommons.org/publicdomain/zero/1.0/
;
;  Credit for explaining this method goes to BrandonLive:
;  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
;
;  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
;  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
;--------------------------------------------------------------------------------------------------
ShellRun(prms*)
{
    shellWindows := ComObjCreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")

    desktop := shellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                

    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
        , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
        {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")

            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
                , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)

            ; Get Shell object.
            shell := ComObj(9,pdisp,1).Application

            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(prms*)

            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
}


CreateGUID()
{
  newGUID := ComObjCreate("Scriptlet.TypeLib").Guid
	newGUID := StrReplace(NewGUID, "{")
	newGUID := StrReplace(NewGUID, "}")
  Return newGUID
}







ConnectToPersonalComputer()
{
  ; Two issues addressed here:
  ;   1. Running D:\Portable Apps\Parsec\parsecd.exe didn't work, so I'm running the shortcut
  ;   2. I could not get RunOrActivateAppOrUrl() to work with the parameter I'm passing to parsecd, so I just replicated the
  ;      relevant parts of that function here

  ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql
  ;WinWaitActive, ahk_exe parsecd.exe,, 5
  ;If ErrorLevel
  ;{
  ;  MsgBox, WinWait timed out.
  ;  Return
  ;}

  ; TODO- This appears to work if Parsec is not running, but fails if it is already open
  If Not WinExist("ahk_exe parsecd.exe")
  {
    ;msgbox Parsec is NOT running
    ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=2CONfBq8o5QTpLLAXgsolEDVqBJ
    Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=%ParsecPeerId%
    
    WinWaitActive, ahk_exe parsecd.exe,, 5
    If ErrorLevel
    {
      MsgBox, WinWait timed out.
      Return
    }
  }
  Else
  {
    ;Msgbox Parsec IS running
  
    ; Is Parsec connected?
    ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
    WinActivate
  }
  
  WinMaximize  ; Use the window found by WinExist|WinWaitActive
}


;--------------------------------------------------------------------------------------------------
; Send keystrokes to Parsec, optionally activating the window first
;--------------------------------------------------------------------------------------------------
SendKeystrokesToPersonalLaptop(keystrokes, activateFirst := true)
{
  If activateFirst
  {
    ; Two issues addressed here:
    ;   1. Running D:\Portable Apps\Parsec\parsecd.exe didn't work, so I'm running the shortcut
    ;   2. I could not get RunOrActivateAppOrUrl() to work with the parameter I'm passing to parsecd, so I just replicated the
    ;      relevant parts of that function here


    ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql
    ;WinWaitActive, ahk_exe parsecd.exe,, 5
    ;If ErrorLevel
    ;{
    ;  MsgBox, WinWait timed out.
    ;  Return
    ;}


    ; TODO- This appears to work if Parsec is not running, but fails if it is already open
    If Not WinExist("ahk_exe parsecd.exe")
    {
      msgbox Parsec is NOT running
      Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql
      WinWaitActive, ahk_exe parsecd.exe,, 5
      If ErrorLevel
      {
        MsgBox, WinWait timed out.
        Return
      }
    }
    Else
    {
      ;Msgbox Parsec IS running
    
      ; Is Parsec connected?
      ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
      WinActivate
    }
    WinMaximize   ; Use the window found by WinExist|WinWaitActive
  }
  
  ; Wait for "brianekummer#8283717" or "Connect to your computers or a friend's computer in low latency desktop mode" to disappear
  ; Also beware having to log into computer w/pin code
  ;   - I changed NUC to be same pic all the time- find "I forgot my pin"
  ;Sleep 500    ; If Parsec is connected, this is enough time. If not connected, it is not
  ;WaitForParsecToConnect() 

  ;ControlSend,, %keystrokes%, ahk_exe parsecd.exe
  
  ; OLD STUFF I DON'T NEED
  ;OLD- ControlSend,, %keystrokes%, Parsec
  ;SendInput {Blind}%keystrokes%
}



;---------------------------------------------------------------------------------------------------------------------
; Run a DOS command
;---------------------------------------------------------------------------------------------------------------------
RunWaitHidden(cmd)
{
	Sleep, 250                ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  clipSaved := ClipboardAll	; Save the entire clipboard
  Clipboard = 

	Runwait %cmd% | clip,,hide
  output := Clipboard
	
	Sleep, 250                ; KUMMER TRYING THIS TO PREVENT ERRORS READING FROM CLIPBOARD
  Clipboard := clipSaved	  ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
  clipSaved =			          ; Free the memory in case the clipboard was very large

	Return output
}


AmNearWifiNetwork(wifiNetworks)
; wifiNetworks is regex like "(mycompany|mycobyod)"
{
  ;msgbox Looking for networks %wifiNetworks%
  nearWifiNetwork := False

	cmd = %comspec% /c netsh wlan show networks
	allNetworks := RunWaitHidden(cmd)
	
  wifiNetworksPattern = i)%wifiNetworks%
	pos=1
  While pos := RegExMatch(allNetworks, "i)\Rssid.+?:\s(.*)\R", oneNetwork, pos+StrLen(oneNetwork)) 
	{
	  ; oneNetwork is the line like "SSID x : network_ssid", so parse out the network's SSID
	  networkSSID := RegExReplace(oneNetwork, "\R.*?:\s(\V+)\R", "$1")
    ;msgbox Checking if %networkSSID% is work or not

	  If RegExMatch(networkSSID, wifiNetworksPattern)
	    nearWifiNetwork := True
  }	

  ;msgbox "Result is %nearWifiNetwork%"
	Return %nearWifiNetwork%
}	