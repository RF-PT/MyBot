; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Expert Tab
;~ -------------------------------------------------------------
$tabExpert = GUICtrlCreateTabItem(GetTranslated(10,1, "Expert"))
Local $x = 30, $y = 150
$grpOnLoadBot = GUICtrlCreateGroup(GetTranslated(10,2, "When Bot Loads"), $x - 20, $y - 20, 205, 100)
	$y -= 4
	$chkVersion = GUICtrlCreateCheckbox(GetTranslated(10,3, "Check for Updates"), $x, $y, -1, -1)
		$txtTip = GetTranslated(10,4, "Check if you are running the latest version of the bot.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 20
	$chkDeleteLogs = GUICtrlCreateCheckbox(GetTranslated(10,5, "Delete Log Files")& ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(10,6, "Delete log files older than this specified No. of days.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLogs")
	$txtDeleteLogsDays = GUICtrlCreateInput("7", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblDeleteLogsDays = GUICtrlCreateLabel(GetTranslated(10,7, "days"), $x + 150, $y + 4, 38, 15)
	$y += 20
	$chkDeleteTemp = GUICtrlCreateCheckbox(GetTranslated(10,8, "Delete Temp Files") & ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(10,9, "Delete temp files older than this specified No. of days.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteTemp")
	$txtDeleteTempDays = GUICtrlCreateInput("7", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblDeleteTempDays = GUICtrlCreateLabel(GetTranslated(10,7, "days"), $x + 150, $y + 4, 38, 15)
	$y += 20
	$chkDeleteLoots = GUICtrlCreateCheckbox(GetTranslated(10,10, "Delete Loot Images"), $x, $y, -1, -1)
		$txtTip = GetTranslated(10,11, "Delete loot image files older than this specified No. of days.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLoots")
	$txtDeleteLootsDays = GUICtrlCreateInput("7", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblDeleteLootsDays = GUICtrlCreateLabel(GetTranslated(10,7, "days"), $x + 150, $y + 4, 38, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1)


Local $x = 30, $y = 252
$grpOnStartBot = GUICtrlCreateGroup(GetTranslated(10,12, "When Bot Starts"), $x - 20, $y - 20, 205, 112)
	$y -= 5
	$chkAutostart = GUICtrlCreateCheckbox(GetTranslated(10,13, "Auto START after") & ":", $x, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,58, "Auto START the Bot after this No. of seconds."))
		GUICtrlSetOnEvent(-1, "chkAutostart")
	$txtAutostartDelay = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblAutostartSeconds = GUICtrlCreateLabel(GetTranslated(10,14, "sec."), $x + 150, $y + 4, 38, 18)
	$y += 22
	$chkLanguage = GUICtrlCreateCheckbox(GetTranslated(10,15, "Check Game Language (EN)"), $x, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,16, "Check if the Game is set to the correct language (Must be set to English)."))
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 22
	$chkDisposeWindows = GUICtrlCreateCheckbox(GetTranslated(10,17, "Auto Align"), $x, $y, -1, -1)
		$txtTip = GetTranslated(10,18, "Reposition/Align Bluestacks and BOT windows on the screen.")
		GUICtrlSetOnEvent(-1, "chkDisposeWindows")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
	$lblOffset = GUICtrlCreateLabel(GetTranslated(10,19, "Offset") & ":", $x + 85, $y + 4, -1, -1)
	$txtWAOffsetx = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(10,20, "Offset horizontal pixels between BlueStacks (BS) and BOT windows.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$txtWAOffsety= GUICtrlCreateInput("0", $x + 150, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(10,21, "Offset vertical pixels between BlueStacks (BS) and BOT windows.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$y += 23
	$cmbDisposeWindowsCond = GUICtrlCreateCombo("", $x + 15, $y, 160, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslated(10,22, "0,0: BlueStacks-Bot") & "|" & GetTranslated(10,23, "0,0: Bot-BlueStacks") & "|" & GetTranslated(10,24, "SNAP: Bot TopRight to BS") &"|" & GetTranslated(10,25, "SNAP: Bot TopLeft to BS") & "|" & GetTranslated(10,26, "SNAP: Bot BottomRight to BS") & "|" & GetTranslated(10,27, "SNAP: Bot BottomLeft to BS") , GetTranslated(10,24, "SNAP: Bot TopRight to BS"))
		$txtTip &= @CRLF & GetTranslated(10,28, "0,0: Reposition BS screen to position 0,0 on windows desktop and align Bot window right or left to it.") & @CRLF & GetTranslated(10,29, "SNAP: Only reorder windows, Align Bot window to BlueStacks window at Top Right, Top Left, Bottom Right or Bottom Left.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 365
$grpTiming = GUICtrlCreateGroup(GetTranslated(10,30, "Timing"), $x - 20, $y - 20, 205, 50)
	$lblTrainDelay = GUICtrlCreateLabel(GetTranslated(10,31, "Train Troops") & ":", $x, $y, -1, -1)
	$lbltxtTrainITDelay = GUICtrlCreateLabel(GetTranslated(10,32, "delay"), $x + 70, $y - 5, 37, 50)
		GUICtrlSetTip(-1, GetTranslated(10,33, "Increase the delay if your PC is slow"))
	$sldTrainITDelay = GUICtrlCreateSlider($x + 105, $y - 5, 70, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
		GUICtrlSetTip(-1, GetTranslated(10,33, "Increase the delay if your PC is slow"))
		GUICtrlSetBkColor(-1, $COLOR_WHITE)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-100, 100)
		GUICtrlSetLimit(-1, 500, 1) ; change max/min value
		GUICtrlSetData(-1, 10) ; default value
		GUICtrlSetOnEvent(-1, "sldTrainITDelay")
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 415
$grpDebug = GUICtrlCreateGroup(GetTranslated(10,34, "Debug"), $x - 20, $y - 20, 205, 40)
	$chkDebugClick = GUICtrlCreateCheckbox(GetTranslated(10,40, "Coord."), $x, $y-5, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,35, "Debug: Write the clicked (x,y) coordinates to the log."))
	;$y += 20
	$chkDebugSetlog = GUICtrlCreateCheckbox(GetTranslated(10,41, "L"), $x +55 , $y-5, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,36, "Debug: Enables debug SetLog messages in code for Troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetOnEvent(-1, "chkDebugSetlog")
	$chkDebugOcr = GUICtrlCreateCheckbox(GetTranslated(10,42, "O"), $x + 85, $y-5, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,37, "Debug: Enables Saving OCR images for troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetOnEvent(-1, "chkDebugOcr")
	$chkDebugImageSave = GUICtrlCreateCheckbox(GetTranslated(10,43, "I"), $x + 115, $y-5, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,38, "Debug: Enables Saving images for troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetOnEvent(-1, "chkDebugImageSave")
	$chkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslated(10,44, "B"), $x + 145, $y-5, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(10,39, "Debug: Enables showing positions of buildings in log."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetOnEvent(-1, "chkdebugBuildingPos")

GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 455
$grpOtherExpert = GUICtrlCreateGroup(GetTranslated(10,45, "Other Options"), $x - 20, $y - 20, 205, 70)
	$chkTotalCampForced = GUICtrlCreateCheckbox(GetTranslated(10,46, "Force Total Army Camp")&":", $x-5, $y-7, -1, -1)
		GUICtrlSetOnEvent(-1, "chkTotalCampForced")
		GUICtrlSetTip(-1, GetTranslated(10,47, "If not detected set army camp values (instead ask)"))
	$txtTotalCampForced = GUICtrlCreateInput("200", $x + 130, $y - 5, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
$y += 13
	$chkSinglePBTForced = GUICtrlCreateCheckbox(GetTranslated(10,61, "Force Single PB logoff"), $x-5, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSinglePBTForced")
		GUICtrlSetTip(-1, GetTranslated(10,62, "This forces bot to exit CoC only one time prior to normal start of PB"))
	$txtSinglePBTimeForced = GUICtrlCreateInput("16", $x + 130, $y-1, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, GetTranslated(10,63, "Type in number of minutes to keep CoC closed. Set to 15 minimum to reset PB timer!"))
		GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblSinglePBTimeForced = GUICtrlCreateLabel( GetTranslated(10,64, "Min"), $x+164, $y+2)
$y += 17
	$lblPBTimeForcedExit = GUICtrlCreateLabel( GetTranslated(10,65, "Subtract time for early PB exit"), $x-10, $y+3)
		$txtTip = GetTranslated(10,66, "Type in number of minutes to quit CoC early! Setting below 10 minutes may not function!")
		GUICtrlSetTip(-1, $txtTip)
	$txtPBTimeForcedExit = GUICtrlCreateInput("15", $x + 130, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblPBTimeForcedExit1 = GUICtrlCreateLabel( GetTranslated(10,64, -1), $x+164, $y+1)
GUICtrlCreateGroup("", -99, -99, 1, 1)


Local $x = 240, $y = 150
$grpPhotoExpert = GUICtrlCreateGroup(GetTranslated(10,55, "Photo Screenshot Options"), $x - 20, $y - 20, 240, 59)
$y -= 4
	$chkScreenshotType = GUICtrlCreateCheckbox(GetTranslated(10,56, "Make in PNG format"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkScreenshotType")
		GUICtrlSetState(-1, $GUI_CHECKED)
$y += 19
	$chkScreenshotHideName = GUICtrlCreateCheckbox(GetTranslated(10,57, "Hide Village and Clan Castle Name"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkScreenshotHideName")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

