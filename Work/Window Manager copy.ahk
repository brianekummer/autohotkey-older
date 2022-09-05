/**
   Goal is to emulate windows manager from hammerspoon
     - easily, using only keyboard, tile a window between 1/3, 1/2, 2/3, full screen
     - anything else is a bonus
         - maybe consistent keys to max/restore windows, move to diff monitors

   FancyZones can let you do 3 columns, use
     # <> to move between the 3 zones
     # !^ <> to make window take up more zones
     BUT can't easily do 1/2


   Think my solution will be
     - Use H <> to  toggle between sizes 1/3, 1/2, 2/3, full
     - Use native windows Snap # <> to move, and Windows #! <> to move window between monitors
         - MIGHT figure better keys to be consistent in moving, maybe add Ctrl or <<shift>>

   STEP #1
     - Add 1/3, 1/2, 2/3
   STEP #2
     - Other options, like moving windows between monitors, portrait monitors, etc


   Hammerspoon code i used on Mac:
     https://github.com/brianekummer/hammerspoon/blob/master/Spoons/MiroWindowsManager.spoon/init.lua
     https://github.com/brianekummer/hammerspoon/blob/master/Spoons/MiroWindowsManager.spoon/docs.json


    Considerations
       - multiple monitors
           - anything special for portrait monitor- does it automatically do vertical? Or do I just use FancyZones for that?
       - monitors at home vs work- act differently?



    Does anything already exist that I can use/modify?
      - These are all very coimplicated1
        - https://github.com/benoit1906/SnapZones
        - https://github.com/fuhsjr00/bug.n
        - https://github.com/LGUG2Z/komorebi

    This looks like something I can build upon
      - https://www.autohotkey.com/board/topic/79338-simple-window-positionsize-manager-similar-to-win-7-snap/

 */



      ; https://www.autohotkey.com/board/topic/79338-simple-window-positionsize-manager-similar-to-win-7-snap/
#SingleInstance force ; Allow only one instance of this script to be running.
; Restart script to load modifications automatically.
#NoTrayIcon
#NoEnv
#MaxMem 1
#KeyHistory 0
SetWinDelay 10
SetKeyDelay 0

; globals for current screen area
screenX := 0
screenY := 0
screenW := 0
screenH := 0
screenA := 0


; ##############################################################################
; ########## Get Working Area of Screen Accounting for Taskbar        ##########
; ##############################################################################
; Function:  getWorkArea
;              sets globals screenX/Y and screenW/H, accounting for user
;              resolution changes, the taskbar position, and also whether
;              taskbar autohide is turned on.
;              NOTE:  This must be used each time screen area is needed as
;                    autohide changes the taskbar location constantly.
getWorkArea() {
  global screenX, screenY, screenW, screenH, screenA

  ; have to do this each time to account for resolution changes
  SysGet,mArea,Monitor
  screenX := mAreaLeft
  screenY := mAreaTop
  screenW := mAreaRight - mAreaLeft
  screenH := mAreaBottom - mAreaTop
  screenA := (mAreaRight - mAreaLeft) / (mAreaBottom - mAreaTop)

  ; have to do this each time to account for taskbar autohide
  WinGetPos,taskbarX,taskbarY,taskbarW,taskbarH,ahk_class Shell_TrayWnd

  if (taskbarW = mAreaRight-mAreaLeft)
  {
    ; taskbar is top or bottom of screen
    screenX := mAreaLeft
    screenW := mAreaRight - mAreaLeft
    if (taskbarY <= 0)
    {
      ; taskbar at top
      screenY := taskbarY + taskbarH
      screenH := mAreaBottom - taskbarY - taskbarH
    }
    else
    {
      ; taskbar at bottom
      screenY := 0
      screenH := taskbarY
    }
  }
  else
  {
    ; taskbar is on a side of the screen
    ;                        ? taskbar at left         : taskbar at right
    screenY := mAreaTop
    screenH := mAreaBottom - mAreaTop
    if (taskbarX <= 0)
    {
      ; taskbar at left
      screenX := taskbarX + taskbarW
      screenW := mAreaRight - taskbarX - taskbarW
    }
    else
    {
      ; taskbar at right
      screenX := 0
      screenW := taskbarX
    }
  }
  screenA := screenW / screenH
}


; ##############################################################################
; ########## Window State Keys                                        ##########
; ##############################################################################

; Win-Home :: maximize/restore current window
#Home::
  WinGet,state,MinMax,A
  if (state)
  {
    WinRestore,A
  } else {
    WinMaximize,A
  }
  return


; Win-End :: minimize the current window
#End::
  WinGetTitle,activeWin,A
  WinGet,activeWinID,ID,A

  ; minimize the window
  WinMinimize,ahk_id %activeWinID%
  return




; ##############################################################################
; ########## Window Position/Size Keys                                ##########
; ##############################################################################

; Win-Left :: move current window to 2/3 or 1/2 or 1/3 of screen width or left-edge, wrap back to 2/3
; (for non-widescreen monitors, that is aspect ratio <= 4/3, ignore the 1/3 and 2/3 positions)
#Left::
  WinGet,activeWinID,ID,A
  WinGetPos,X,Y,W,,ahk_id %activeWinID%
  getWorkArea()
  X1 := screenX + round(screenW / 3)
  X2 := screenX + round(screenW / 2)
  X3 := screenX + round(screenW * 2 / 3)
  if (screenA > 1.334 and X > X3)
    WinMove,ahk_id %activeWinID%,,X3,Y
  else if (X > X2)
    WinMove,ahk_id %activeWinID%,,X2,Y
  else if (screenA > 1.334 and X > X1)
    WinMove,ahk_id %activeWinID%,,X1,Y
  else if (X > screenX)
    WinMove,ahk_id %activeWinID%,,screenX,Y
  else
    WinMove,ahk_id %activeWinID%,,(screenA > 1.334 ? X3 : X2),Y

  WinGetPos,X,Y,W,H,ahk_id %activeWinID%
  if (X + W > screenX + screenW)
    WinMove,ahk_id %activeWinID%,,X,Y,(screenX + screenW - X),H
  return


; Win-Up :: move current window to 1/2 of screen height or top-edge, wrap back to 1/2
#Up::
  WinGet,activeWinID,ID,A
  WinGetPos,X,Y,W,H,ahk_id %activeWinID%
  getWorkArea()
  Y1 := screenY + round(screenH / 2)
  if (Y > Y1)
    WinMove,ahk_id %activeWinID%,,X,Y1
  else if (Y > screenY)
    WinMove,ahk_id %activeWinID%,,X,screenY
  else
    WinMove,ahk_id %activeWinID%,,X,Y1

  WinGetPos,X,Y,W,H,ahk_id %activeWinID%
  if (Y + H > screenY + screenH)
    WinMove,ahk_id %activeWinID%,,X,Y,W,(screenY + screenH - Y)
  return


; Win-Right :: resize current window width to one of 1/3 or 1/2 or 2/3 or full screen width, without moving upper-left corner
; (for non-widescreen monitors, that is aspect ratio <= 4/3, ignore the 1/3 and 2/3 positions)
#Right::
  WinGet,activeWinID,ID,A
  WinGetPos,X,Y,CW,CH,ahk_id %activeWinID%
  getWorkArea()
  X1 := screenX + round(screenW / 3)
  X2 := screenX + round(screenW / 2)
  X3 := screenX + round(screenW * 2 / 3)
  RX := X + CW
  if (screenA > 1.334 and RX < X1)
    WinMove,ahk_id %activeWinID%,,X,Y,(X1-X),CH
  else if (RX < X2)
    WinMove,ahk_id %activeWinID%,,X,Y,(X2-X),CH
  else if (screenA > 1.334 and RX < X3)
    WinMove,ahk_id %activeWinID%,,X,Y,(X3-X),CH
  else if (RX < screenX + screenW)
    WinMove,ahk_id %activeWinID%,,X,Y,(screenX + screenW - X),CH
  else
    if (screenA > 1.334 and X < X1)
      WinMove,ahk_id %activeWinID%,,X,Y,(X1-X),CH
    else if (X < X2)
      WinMove,ahk_id %activeWinID%,,X,Y,(X2-X),CH
    else if (screenA > 1.334 and X < X3)
      WinMove,ahk_id %activeWinID%,,X,Y,(X3-X),CH
    else if (X < screenX + screenW)
      WinMove,ahk_id %activeWinID%,,X,Y,(screenX + screenW - X),CH
  return


; Win-Down :: resize current window to one of 1/2 or full screen height (minus taskbar), without moving upper-left corner
#Down::
  WinGet,activeWinID,ID,A
  WinGetPos,X,Y,CW,CH,ahk_id %activeWinID%
  getWorkArea()
  Y1 := screenY + round(screenH / 2)
  RY := Y + CH
  if (RY < Y1)
    WinMove,ahk_id %activeWinID%,,X,Y,CW,(Y1-Y)
  else if (RY < screenY + screenH)
    WinMove,ahk_id %activeWinID%,,X,Y,CW,(screenY + screenH - Y)
  else
    if (Y < Y1)
      WinMove,ahk_id %activeWinID%,,X,Y,CW,(Y1-Y)
    else if (Y < screenY + screenH)
      WinMove,ahk_id %activeWinID%,,X,Y,CW,(screenY + screenH - Y)
  return







/********************  THESE ARE COOL, BUT UNNECESSARY  ********************/

/*
; Win-PgDn :: decrease opaqueness (increase transparency)
#PgDn::
WinGet,activeWinID,ID,A
if activeWinID
{
  WinGet,winTransparency,Transparent,ahk_id %activeWinID%
  if (!winTransparency and winTransparency != 0)
    winTransparency = 256
  winTransparency -= 16
  if (winTransparency < 0)
    winTransparency = 0
  WinSet,Transparent,%winTransparency%,ahk_id %activeWinID%
}
return


; Win-PgUp :: increase opaqueness (decrease transparency)
#PgUp::
WinGet,activeWinID,ID,A
if activeWinID
{
  WinGet,winTransparency,Transparent,ahk_id %activeWinID%
  ; don't need to check for blank - means it's already opaque
  if (winTransparency >= 0)
  {
    winTransparency += 16
    if (winTransparency >= 255)
      winTransparency := "Off"
    WinSet,Transparent,%winTransparency%,ahk_id %activeWinID%

    ; desktop doesn't redraw automatically when turning transparency off
    ; (probably some other windows too - sigh)
    if (winTransparency = "Off")
    {
      WinGetClass,activeWinClass,ahk_id %activeWinID%
      if (activeWinClass = "Progman")
      {
        WinHide,ahk_id %activeWinID%
        WinShow,ahk_id %activeWinID%
      }
    }
  }
}
return


; Win-Space :: center current window
#Space::
  WinGet,activeWinID,ID,A
  WinGetPos,,,width,height,ahk_id %activeWinID%
  getWorkArea()
  WinMove,ahk_id %activeWinID%,,(screenW-width)/2 + screenX,(screenH-height)/2 + screenY
  return

*/