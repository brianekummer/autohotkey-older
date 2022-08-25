/**
 *  Checks for Administrator rights and elevates if needed
 * 
 *  https://www.reddit.com/r/AutoHotkey/comments/fzx6f4/running_script_as_administrator_at_startup/
 */
RunAsAdmin() {
  if not A_IsAdmin {
    Run("*RunAs `"" A_ScriptFullPath "`"")  ; Requires v1.0.92.01+
    ExitApp()
  }
}