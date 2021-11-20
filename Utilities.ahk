;--------------------------------------------------------------------------------------------------
; Utilities
;--------------------------------------------------------------------------------------------------
SetTitleMatchMode RegEx       ; Make windowing commands use regex






RunAppOrUrl(appTitle, whatToRun, timeToWait := 3, maximize := False)
{
  Run, %whatToRun%
  WinWaitActive, %appTitle%,, %timeToWait%

  If maximize
  {
    WinMaximize, A
  }
}



RunOrActivateAppOrUrl(appTitle, whatToRun, timeToWait := 3, maximize := False)
{
  If Not WinExist(appTitle)
  {
    Run, %whatToRun%
	  WinWaitActive, %appTitle%,, %timeToWait%
  }
  Else 
  {
    WinActivate, %appTitle%
  }

  If maximize
  {
    WinMaximize, A
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