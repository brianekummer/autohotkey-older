OnMessage(0x0319, "WM_APPCOMMAND")
Gui, Show, w100 h100
return

WM_APPCOMMAND()
{
	msgbox WM_APPCOMMAND received
}

GuiEscape:
GuiClose:
ExitApp