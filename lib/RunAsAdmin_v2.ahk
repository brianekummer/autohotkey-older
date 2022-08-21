;---------------------------------------------------------------------------
; To check for Administrator rights then elevate if needed.
;---------------------------------------------------------------------------

;RunAsAdmin() {
;  if (A_IsAdmin = 1)
;    Return 0
;  Loop A_Args.Length
;    params .= A_Space . A_Args[ A_Index ]
;  DllCall("shell32\ShellExecute" ( 1 ? "":"A" ), uint, 0, str, "RunAs", str, ( A_IsCompiled ? A_ScriptFullPath : A_AhkPath ), str, ( A_IsCompiled ? "" : """" . A_ScriptFullPath . """" . A_Space ) params, str, A_WorkingDir, int, 1)
;  ExitApp()
;}

; https://www.reddit.com/r/AutoHotkey/comments/fzx6f4/running_script_as_administrator_at_startup/
RunAsAdmin() {
  if not A_IsAdmin
  {
    Run("*RunAs `"" A_ScriptFullPath "`"")  ; Requires v1.0.92.01+
    ExitApp()
  }
}