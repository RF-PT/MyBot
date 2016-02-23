; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design SmartZap
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RuiF
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$tabSmartZap = GUICtrlCreateTabItem("SmartZap")
	;;;;;;;;;;;;;;;;;
    ;;;;SmartZap;;;;;
    ;;;;;;;;;;;;;;;;;
    Local $x = 35, $y = 155
    $grpStatsMisc = GUICtrlCreateGroup(GetTranslated(17,1,"SmartZap Attack"), $x - 20, $y - 20, 218, 95)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 20, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x -10, $y - 7, 24, 24)
		$chkSmartLightSpell = GUICtrlCreateCheckbox(GetTranslated(17,2,"Use Lightning"), $x + 20, $y - 5, -1, -1)
			$txtTip = GetTranslated(17,3,"Check this to drop Lightning Spells on top of drills of Dark Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "SmartLightSpell")
		$chkTrainLightSpell = GUICtrlCreateCheckbox(GetTranslated(17,4,"Auto-Training of Spells"), $x + 20, $y + 20, -1, -1)
			$txtTip = GetTranslated(17,5,"This option is to continuously create lightning spells.")
			GUICtrlSetTip(-1, $txtTip)
		$lblSmartZap = GUICtrlCreateLabel(GetTranslated(17,6,"Min. amount of Dark Elixir"), $x - 10, $y + 47, -1, -1)
		$txtMinDark = GUICtrlCreateInput("478", $x + 155, $y + 45, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = GetTranslated(17,7,"The added value here depends a lot on what level is your TH, put a value between 500-1500.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
	Local $x =35, $y = 255
	   $grpStatsMisc = GUICtrlCreateGroup(GetTranslated(17,8,"Tips"), $x - 20, $y - 20, 440, 70)
	   $lblSmartZap = GUICtrlCreateLabel(GetTranslated(17,9,"Remember to go to the tab 'troops' and put the maximum capacity of your spell factory and the number of spells so that the bot can function perfectly."), $x -10, $y + 1, 420, 70, $SS_LEFT)
	Local $x =236, $y = 155
		$grpStatuszap = GUICtrlCreateGroup(GetTranslated(17,10,"Status"), $x, $y - 20, 218, 95)
		$picSmartZap = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y + 3, 24, 24)
		$lblSmartZap = GUICtrlCreateLabel("0", $x +60, $y + 5, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
		$txtTip = GetTranslated(17,11,"Number of dark elixir zapped during the attack with lightning.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 160, $y + 40, 24, 24)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x +60, $y + 40, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1,0x279B61)
			$txtTip = GetTranslated(17,12,"Amount of used spells.")
			GUICtrlSetTip(-1, $txtTip)
    Local $x = 35, $y = 330
	    $grpSaveTroops = GUICtrlCreateGroup(GetTranslated(17,13,"SaveTroop"), $x - 20, $y - 20, 440, 65)
		$chkChangeFF = GUICtrlCreateCheckbox(GetTranslated(17,14,"Use Four Finger"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(17,15,"Change to Four Finger if less than % of collectors near RED LINE.")
			GUICtrlSetTip(-1, $txtTip)
		$txtTHpercentCollectors = GUICtrlCreateInput("80", $x - 10, $y + 17, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 100)
		$lblChangeFF = GUICtrlCreateLabel(GetTranslated(17,16,"% Collectors."), $x + 30, $y + 20, -1, -1)
		   	GUICtrlSetTip(-1, $txtTip)
	Local $x =35, $y = 400
	   $grpSaveTroops = GUICtrlCreateGroup(GetTranslated(17,8,"Tips"), $x - 20, $y - 20, 440, 70)
	   $lblChangeFF = GUICtrlCreateLabel(GetTranslated(17,17,"Save Troops for Collectors: my suggestion is for Barch lvl. 6 and above use 70%, for Barch lvl. 5 use 80% and for Barch lvl. 4 use 90%."), $x -10, $y + 1, 420, 70, $SS_LEFT)

GUICtrlCreateTabItem("")