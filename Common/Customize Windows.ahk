﻿/**
 *  Customize Windows
 *
 *  Improvements to Windows, including adding new features
 * 
 *  Features
 *    - Extra mouse functionality
 *    - Media controls using CapsLock/Hyper and the mouse
 */


/**
 *  Minimize the active window. This overrides the existing Windows hotkey that:
 *    - First time you use it, un-maximizes (restores) the window
 *    - Second second time you use it, it minimizes the window
 */
#down:: WinMinimize("A")


/**
 *  CapsLock processing. Double-tap CapsLock to toggle it.
 *
 *  https://www.howtogeek.com/446418/how-to-use-caps-lock-as-a-modifier-key-on-windows/
 *
 */
/*
CapsLock:: {
  KeyWait, CapsLock                                                   ; Wait forever until Capslock is released.
  KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
  if ((ErrorLevel = 0) && (A_PriorKey = "CapsLock")) {                ; Is a double tap on CapsLock?
    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"    ; Toggle the state of CapsLock LED
  }
  return
}
*/
; I don't want the above, so I commented out the above and enable the return below
CapsLock:: return


/**
 *  Extra mouse buttons
 *    - I have a Logitech M510 5 button mouse
 *    - XButton1 (front button) minimizes the current window
 *    - XButton2 (rear button) depending on the active window, closes the active TAB/WINDOW, or minimizes or closes the 
 *      active APPLICATION.
 *
 *  This is based on the name of app/process, NOT the window title, or else it would minimize a browser with a tab whose
 *  title is "How to Use Slack".  Also, Microsoft Edge browser is more complex than a single process, so detecting it is
 *  more complex.
 */
#HotIf !WinActive("ahk_exe parsecd.exe", )
  xbutton1:: {
    WinMinimize("A")
  }

  xbutton2:: {
    processName := WinGetProcessName("A")
    SplitPath(processName, , , , &processNameNoExtension)

    if (RegExMatch(processNameNoExtension, "i)skype|outlook|wmplayer|slack|typora|teams") 
    || WinActive("iHeartRadio ahk_exe i)ApplicationFrameHost.exe")) {
	    WinMinimize("A")      ; Do not want to close these apps
    
    } else if (RegExMatch(processNameNoExtension, "i)chrome|iexplore|firefox|ssms|devenv|eclipse|winmergeu|robo3t|code|idea64|studio 3t") 
    || WinActive("ahk_exe msedge.exe")) {
      SendInput("^{f4}")    ; Close a WINDOW/TAB/DOCUMENT

    } else if (RegExMatch(processNameNoExtension, "i)notepad++")) {
      SendInput("^{w}")     ; Close a WINDOW using Ctrl-w
    
    } else {
      SendInput("!{f4}")    ; Close the APP
    }
  }
#HotIf !WinActive(, )


/**
 *  Mouse media controls
 *    ✦ mouse wheel        Volume down/up
 *    ✦ LButton            Play/pause
 *    ✦ RButton            Music app (Spotify)
 *    ✦ XButton1           Previous track
 *    ✦ XButton2           Next track
 *
 *  It seems that these are the actions that usually mess up my CapLock key.
 *  I cannot figure out how to PREVENT it, so instead I'll fix it immediately
 *  AFTER it happens by calling FixBrokenCapsLock().
 */
#HotIf Configuration.IsWorkLaptop
  CapsLock & wheelup::     SendMediaKey("{Blind}{Volume_Up 1}")
  CapsLock & wheeldown::   SendMediaKey("{Blind}{Volume_Down 1}")
  
  CapsLock & LButton::     SendMediaKey("{Blind}{Media_Play_Pause}")
  CapsLock & RButton::     RunOrActivateSpotify()
  CapsLock & XButton1::    SendMediaKey("{Blind}{Media_Prev}")
  CapsLock & XButton2::    SendMediaKey("{Blind}{Media_Next}")
#HotIf

SendMediaKey(mediaKey) {
  SendInput(mediaKey)
  FixCapsLockIfBroken()
}


/**
 *  Fix the CapsLock key if it is now broken
 *  
 *  SetCapsLockState("AlwaysOff")  ;
 *    - Disables the CapsLock LED on my keyboard
 *    - OFTEN fixes my problem, but not always
 * 
 *  Reload
 *    - I don't like this because it loses static variables like those used by ConvertCase
 *    - It ALWAYS fixes my problem
 *    - BUT, you cannot do it to exit every function or you end up with DOZENS of copies
 *      of AHK running, and the system comes to a crawl.
 * 
 *  Several options did not work for me
 *    - Send "{Blind}{CapsLock up}"
 *    - Send "{CapsLock up}"
 * 
 *  Does checking key state of CapsLock accurately determine if we need to do this? 
 *  No, sometimes I still have problems.
 */
FixCapsLockIfBroken() {
  ; This looks like the best I can do :(
  if (GetKeyState("CapsLock")) {   ; Does it matter if I use "P", "T", or no 2nd param?
  ;  SoundBeep  
     SetCapsLockState("AlwaysOff")  ; Disable the CapsLock LED on my keyboard
  }
}