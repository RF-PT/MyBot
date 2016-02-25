
; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (2016-2)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $logwrited = False
	$iSkipped = 0

	If $debugDeadBaseImage = 1 Then
		If DirGetSize(@ScriptDir & "\SkippedZombies\") = -1 Then DirCreate(@ScriptDir & "\SkippedZombies\")
		If DirGetSize(@ScriptDir & "\Zombies\") = -1 Then DirCreate(@ScriptDir & "\Zombies\")
	EndIf

	If $Is_ClientSyncError = False Then
		For $i = 0 To $iModeCount - 1
			$iAimGold[$i] = $iMinGold[$i]
			$iAimElixir[$i] = $iMinElixir[$i]
			$iAimGoldPlusElixir[$i] = $iMinGoldPlusElixir[$i]
			$iAimDark[$i] = $iMinDark[$i]
			$iAimTrophy[$i] = $iMinTrophy[$i]
		Next
	EndIf

	_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; Reduce Working Set of Android Process
	_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot

	If _Sleep($iDelayVillageSearch1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $Restart = True Then Return ; exit func
	For $x = 0 To $iModeCount - 1
		If $iHeroWait[$x] > $HERO_NOHERO And (BitAND($iHeroAttack[$x], $iHeroWait[$x], $iHeroAvailable) = $iHeroWait[$x]) = False Then
			SetLog(_PadStringCenter(" Skip " & $sModeText[$x] & " - Hero Not Ready " & BitAND($iHeroAttack[$x], $iHeroWait[$x], $iHeroAvailable) & "|" & $iHeroAvailable, 54, "="), $COLOR_RED)
			ContinueLoop ; check if herowait selected and hero available for each search mode
		EndIf
		If ($x = 0 And $iCmbSearchMode = 0) Or ($x = 0 And $iCmbSearchMode = 2) or ($x = 1 And $iCmbSearchMode = 1) Or ($x = 1 And $iCmbSearchMode = 2) Or ($x = 2 And $OptTrophyMode = 1) Or ($x = 2 And $iChkSnipeWhileTrain = 1) Then

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" Searching For " & $sModeText[$x] & " ", 54, "="), $COLOR_BLUE)

			Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTrophytext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" SEARCH CONDITIONS ", 50, "~"), $COLOR_BLUE)

			If $iCmbMeetGE[$x] = 0 Then $MeetGxEtext = "Meet: Gold and Elixir"
			If $iCmbMeetGE[$x] = 1 Then $MeetGorEtext = "Meet: Gold or Elixir"
			If $iCmbMeetGE[$x] = 2 Then $MeetGplusEtext = "Meet: Gold + Elixir"
			If $iChkMeetDE[$x] = 1 Then $MeetDEtext = ", Dark"
			If $iChkMeetTrophy[$x] = 1 Then $MeetTrophytext = ", Trophy"
			If $iChkMeetTH[$x] = 1 Then $MeetTHtext = ", Max TH " & $iMaxTH[$x] ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $MeetTHOtext = ", TH Outside"
			If $iChkWeakBase[$x] = 1 Then $MeetWeakBasetext = ", Weak Base(Mortar: " & $iCmbWeakMortar[$x] & ", WizTower: " & $iCmbWeakWizTower[$x] & ")"
			If $iChkEnableAfter[$x] = 1 Then $EnabledAftertext = ", Enabled after " & $iEnableAfterCount[$x] & " searches"

			If Not ($Is_SearchLimit) Then SetLog($MeetGxEtext & $MeetGorEtext & $MeetGplusEtext & $MeetDEtext & $MeetTrophytext & $MeetTHtext & $MeetTHOtext & $MeetWeakBasetext & $EnabledAftertext)

			If $iChkMeetOne[$x] = 1 And Not ($Is_SearchLimit) Then SetLog("Meet One and Attack!")

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_BLUE)
			If $iChkMeetTH[$x] = 1 Then $iAimTHtext[$x] = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $iAimTHtext[$x] &= ", Out"


			If $iCmbMeetGE[$x] = 2 Then
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf

		EndIf
	Next

	If $OptBullyMode + $OptTrophyMode + $chkATH > 0 Then
		If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" ADVANCED SETTINGS ", 50, "~"), $COLOR_BLUE)
		Local $YourTHText = "", $chkATHText = "", $OptTrophyModeText = ""

		If $OptBullyMode = 1 Then
			For $i = 0 To 4
				If $YourTH = $i Then $YourTHText = "TH" & $THText[$i]
			Next
		EndIf

		If $OptBullyMode = 1 And Not ($Is_SearchLimit) Then SetLog("THBully Combo @" & $ATBullyMode & " SearchCount, " & $YourTHText)

		If $chkATH = 1 Then $chkATHText = " Attack TH Outside "
		If $OptTrophyMode = 1 Then $OptTrophyModeText = "THSnipe Combo, " & $THaddtiles & " Tile(s), "
		If ($OptTrophyMode = 1 Or $chkATH = 1) And Not ($Is_SearchLimit) Then SetLog($OptTrophyModeText & $chkATHText & $txtAttackTHType)
	EndIf

	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_BLUE)
	Else
		SetLog(_PadStringCenter(" Restart To Search ", 54, "="), $COLOR_BLUE)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowTS, $GUI_SHOW)
		GUICtrlSetState($pic2arrow, $GUI_HIDE)
		GUICtrlSetState($lblVersion, $GUI_HIDE)
	EndIf

	If $Is_ClientSyncError = False And $Is_SearchLimit = False Then
		$SearchCount = 0
	EndIf

	If $Is_SearchLimit = True Then $Is_SearchLimit = False


	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		If $debugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$bBtnAttackNowPressed = False
		$hAttackCountDown = TimerInit()
		If $iVSDelay > 0 And $iMaxVSDelay > 0 Then ; Check if village delay values are set
			If $iVSDelay <> $iMaxVSDelay Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($iVSDelay, $iMaxVSDelay))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $iVSDelay) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $Restart = True Then Return ; exit func

		GetResources(False) ;Reads Resource Values
		If $Restart = True Then Return ; exit func

		If Mod(($iSkipped + 1), 100) = 0 Then
			_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; reduce BS memory
			If _Sleep($iDelayRespond) Then Return
			If CheckZoomOut() = False Then Return
		EndIf

		SuspendAndroid()

		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $match[$iModeCount]
		Local $isModeActive[$iModeCount]
		For $i = 0 To $iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($iDelayRespond) Then Return
		Switch $iCmbSearchMode
			Case 0 ; check Dead Base only
				If $iHeroWait[$DB] = 0 Or ($iHeroWait[$DB] > 0 And BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $iHeroAvailable) = $iHeroWait[$DB]) Then ; check hero wait/avail
					$isModeActive[$DB] = True
					$match[$DB] = CompareResources($DB)
					;$noMatchTxt &= ", DB compare " & BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $iHeroAvailable)  ; use for debug
				Else
					$noMatchTxt &= ", DB Hero Not Ready, "
				EndIf
			Case 1 ; Check Live Base only
				If $iHeroWait[$LB] = 0 Or ($iHeroWait[$LB] > 0 And BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $iHeroAvailable) = $iHeroWait[$LB]) Then ; check hero wait/avail
					$isModeActive[$LB] = True
					$match[$LB] = CompareResources($LB)
					;$noMatchTxt &= ", LB compare " & BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $iHeroAvailable) ; use for debug
				Else
					$noMatchTxt &= ", LB Hero Not Ready, "
				EndIf
			Case 2
				For $i = 0 To $iModeCount - 2
					If $iHeroWait[$i] = 0 Or ($iHeroWait[$i] > 0 And BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable) = $iHeroWait[$i]) Then ; check hero wait/avail
						$isModeActive[$i] = IsSearchModeActive($i)
						If $isModeActive[$i] Then
							$match[$i] = CompareResources($i)
							;$noMatchTxt &= ", " & $sModeText[$i] & " compare " & BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable)  ; use for debug
						EndIf
					Else
						$noMatchTxt &= ", " & $sModeText[$i] & " Hero Not Ready:" & BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable)
					EndIf
				Next
		EndSwitch
		; Fail safe Safety Check for rare error with Hero wait and Hero not available that will disable ALL CompareResources
		Local $bSearchSafe = False
		For $i = 0 To $iModeCount - 2
			If $isModeActive[$i] Then $bSearchSafe = True
		Next
		If $bSearchSafe = False And ($OptBullyMode = 0 And $OptTrophyMode = 0) Then ; no search modes are active.
			Setlog("ERROR - Check Hero Wait & Search Start Values!!", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			Setlog("Search Logic Error occured and will NEVER find base!!!", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			ReturnHome(False, False) ;If End battle is available
			$Restart = True ; set force runbot restart flag
			$Is_ClientSyncError = False ; reset OOS flag
			Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			$ichkBotStop = 1 ; set halt attack variable
			$icmbBotCond = 18 ; set stay online/collect only mode
			Return
		EndIf

		If _Sleep($iDelayRespond) Then Return

		For $i = 0 To $iModeCount - 2
			If ($match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] <> 1) Or ($isModeActive[$i] And Not $match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] = 1) Then
				If IsWeakBase($i) Then
					$match[$i] = True
				Else
					$match[$i] = False
					$noMatchTxt &= ", Not a Weak Base for " & $sModeText[$i]
				EndIf
			EndIf
		Next

		If _Sleep($iDelayRespond) Then Return

		If $match[$DB] Or $match[$LB] Then
			$dbBase = checkDeadBase()
		EndIf

		Local $MilkingExtractorsMatch = 0
		$MilkFarmObjectivesSTR = ""
		If $match[$LB] And $iChkDeploySettings[$LB] = 6 Then ;MilkingAttack
			If $debugsetlog = 1 Then Setlog("Check Milking...", $COLOR_BLUE)
			MilkingDetectRedArea()
			$MilkingExtractorsMatch = MilkingDetectElixirExtractors()
			If $MilkingExtractorsMatch > 0 Then
				$MilkingExtractorsMatch += MilkingDetectMineExtractors() + MilkingDetectDarkExtractors()
			EndIf
			If StringLen($MilkFarmObjectivesSTR) > 0 And $debugsetlog = 1 Then
				Setlog("Match for Milking", $COLOR_BLUE)
			Else
				Setlog("Not a Match for Milking", $COLOR_BLUE)
			EndIf
		EndIf

		ResumeAndroid()

		If _Sleep($iDelayRespond) Then Return
		If $match[$LB] And $iChkDeploySettings[$LB] = 6 And StringLen($MilkFarmObjectivesSTR) > 0 Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack! ", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase And $iChkDeploySettings[$LB] <> 6 Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] Or $match[$DB] And $iChkDeploySettings[$LB] <> 6 Then
			If $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) Then
				If $SearchTHLResult = 1 Then
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("      " & "Not a match, but TH Bully Level Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
					$logwrited = True
					$iMatchMode = $iTHBullyAttackMode
					ExitLoop
				EndIf
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return
		If $OptTrophyMode = 1 Then ;Enables Combo Mode Settings
			If SearchTownHallLoc() And IsSearchModeActive($TS) Then ; attack this base anyway because outside TH found to snipe
				If CompareResources($TS) Then
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("      " & "TH Outside Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
					$logwrited = True
					$iMatchMode = $TS
					ExitLoop
				Else
					$noMatchTxt &= ", Not a " & $sModeText[$TS] & ", fails resource min"
				EndIf
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return
		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$DB]
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\SkippedZombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			;SetLog(_PadStringCenter(" " & StringMid($noMatchTxt, 3) & " ", 50, "~"), $COLOR_PURPLE)
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
			SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_BLACK, "Lucida Console", 7.5)
			$logwrited = True
		EndIf

		If $iChkAttackNow = 1 Then
			If _Sleep(1000 * $iAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf


		If $bBtnAttackNowPressed = True Then ExitLoop

		; th snipe stop condition
		If SWHTSearchLimit($iSkipped + 1) Then Return True
		; Return Home on Search limit
		If SearchLimit($iSkipped + 1) Then Return True


		Local $i = 0
		While $i < 100
			If _Sleep($iDelayVillageSearch2) Then Return
			$i += 1
			If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) And IsAttackPage() Then
				ClickP($NextBtn, 1, 0, "#0155") ;Click Next
				ExitLoop
			Else
				If $debugsetlog = 1 Then SetLog("Wait to see Next Button... " & $i, $COLOR_PURPLE)
			EndIf
			If $i >= 99 Or isProblemAffect(True) Then ; if we can't find the next button or there is an error, then restart
				$Is_ClientSyncError = True
				checkMainScreen()
				If $Restart Then
					$iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_RED)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem Couldn't locate Next button, Restarting CoC and Bot...", $COLOR_RED)
					$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and try restarting CoC
					CloseCoC(True)
				EndIf
				Return
			EndIf
		WEnd

		If _Sleep($iDelayRespond) Then Return
		$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
		checkAttackDisable($iTaBChkAttack, $Result) ; check to see If TakeABreak msg on screen after next click
		If $Restart = True Then Return ; exit func

		If isGemOpen(True) = True Then
			Setlog(" Not enough gold to keep searching.....", $COLOR_RED)
			Click(585, 252, 1, 0, "#0156") ; Click close gem window "X"
			If _Sleep($iDelayVillageSearch3) Then Return
			$OutOfGold = 1 ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$iSkippedVillageCount += 1
		If $iTownHallLevel <> "" Then
			$iSearchCost += $aSearchCost[$iTownHallLevel - 1]
			$iGoldTotal -= $aSearchCost[$iTownHallLevel - 1]
		EndIf
		UpdateStats()
	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $bBtnAttackNowPressed = True Then
		Setlog(_PadStringCenter(" Attack Now Pressed! ", 50, "~"), $COLOR_GREEN)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($pic2arrow, $GUI_SHOW)
		GUICtrlSetState($lblVersion, $GUI_SHOW)
		$bBtnAttackNowPressed = False
	EndIf

	If $AlertSearch = 1 Then
		TrayTip($sModeText[$iMatchMode] & " Match Found!", "Gold: " & $searchGold & "; Elixir: " & $searchElixir & "; Dark: " & $searchDark & "; Trophy: " & $searchTrophy, "", 0)
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		EndIf
	EndIf

	SetLog(_PadStringCenter(" Search Complete ", 50, "="), $COLOR_BLUE)
	PushMsg("MatchFound")

	; TH Detection Check Once Conditions
	If $OptBullyMode = 0 And $OptTrophyMode = 0 And $iChkMeetTH[$iMatchMode] = 0 And $iChkMeetTHO[$iMatchMode] = 0 And $chkATH = 1 Then
		$searchTH = checkTownHallADV2()

		If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
			If _Sleep($iDelayVillageSearch5) Then Return
			If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_RED)
			$searchTH = THSearch()
		EndIf

		If SearchTownHallLoc() = False And $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is inside, skip Attack TH")
		ElseIf $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is outside, Attacking Townhall!")
		Else
			SetLog("Checking Townhall location: Could not locate TH, skipping attack TH...")
		EndIf
	EndIf

	$Is_ClientSyncError = False

EndFunc   ;==>VillageSearch

Func IsSearchModeActive($pMode)
	If $iChkEnableAfter[$pMode] = 0 Then Return True
	If $SearchCount = $iEnableAfterCount[$pMode] Then SetLog(_PadStringCenter(" " & $sModeText[$pMode] & " search conditions are activated! ", 50, "~"), $COLOR_BLUE)
	If $SearchCount >= $iEnableAfterCount[$pMode] Then Return True
	Return False
EndFunc   ;==>IsSearchModeActive

Func IsWeakBase($pMode)

	Local $hWeakTimer = TimerInit()
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()

	Local $ImageInfo1 = ""
	Local $ImageInfo = ""

	$aToleranceImgLoc = 0.94
	Local $WeakBaseMortarX, $WeakBaseMortarY
	Local $WeakBaseMortarLoc = 0

	Local $WeakBaseMortarImages[8][3]
	$WeakBaseMortarImages[0][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv1_1.png"
	$WeakBaseMortarImages[0][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv1_2.png"
	$WeakBaseMortarImages[0][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv1_3.png"

	$WeakBaseMortarImages[1][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv2_1.png"
	$WeakBaseMortarImages[1][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv2_2.png"
	$WeakBaseMortarImages[1][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv2_3.png"

	$WeakBaseMortarImages[2][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv3_1.png"
	$WeakBaseMortarImages[2][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv3_2.png"
	$WeakBaseMortarImages[2][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv3_3.png"

	$WeakBaseMortarImages[3][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv4_1.png"
	$WeakBaseMortarImages[3][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv4_2.png"
	$WeakBaseMortarImages[3][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv4_3.png"

	$WeakBaseMortarImages[4][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv5_1.png"
	$WeakBaseMortarImages[4][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv5_2.png"
	$WeakBaseMortarImages[4][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv5_3.png"

	$WeakBaseMortarImages[5][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv6_1.png"
	$WeakBaseMortarImages[5][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv6_2.png"
	$WeakBaseMortarImages[5][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv6_3.png"

	$WeakBaseMortarImages[6][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv7_1.png"
	$WeakBaseMortarImages[6][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv7_2.png"
	$WeakBaseMortarImages[6][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv7_3.png"

	$WeakBaseMortarImages[7][0] = @ScriptDir & "\images\WeakBase\Mortars\Lv8_1.png"
	$WeakBaseMortarImages[7][1] = @ScriptDir & "\images\WeakBase\Mortars\Lv8_2.png"
	$WeakBaseMortarImages[7][2] = @ScriptDir & "\images\WeakBase\Mortars\Lv8_3.png"

	If $iCmbWeakMortar[$pMode] > 0 And $iCmbWeakMortar[$pMode] < 8 Then
		For $i = ($iCmbWeakMortar[$pMode]) To 7
			For $t = 0 To 2
				If FileExists($WeakBaseMortarImages[$i][$t]) Then
					Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hBitmapFirst, "str", $WeakBaseMortarImages[$i][$t], "float", $aToleranceImgLoc, "str", $DefaultCocSearchArea, "str", $DefaultCocDiamond)
					If IsArray($res) Then
						If $debugsetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
						If $res[0] = "0" Then
							; failed to find a Mortar on the field
							If $debugsetlog = 1 Then SetLog("No Mortars found For level:" & $i + 1, $COLOR_PURPLE)
							$WeakBaseMortarLoc = 0
						ElseIf $res[0] = "-1" Then
							SetLog("DLL inside Error", $COLOR_RED)
						ElseIf $res[0] = "-2" Then
							SetLog("Invalid Resolution", $COLOR_RED)
						Else
							$expRet = StringSplit($res[0], "|", 2)
							For $j = 1 To UBound($expRet) - 1 Step 2
								$WeakBaseMortarX = Int($expRet[$j])
								$WeakBaseMortarY = Int($expRet[$j + 1])
								$WeakBaseMortarLoc = 1
								$ImageInfo = String("MortarLv_" & $i + 1 & "-" & $t)
								If $debugsetlog = 1 Then SetLog("Found Mortar Lv" & $i + 1 & " (" & $WeakBaseMortarX & "/" & $WeakBaseMortarY & ")", $COLOR_RED)
								If $debugsetlog = 1 Then SetLog("Is Not a weak Base!..", $COLOR_RED)
								ExitLoop (3)
							Next
						EndIf
					EndIf
				EndIf
			Next
		Next
	Else
		$WeakBaseMortarLoc = 0
	EndIf

	Local $aToleranceImg[9] = [0.95, 0.95, 0.94, 0.94, 0.94, 0.92, 0.92, 0.92, 0.92]
	Local $WeakBaseWTowerX, $WeakBaseWTowerY
	Local $WeakBaseWTowerLoc = 0

	Local $WeakBaseWTowerImages[9]
	$WeakBaseWTowerImages[0] = @ScriptDir & "\images\WeakBase\WTower\lv1.png"
	$WeakBaseWTowerImages[1] = @ScriptDir & "\images\WeakBase\WTower\Lv2.png"
	$WeakBaseWTowerImages[2] = @ScriptDir & "\images\WeakBase\WTower\Lv3.png"
	$WeakBaseWTowerImages[3] = @ScriptDir & "\images\WeakBase\WTower\Lv4.png"
	$WeakBaseWTowerImages[4] = @ScriptDir & "\images\WeakBase\WTower\Lv5.png"
	$WeakBaseWTowerImages[5] = @ScriptDir & "\images\WeakBase\WTower\Lv6.png"
	$WeakBaseWTowerImages[6] = @ScriptDir & "\images\WeakBase\WTower\Lv7.png"
	$WeakBaseWTowerImages[7] = @ScriptDir & "\images\WeakBase\WTower\Lv8.png"
	$WeakBaseWTowerImages[8] = @ScriptDir & "\images\WeakBase\WTower\Lv9.png"

	If $iCmbWeakWizTower[$pMode] > 0 And $iCmbWeakWizTower[$pMode] < 9 Then
		For $i = $iCmbWeakWizTower[$pMode] To 8
			If FileExists($WeakBaseWTowerImages[$i]) Then
				Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hBitmapFirst, "str", $WeakBaseWTowerImages[$i], "float", $aToleranceImg[$i], "str", $DefaultCocSearchArea, "str", $DefaultCocDiamond)
				If IsArray($res) Then
					If $debugsetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
					If $res[0] = "0" Then
						; failed to find a Mortar on the field
						If $debugsetlog = 1 Then SetLog("No Wizard Tower found for that level:" & $i + 1, $COLOR_PURPLE)
						$WeakBaseWTowerLoc = 0
					ElseIf $res[0] = "-1" Then
						SetLog("DLL inside Error", $COLOR_RED)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
					Else
						$expRet = StringSplit($res[0], "|", 2)
						For $j = 1 To UBound($expRet) - 1 Step 2
							$WeakBaseWTowerX = Int($expRet[$j])
							$WeakBaseWTowerY = Int($expRet[$j + 1])
							$WeakBaseWTowerLoc = 1
							$ImageInfo1 = String("WTowerLv_" & $i + 1 & "-" & $t)
							If $debugsetlog = 1 Then SetLog("Found Wizard Tower Lv" & $i + 1 & " (" & $WeakBaseWTowerX & "/" & $WeakBaseWTowerY & ")", $COLOR_RED)
							If $debugsetlog = 1 Then SetLog("Is Not a weak Base!..", $COLOR_RED)
							ExitLoop (2)
						Next
					EndIf
				EndIf
			EndIf
		Next
	Else
		$WeakBaseWTowerLoc = 0
	EndIf

	If $debugsetlog = 1 Then SetLog("  - Calculated  in: " & Round(TimerDiff($hWeakTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	Local $WeakTimer = String(Round(TimerDiff($hWeakTimer) / 1000, 2) & " seconds")

	If $WeakBaseWTowerLoc = 0 And $WeakBaseMortarLoc = 0 Then
		Return True
	Else
		CaptureStrongBasewithInfo($WeakBaseMortarX, $WeakBaseMortarY, $WeakBaseWTowerX, $WeakBaseWTowerY, $ImageInfo, $ImageInfo1, $WeakTimer)
		Return False
	EndIf

EndFunc   ;==>IsWeakBase


Func CaptureStrongBasewithInfo($WeakBaseMortarX, $WeakBaseMortarY, $WeakBaseWTowerX, $WeakBaseWTowerY, $ImageInfo, $ImageInfo1, $WeakTimer)
	Local $EditedImage
	_CaptureRegion()

	$EditedImage = $hBitmap

	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ;create a pencil Color FF0000/RED

	_GDIPlus_GraphicsDrawRect($hGraphic, $WeakBaseMortarX - 5, $WeakBaseMortarY - 5, 10, 10, $hPen)
	_GDIPlus_GraphicsDrawRect($hGraphic, $WeakBaseWTowerX - 5, $WeakBaseWTowerY - 5, 10, 10, $hPen)
	_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, 401, 63, "Arial", 15)
	_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo1, 401, 105, "Arial", 15)
	_GDIPlus_GraphicsDrawString($hGraphic, $WeakTimer, 401, 125, "Arial", 15)

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = String("StrongBaseDetected_" & $Date & "_" & $Time & "_" & $ImageInfo & ".png")

	If $debugBuildingPos = 1 And $debugsetlog = 1 Then Setlog(" _GDIPlus_ImageSaveToFile", $COLOR_PURPLE)
	Local $savefolder = $dirTempDebug & "StrongBaseDetected_" & "\"
	DirCreate($savefolder)
	_GDIPlus_ImageSaveToFile($EditedImage, $savefolder & $filename)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)

EndFunc   ;==>CaptureStrongBasewithInfo


Func SearchLimit($iSkipped)
	If $iChkRestartSearchLimit = 1 And $iSkipped >= Number($iRestartSearchlimit) Then
		Local $Wcount = 0
		While _CheckPixel($aSurrenderButton, $bCapturePixel) = False
			If _Sleep($iDelaySWHTSearchLimit1) Then Return
			$Wcount += 1
			If $debugsetlog = 1 Then setlog("wait surrender button " & $Wcount, $COLOR_PURPLE)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$Is_ClientSyncError = False ; reset OOS flag for long restart
				$Restart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		$Is_SearchLimit = True
		ReturnHome(False, False) ;If End battle is available
		$Restart = True ; set force runbot restart flag
		$Is_ClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit
