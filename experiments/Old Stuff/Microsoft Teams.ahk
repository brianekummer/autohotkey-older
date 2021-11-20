#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



; https://github.com/tdalon/ahk/blob/main/Lib/Teams.ahk



PowerTools_GetParam(Param) {
ParamVal := PowerTools_RegRead(Param)

If !(ParamVal="") 
	return ParamVal
If RegExMatch(Param,"^TeamsFindText(.*)",sMatch) 
    return Teams_GetText(sMatch1,True) ; Default value


Switch Param
{
    Case "TeamsMentionDelay":
        return 1300
    Case "TeamsCommandDelay":
        return 800
    Case "TeamsClickDelay":
        return 500
    Case "TeamsShareDelay":
        return 1500
    Case "TeamsMeetingWinUseFindText":
        return 1
}
} ;eofun



PowerTools_RegRead(Prop){
RegRead, OutputVar, HKEY_CURRENT_USER\Software\PowerTools, %Prop%
return OutputVar
}

PowerTools_RegWrite(Prop, Value){
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\PowerTools, %Prop%, %Value%    
}



Teams_GetMainWindow(){
; See implementation explanations here: https://tdalon.blogspot.com/get-teams-window-ahk
; Syntax: hWnd := Teams_GetMainWindow()

WinGet, WinCount, Count, ahk_exe Teams.exe

If (WinCount = 0)
    GoTo, StartTeams

 ; fall-back if wrong exe found: close Teams
TeamsMainWinId := PowerTools_RegRead("TeamsMainWinId")

If WinExist("ahk_id " . TeamsMainWinId) {
    WinGet AhkExe, ProcessName, ahk_id %TeamsMainWinId% ; safe-check hWnd belongs to Teams.exe
    If (AhkExe = "Teams.exe")
        ;msgbox #1 TeamsMainWinId = %TeamsMainWinId%
        return TeamsMainWinId  
}

; when virtuawin is running Teams main window can be on another virtual desktop = hidden
Process, Exist, VirtuaWin.exe
VirtuaWinIsRunning := ErrorLevel
If (WinCount = 1) and Not (VirtuaWinIsRunning) {
    TeamsMainWinId := WinExist("ahk_exe Teams.exe")
    PowerTools_RegWrite("TeamsMainWinId",TeamsMainWinId)
    ;msgbox #2 TeamsMainWinId = %TeamsMainWinId%
    return TeamsMainWinId
}

; Get main window via Acc Window Object Name
WinGet, id, List,ahk_exe Teams.exe
Loop, %id%
{
    hWnd := id%A_Index%
    oAcc := Acc_Get("Object","4",0,"ahk_id " hWnd)
    sName := oAcc.accName(0)
    If RegExMatch(sName,".* \| Microsoft Teams, Main Window$") {
        PowerTools_RegWrite("TeamsMainWinId",hWnd)
        ;msgbox #3 HWnd = %hWnd%
        return hWnd
    }
}

; Fallback solution with minimize all window and run exe
If WinActive("ahk_exe Teams.exe") {
    GroupAdd, TeamsGroup, ahk_exe Teams.exe
    WinMinimize, ahk_group  TeamsGroup
} 

StartTeams: 
fTeamsExe = C:\Users\%A_UserName%\AppData\Local\Microsoft\Teams\current\Teams.exe
If !FileExist(fTeamsExe) {
    return
}
 
Run, "%fTeamsExe%""
WinWaitActive, ahk_exe Teams.exe
TeamsMainWinId := WinExist("A")
PowerTools_RegWrite("TeamsMainWinId",TeamsMainWinId)

;msgbox TeamsMainWinId = %TeamsMainWinId%
return TeamsMainWinId

} ; eofun



Teams_GetMeetingWindow(useFindText:="" , restore := True){
; See implementation explanations here: https://tdalon.blogspot.com/2021/04/ahk-get-teams-meeting-window.html

If (useFindText="")
    useFindText := 1      ; PowerTools_GetParam("TeamsMeetingWinUseFindText") ; Default 1

;msgbox useFindText = %useFindText%
If (useFindText) {
    If (restore)
        WinGet, curWinId, ID, A
    ResumeText:="|<>*138$51.zzzzzzzzw3zzzzzzzUDzzzzzzwtzzzzzzzbA64NU1kQ1423A04FUtUQNa8aAX0EXAlY1a9zUNaAbwt4Y0AlYHb4461aAkTzzzzzzzzU" ; FindText for Resume
    LeaveText:="|<>*168$66.zzzzzzzzzzzzzzzzDzzzzzy01zzDzzzzzs00TzDzzzzzk00DzDkkFW3U7k7zDUG9YFUDk7zD6T9YlUTs7zD0E841kTs7zD7nAAzszwDz022AAHzzzzz0UECS3zzzzzzzzzzzU"
}

WinGet, Win, List, ahk_exe Teams.exe
TeamsMainWinId := Teams_GetMainWindow()
TeamsMeetingWinId := PowerTools_RegRead("TeamsMeetingWinId")
WinCount := 0
Select := 0


Loop %Win% {
    WinId := Win%A_Index%
    If (WinId == TeamsMainWinId) { ; Exclude Main Teams Window 
        ;WinGetTitle, Title, % "ahk_id " WinId
        ;MsgBox %Title%
        Continue
    }
    WinGetTitle, Title, % "ahk_id " WinId  
    ;msgbox Title is %Title%
    
    IfEqual, Title,, Continue
    Title := StrReplace(Title," | Microsoft Teams","")
    If RegExMatch(Title,"^[^\s]*\s?[^\s]*,[^\s]*\s?[^\s]*$") or RegExMatch(Title,"^[^\s]*\s?[^\s]*,[^\s]*\s?[^\s]*\([^\s\(\)]*\)$") ; Exclude windows with , in the title (Popped-out 1-1 chat) and max two words before , Name, Firstname               
        ;msgbox REGEX #1
        Continue
    
    If RegExMatch(Title,"^Microsoft Teams Call in progress*") or RegExMatch(Title,"^Microsoft Teams Notification*") or RegExMatch(Title,"^Screen sharing toolbar*")
        ;msgbox REGEX #2
        Continue
    
    If (useFindText) {
        msgbox DOING useFindText 
        ; Exclude window with no Leave element
        WinActivate, ahk_id %WinId%
        If !(ok:=FindText(,,,, 0, 0, LeaveText,,0)) {
            msgbox useFindFirst #1
            Continue
        } 
        
        ; Final check - exclude window with Resume element = On hold meetings
        If (ok:=FindText(,,,, 0, 0, ResumeText,,0)) {
            msgbox useFindFirst #2
            Continue
        } 
    }
        
    WinList .= ( (WinList<>"") ? "|" : "" ) Title "  {" WinId "}"
    WinCount++

    ; Select by default last meeting window used
    If WinId = %TeamsMeetingWinId% 
        msgbox WinId IS TeamsMeetingWinId
        Select := WinCount  
} ; End Loop

If (WinCount = 0)
    Msgbox WINCOUNT = 0
    return      ; KUMMER RETURNING TeamsMainWinId
If (WinCount = 1) { ; only one other window
    ;Msgbox ONLY ONE OTHER WINDOW
    RegExMatch(WinList,"\{([^}]*)\}$",WinId)
    TeamsMeetingWinId := WinId1
    PowerTools_RegWrite("TeamsMeetingWinId",TeamsMeetingWinId)
    return TeamsMeetingWinId
}

If (restore)
    WinActivate, ahk_id %curWinId%

LB := WinListBox("Teams: Meeting Window", "Select your current Teams Meeting Window:" , WinList, Select)
RegExMatch(LB,"\{([^}]*)\}$",WinId)
TeamsMeetingWinId := WinId1
PowerTools_RegWrite("TeamsMeetingWinId",TeamsMeetingWinId)
return TeamsMeetingWinId

} ; eofun


Teams_FindText(Id){
; ok := Teams_FindText(Id)
Text := Teams_GetText(Id)

WinGetPos, x,y,w,h,A ; (x,y) upper left corner
X1 := x, Y1 := y, X2 := x+w, Y2 := y+h  ; (X1,Y1): upper left corner, (X2,Y2): lower right corner
ok:=FindText(X1,Y1,X2,Y2, 0, 0, Text,,0) ; last arg FindAll
;ok:=FindText(,,,, 0, 0, Text,,0) ; last arg FindAll
 /*
MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
   . "`n`nTime:`t" (A_TickCount-t1) " ms"
   . "`n`nPos:`t" X ", " Y
   . "`n`nResult:`t" (ok ? "Success !" : "Failed !")
*/
;t1:=A_TickCount, X:=Y:=""

;WinGetPos, x,y,w,h,A ; (x,y) upper left corner
;X1 := x, Y1 := y, X2 := x+w, Y2 := y-h  ; (X1,Y1): upper left corner, (X2,Y2): lower right corner
;X1 := 1303-150000, Y1:= 90-150000, X2 := 1303+150000, Y2 := 90+150000
;MsgBox %X1% %Y1% %X2% %Y2%
;ok:=FindText(X1,Y1,X2,Y2, 0, 0, Text,,0) ; last arg FindAll
return ok
} ;eofun



Teams_GetText(Id,Def:=False){
; Text := Teams_GetText(Id,Def)
; If Def = False, take value from registry

If !(Def) {
    return PowerTools_GetParam("TeamsFindText" . Id)
}

; Default values
Switch Id
{
Case "MeetingActions": ; 3 dots
    Text:="|<>*103$26.zzzzzzzzzzzzzzzzzzzzzzzzzzyC77z1VUzkMMDyC77zzzzzzzzzzzzzzzzzzzzzzzzzzs"
Case "MeetingReactions":
    Text:="|<>*100$22.zzzzwzzz0zzk1zy07zs0TzU1zy6VztyGTby8yTltxyTnnnvjaNaS3ztzzzbzN6zwknztyTzk3zzUTzzzy"
Case "MeetingReactionHeart":
    Text:="|<>*74$26.zzzzzUT1zk307s001w000D0003U000M00060001U000Q00070003s000y000Tk00Dy007zs03zz03zzs1zzz0zzzwTzzzjzzzzzy"
Case "MeetingReactionLaugh":
    Text:="|<>*126$24.zzzzzwDzzU1zy00Tw00Ds4A7sGG7k003k003k003V00VU001U001V001l00XkU13kE03s4A7s007w00Dy00TzU1zzwDzzzzzU"
Case "MeetingReactionApplause":
    Text:="|<>*116$25.zzzzxrzzzzzrzzzzzN7zzw1vjz0Qzy06Dz01bz001zU00zk00Ds007y003z001zU00zs007y003zU01zw00zzU0zzzUzzzzzzzzzU"
Case "MeetingReactionLike":
    Text:="|<>*119$20.zzzzzwzzyDzzXzzlzzkTzsDzw3zy0zzU0zk07E01U00M006001U00M006003U00w00TzUDzzzs"
Case "MeetingActionFullScreen":
    Text:="|<>*106$93.zzzzzzzzzzzzzzzy00TzUTwbzzzzzzzjzxzwzzYzzzzzzzx7sjzbzwbzzzzzzzfzpzwwtYy3123VURTyjzbbAbnH9aNYFjzxzw4tYySTAsQbBzzjzbbAbsntU04tfzpzwwtYzmTAyTbBTyjzbmAbqH9btwtcz5zwy1Yy71C3UbBzzjzzzzzzzzzzzzk03zzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
Case "MeetingActionTogetherMode":
    Text:="|<>*66$18.zzzySTxhjxhjySTzzztnbqhPqhPtnbzzzV0VjSxbStlVXzvzzzzU"
Case "MeetingActionBackgrounds":
    Text:="|<>*104$18.zzztgrnThaVNhhnvAbrhBgVPtzrm0RazNizHuzLzzzU"
Case "MeetingActionShare":
    Text:="|<>*161$22.zzzzzzzw003U0060A0M1s1UDk61hUM0k1U3060A0M0k1U3060A0M001k00DzzzzzzzU"
Case "MeetingActionUnShare":
    Text:="|<>*153$22.zzzzzzzw003U006000M421U8E60G0M0k1U3060G0M241UE86000M001k00DzzzzzzzU"
Case "Muted","Unmute":
    ;Text:="|<>*113$22.zzzyzVzxw3zvU7zq0Tzg1zzM7zykTztVzzX7zy6Tz8BDwkQzv0rzbBzzDnzyA7zy7jzwzTznyzzjxzzzy" ; does not work
Case "Mute","Unmuted":
    ;Text:="|<>*111$18.zzzzzzzVzz0zz0zy0Ty0Ty0Ty0Ty0Ty0Ty0Tm0Hn0nv0rtnbwzDy0TzVzznzznzzvzzzzU" 
    Text:="|<>*112$31.zzzzzzzzzzzzzzzzzzzzzzy7zzzy1zzzy0Tzzz0Dzzz03zzzU1zzzk0zzzs0Tzzw0Dzzy07zzz03zzxU1jzys1rzzQ0vzza0NzznURzzwzwzzzDwzzzlszzzy1zzzznzzzztzzzzwzzzzyTzzzzzzzzzzzzzzzzzk"
Case "Leave":
    Text:="|<>*155$81.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzwzzzzzzzzk0Dzzbzzzzzzzk00Dzwzzzzzzzw000zzbw70XX1z0003zwz0M2AE7k1y0DzbtlwFWQS0Ts1zwy0A2AU3k3z0Dzbk30N40S0zw1zwyDlX1Xzs7zUTzbluAMCCzrzzbzw10E3Vk7zzzzzzUA30QT0zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
Case "Resume":
    Text:="|<>*138$51.zzzzzzzzw3zzzzzzzUDzzzzzzwtzzzzzzzbA64NU1kQ1423A04FUtUQNa8aAX0EXAlY1a9zUNaAbwt4Y0AlYHb4461aAkTzzzzzzzzU" ; FindText for Resume
Case "NewConversation":
    Text:="|<>*155$184.0000000000000000000000000000000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzvzzzzzzzzzzzzzzzzzzzzzzzzbzzzk7TzzzzzzzzzzzzzzzzzzzzzzzyTzzyTvzzllzzzzzzzzzzzzzzDzzzzztzzzvzTzz77zzzzzzzzzzzzyMzzzzzzbzzzjvzzwATzzzzzzzzzzzztzzzzzzyTzzyzRzzkFUa8y31UFW30230A60zzztzzzvvrzz94E8bk820aF4M968U83zzzbzzzjTTzwUH0WTD78mNAHbyNWQX7zzyTzzyzxzzn10E1wwQX841C21a1kATzztzzzvzrzzC4z27nlmAknwy1aMb8lzzzbzzzjzTzwsFA8z0U8n34nc4M20X7zzyTzzyTtzznlUtXy31XCS3C61UA6ATzztzzzw0DzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzyTzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzXzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw0000000000000000000000000000002"
} ; eoswitch

return Text


} ; eofun


Teams_Mute(State := 2){
; State: 
;    0: mute off, unmute
;    1: mute on
;    2*: (Default): Toggle mute state

; N.B.: ControlSend does not work for Teams window e.g. ControlSend, ahk_parent, ^+m, ahk_id %WinId% - Teams window must be active
; hotkey does not work anymore from main window
/* If (State = 2) ; Toggle mute
    WinId := Teams_GetMainWindow() ; mute hotkey can be run from Main window - prefer main window because it is easier and more robust - 
Else {
    WinId := Teams_GetMeetingWindow() ; need to get meeting window to check mute state
} 
*/

WinId := Teams_GetMeetingWindow()
;msgbox "Window Id = %WinId%" 
If !WinId ; empty
    return
;MsgBox % WinId
WinGet, curWinId, ID, A
WinActivate, ahk_id %WinId%

If (State <> 2)
;msgbox "IF #1"
    IsMuted := !(Teams_FindText("Mute"))
;MsgBox %IsMuted%
Switch State 
{
    Case 0:
        ;msgbox "WILL UNMUTE"
        Tooltip("Teams Unmute Mic...") 
        If !IsMuted
            return
        
    Case 1:
        If IsMuted
            return
        ;msgbox "WILL MUTE"
        Tooltip("Teams Mute Mic...") 
    Case 2:
        ;msgbox "WILL TOGGLE"
        Tooltip("Teams Toggle Mute Mic...") 
}

SendInput ^+m ;  ctrl+shift+m 
Sleep 500 ; pause before reactivating previous window
WinActivate, ahk_id %curWinId%

} ; eofun