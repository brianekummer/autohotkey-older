/*
  Common Functions
*/



InitializeCommonGlobalVariables()
{
global Configuration := {
  WindowsLocalAppDataFolder: EnvGet("LOCALAPPDATA"),
  WindowsProgramFilesX86Folder: EnvGet("PROGRAMFILES(X86)"),
  WindowsProgramFilesFolder: EnvGet("PROGRAMFILES"),
  WindowsUserName: EnvGet("USERNAME"),
  WindowsUserDomain: EnvGet("USERDOMAIN"),
  WindowsUserProfile: EnvGet("USERPROFILE"),
  MyDocumentsFolder: EnvGet("USERPROFILE") "\Documents\",

  ; These come from my Windows environment variables- see "Configure.bat" for details
  MyPersonalFolder: EnvGet("AHK_PERSONAL_FILES"),
  MyPersonalDocumentsFolder: EnvGet("AHK_PERSONAL_FILES") "\Documents\",

  ; These will get populated by the appropriate code later
  IsWorkLaptop: "",
  Home: "",
  Work: ""
}

}



ConnectToPersonalComputer()
{
  ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql
  ;WinWaitActive, ahk_exe parsecd.exe,, 5
  ;If ErrorLevel
  ;{
  ;  MsgBox, WinWait timed out.
  ;  Return
  ;}

  ; TODO- This appears to work if Parsec is not running, but fails if it is already open
  if (!WinExist("ahk_exe parsecd.exe"))
  {
    ;msgbox Parsec is NOT running
    ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=2CONfBq8o5QTpLLAXgsolEDVqBJ
    Run("`"C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk`" peer_id=" Configuration.Work.ParsecPeerId)
    
    ErrorLevel := WinWaitActive("ahk_exe parsecd.exe", , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
    if (ErrorLevel)
    {
      MsgBox("WinWait timed out.")
      return
    }
  }
  else
  {
    ;Msgbox Parsec IS running
  
    ; Is Parsec connected?
    ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
    WinActivate()
  }
  
  WinMaximize()  ; Use the window found by WinExist|WinWaitActive
}


/*
  Send keystrokes to Parsec, optionally activating the window first
*/
SendKeystrokesToPersonalLaptop(keystrokes, activateFirst := True)
{
  if (activateFirst)
  {
    ; Two issues addressed here:
    ;   1. Running D:\Portable Apps\Parsec\parsecd.exe didn't work, so I'm running the shortcut
    ;   2. I could not get RunApp() to work with the parameter I'm passing to parsecd, so I just replicated the
    ;      relevant parts of that function here

    ;Run, "C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql
    ;WinWaitActive, ahk_exe parsecd.exe,, 5
    ;If ErrorLevel
    ;{
    ;  MsgBox, WinWait timed out.
    ;  Return
    ;}

    ; TODO- This appears to work if Parsec is not running, but fails if it is already open
    if (!WinExist("ahk_exe parsecd.exe"))
    {
      MsgBox("Parsec is NOT running")
      Run("`"C:\Users\brian-kummer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Parsec.lnk`" peer_id=26LSLjCqFjpJh97tr7jOy4SF2ql")
      ErrorLevel := WinWaitActive("ahk_exe parsecd.exe", , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
      if (ErrorLevel)
      {
        MsgBox("WinWait timed out.")
        return
      }
    }
    else
    {
      ;Msgbox Parsec IS running
    
      ; Is Parsec connected?
      ; Looks like I need to use FindText to look for the Connect button: https://www.autohotkey.com/boards/viewtopic.php?p=167586#p167586
    
      WinActivate()
    }
    WinMaximize()   ; Use the window found by WinExist|WinWaitActive
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
