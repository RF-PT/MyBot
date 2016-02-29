; #FUNCTION# ====================================================================================================================
; Name ..........: Train
; Description ...: This train function is only to train the donated troops and when is not to attack (Scheduler)!
; Syntax ........: Train2()
; Parameters ....:
; Return values .: None
; Author ........: Hungle
; Modified ......: N2Delay ( 03/2016)
; Remarks .......:
; Related .......: IsNotToAttack()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func Train2()

	VillageReport(True, True)
	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$tempElixir = $iElixirCurrent
	$tempDElixir = $iDarkCurrent

	SetLog("Training Troops & Spells Donated only!", $COLOR_BLUE)
	If _Sleep($iDelayTrain1) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep($iDelayTrain4) Then Return

	;OPEN ARMY OVERVIEW WITH NEW BUTTON
	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $debugSetlog = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If IsMainPage() Then Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open  ; é só de 100ms é muito pouco
	$i = 0
	While Not IsTrainPage() ; vai fazer um loop até que esteja na pagina de treino ou então até o $i ser 20
		If _Sleep($iDelayRunBot3) Then Return ; $iDelayRunBot3 = 200ms
		$i += 1
		If $i = 20 Then ExitLoop
	WEnd

	If Not (IsTrainPage()) Then Return ; se realmente aconteceu alguma coisa e não esta na pagina de treino então sai da função
	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
	; CHECK IF NEED TO MAKE TROOPS
	; Verify the Global variable $TroopName+Comp and return the GUI selected troops by user
	;
	If $isNormalBuild = "" Or $FirstStart Then
		For $i = 0 To UBound($TroopName) - 1
			If Eval($TroopName[$i] & "Comp") <> "0" Then
				$isNormalBuild = True
			EndIf
		Next
	EndIf
	If $isNormalBuild = "" Then
		$isNormalBuild = False
	EndIf
	If $debugSetlog = 1 Then SetLog("Train: need to make normal troops: " & $isNormalBuild, $COLOR_PURPLE)

	; CHECK IF NEED TO MAKE DARK TROOPS
	; Verify the Global variable $TroopDarkName+Comp and return the GUI selected troops by user
	;
	If $isDarkBuild = "" Or $FirstStart Then
		For $i = 0 To UBound($TroopDarkName) - 1
			If Eval($TroopDarkName[$i] & "Comp") <> "0" Then
				$isDarkBuild = True
			EndIf
		Next
	EndIf
	If $isDarkBuild = "" Or $icmbDarkTroopComp = 2 Then
		$isDarkBuild = False
	EndIf
	If $debugSetlog = 1 Then SetLog("Train: need to make dark troops: " & $isDarkBuild, $COLOR_PURPLE)

	; GO TO First NORMAL BARRACK
	; Find First barrack $i
	Local $Firstbarrack = 0, $i = 1
	While $Firstbarrack = 0 And $i <= 4
		If $Trainavailable[$i] = 1 Then $Firstbarrack = $i
		$i += 1
	WEnd

	If $Firstbarrack = 0 Then
		Setlog("No barrack avaiable, cannot start train")
		Return ;exit from train
	Else
		If $debugSetlog = 1 Then Setlog("First BARRACK = " & $Firstbarrack, $COLOR_PURPLE)
		;GO TO First BARRACK
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugSetlog = 1 Then Setlog("OverView TabColor=" & _GetPixelColor($btnpos[0][0], $btnpos[0][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayTrain1) Then Return ; wait for Train Window to be ready.
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("Training Overview Window didn't open", $COLOR_RED)
			Return
		EndIf
		If Not (IsTrainPage()) Then Return ;exit if no train page
		Click($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], 1, $iDelayTrain5, "#0336") ; Click on tab and go to last barrack
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugSetlog = 1 Then Setlog("First Barrack TabColor=" & _GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayTrain1) Then Return
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("some error occurred, cannot open barrack", $COLOR_RED)
		EndIf
	EndIf

	$brrNum = 0
	If ($icmbTroopComp = 8 and $isDarkBuild = false) or ($icmbTroopComp = 8 and $icmbDarkTroopComp = 0)  Then
		If $debugSetlog = 1 Then
			Setlog("", $COLOR_PURPLE)
			SetLog("---------TRAIN BARRACK MODE------------------------", $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayTrain2) Then Return
		;USE BARRACK
		While isBarrack()
			$brrNum += 1
			If _Sleep($iDelayTrain2) Then ExitLoop
			If Not (IsTrainPage()) Then Return ; exit from train if no train page
			Switch $barrackTroop[$brrNum - 1]
				Case 0
					TrainClick(220, 320 + $midOffsetY, 75, 10, $FullBarb, $GemBarb, "#0274") ; Barbarian
				Case 1
					TrainClick(331, 320 + $midOffsetY, 75, 10, $FullArch, $GemArch, "#0275") ; Archer
				Case 2
					TrainClick(432, 320 + $midOffsetY, 15, 10, $FullGiant, $GemGiant, "#0276") ; Giant
				Case 3
					TrainClick(546, 320 + $midOffsetY, 75, 10, $FullGobl, $GemGobl, "#0277") ; Goblin
				Case 4
					TrainClick(647, 320 + $midOffsetY, 37, 10, $FullWall, $GemWall, "#0278") ; Wall Breaker
				Case 5
					TrainClick(220, 425 + $midOffsetY, 15, 10, $FullBall, $GemBall, "#0279") ; Balloon
				Case 6
					TrainClick(331, 425 + $midOffsetY, 18, 10, $FullWiza, $GemWiza, "#0280") ; Wizard
				Case 7
					TrainClick(432, 425 + $midOffsetY, 5, 10, $FullHeal, $GemHeal, "#0281") ; Healer
				Case 8
					TrainClick(546, 425 + $midOffsetY, 3, 10, $FullDrag, $GemDrag, "#0282") ; Dragon
				Case 9
					TrainClick(647, 425 + $midOffsetY, 3, 10, $FullPekk, $GemPekk, "#0283") ; Pekka
			EndSwitch
			If $OutOfElixir = 1 Then
				Setlog("Not enough Elixir to train troops!", $COLOR_RED)
				Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_RED)
				$ichkBotStop = 1 ; set halt attack variable
				$icmbBotCond = 18 ; set stay online
				If CheckFullBarrack() Then $Restart = True ;If the army camp is full, use it to refill storages
				Return ; We are out of Elixir stop training.
			EndIf
			If _Sleep($iDelayTrain2) Then ExitLoop
			If Not (IsTrainPage()) Then Return
			If $brrNum >= $numBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
			_TrainMoveBtn(+1) ;click Next button
			If _Sleep($iDelayTrain3) Then ExitLoop
		WEnd
		;$isNormalBuild = False
	Else
		If $debugSetlog = 1 Then SetLog("---------TRAIN NEW BARRACK MODE------------------------", $COLOR_PURPLE)
		If $FirstStartIsNotAttack = True Then SetLog("Remove previous training troops and make only the donations!!")

		While isBarrack() And $isNormalBuild
			$brrNum += 1
			If $FirstStartIsNotAttack = True Then
				;CLICK REMOVE TROOPS
				If _Sleep($iDelayTrain2) Then Return
				$icount = 0
				If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
					While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
						_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
						$icount += 1
						If _Sleep($iDelayTrain2) Then Return
						If $icount = 7 Then ExitLoop
					WEnd
				EndIf
				$icount = 0
				While Not _ColorCheck(_GetPixelColor(593, 200 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
					If Not (IsTrainPage()) Then Return ;exit if no train page
					Click(568, 177 + $midOffsetY, 10, 0, "#0284") ; Remove Troops in training
					$icount += 1
					If $icount = 100 Then ExitLoop
				WEnd
				If $debugSetlog = 1 And $icount = 100 Then SetLog("Train warning 7", $COLOR_PURPLE)
			EndIf

			If $debugSetlog = 1 Then SetLog("====== Checking available Barrack: " & $brrNum & " ======", $COLOR_PURPLE)
			If _Sleep($iDelayTrain1) Then ExitLoop
			;####################### Train the Donated Troops #########################
			If $LastBarrackTrainDonatedTroop = $brrNum Then
				For $i = 0 To UBound($TroopName) - 1
					If Eval("Don" & $TroopName[$i]) > 0 Then
						; train one $TroopName each barrack/each loop until the quantity is zero. Train it in Barrack 1|2|3|4|1|2 next 3|4|1|2|3|4
						TrainIt(Eval("e" & $TroopName[$i]), 1)
						Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) - 1)
						If $debugSetlog = 1 Then Setlog("Train 1 " & NameOfTroop(Eval("e" & $TroopName[$i])) & " remain " & Eval("Don" & $TroopName[$i]) & " to train.")
						$LastBarrackTrainDonatedTroop = $brrNum + 1
						If $LastBarrackTrainDonatedTroop > $numBarracksAvaiables Then
							$LastBarrackTrainDonatedTroop = 1
						EndIf
					EndIf
				Next
				If $debugSetlog = 1 Then Setlog("$LastBarrackTrainDonatedTroop: " & $LastBarrackTrainDonatedTroop)
				If $debugSetlog = 1 Then Setlog("Barrack: " & $brrNum)
			EndIf

			;###########################################################################
			If Not (IsTrainPage()) Then Return
			If $brrNum >= $numBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
			_TrainMoveBtn(+1) ;click Next button
			If _Sleep($iDelayTrain2) Then Return
		WEnd
		$isNormalBuild = False
	EndIf

	If $isDarkBuild Or $icmbDarkTroopComp = 0 Then
		$iBarrHere = 0
		$brrDarkNum = 0
		If $icmbDarkTroopComp = 0 Then
			If $debugSetlog = 1 Then
				Setlog("", $COLOR_PURPLE)
				SetLog("---------TRAIN DARK BARRACK MODE------------------------", $COLOR_PURPLE)
			EndIf
			If _Sleep($iDelayTrain2) Then Return
			;USE BARRACK
			While isDarkBarrack() = False
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If _Sleep($iDelayTrain3) Then Return
				If (isDarkBarrack() Or $iBarrHere = 8) Then ExitLoop
			WEnd
			While isDarkBarrack()
				$brrDarkNum += 1
				If _Sleep($iDelayTrain2) Then ExitLoop
				If Not (IsTrainPage()) Then Return ; exit from train if no train page
				Switch $darkbarrackTroop[$brrDarkNum - 1]
					Case 0
						TrainClick(220, 320 + $midOffsetY, 45, 10, $FullMini, $GemMini, "#0274") ; Minion
					Case 1
						TrainClick(331, 320 + $midOffsetY, 18, 10, $FullHogs, $GemHogs, "#0275") ; Hog Rider
					Case 2
						TrainClick(432, 320 + $midOffsetY, 12, 10, $FullValk, $GemValk, "#0276") ; Valkyrie
					Case 3
						TrainClick(546, 320 + $midOffsetY, 3, 10, $FullGole, $GemGole, "#0277") ; Golem
					Case 4
						TrainClick(647, 320 + $midOffsetY, 8, 10, $FullWitc, $GemWitc, "#0278") ; Witch
					Case 5
						TrainClick(220, 425 + $midOffsetY, 3, 10, $FullBall, $GemBall, "#0279") ; Lava Hound
				EndSwitch
				If $OutOfElixir = 1 Then
					Setlog("Not enough Dark Elixir to train troops!", $COLOR_RED)
					Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_RED)
					$ichkBotStop = 1 ; set halt attack variable
					$icmbBotCond = 18 ; set stay online
					If CheckFullBarrack() Then $Restart = True ;If the army camp is full, use it to refill storages
					Return ; We are out of Elixir stop training.
				EndIf
				If _Sleep($iDelayTrain2) Then ExitLoop
				If Not (IsTrainPage()) Then Return
				If $brrDarkNum >= $numDarkBarracksAvaiables Then ExitLoop
				_TrainMoveBtn(+1) ;click Next button
				If _Sleep($iDelayTrain3) Then ExitLoop
			WEnd
			$isDarkBuild = False
		Else
			While isDarkBarrack() = False
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If _Sleep($iDelayTrain3) Then Return
				If (isDarkBarrack() Or $iBarrHere = 8) Then ExitLoop
			WEnd
			While isDarkBarrack()
				$brrDarkNum += 1
				If $FirstStartIsNotAttack = True Then
					If _Sleep($iDelayTrain2) Then Return
					$icount = 0
					If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
						While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
							_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
							$icount += 1
							If _Sleep($iDelayTrain2) Then Return
							If $icount = 7 Then ExitLoop
						WEnd
					EndIf
					$icount = 0
					While Not _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
						If Not (IsTrainPage()) Then Return
						Click(568, 177 + $midOffsetY, 10, 0, "#0273") ; Remove Troops in training
						$icount += 1
						If $icount = 100 Then ExitLoop
					WEnd
					If $debugSetlog = 1 And $icount = 100 Then SetLog("Train warning 6", $COLOR_PURPLE)
				EndIf


				If $debugSetlog = 1 Then SetLog("====== Checking available Dark Barrack: " & $brrDarkNum & " ======", $COLOR_PURPLE)
				If _Sleep($iDelayTrain1) Then ExitLoop
				;####################### Train the Donated Troops #########################
				If $LastDarkBarrackTrainDonatedTroop = $brrDarkNum Then
					For $i = 0 To UBound($TroopDarkName) - 1
						If Eval("Don" & $TroopDarkName[$i]) > 0 Then
							; train one $TroopDarkName each barrack/each loop until the quantity is zero. Train it in Barrack 1|2| next 1|2|
							TrainIt(Eval("e" & $TroopDarkName[$i]), 1)
							Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) - 1)
							If $debugSetlog = 1 Then Setlog("Train 1 " & NameOfTroop(Eval("e" & $TroopDarkName[$i])) & " remain " & Eval("Don" & $TroopDarkName[$i]) & " to train.")
							$LastDarkBarrackTrainDonatedTroop = $brrDarkNum + 1
							If $LastDarkBarrackTrainDonatedTroop > $numDarkBarracksAvaiables Then
								$LastDarkBarrackTrainDonatedTroop = 1
							EndIf
						EndIf
					Next
					If $debugSetlog = 1 Then Setlog("Dark Barrack: " & $brrDarkNum)
					If $debugSetlog = 1 Then Setlog("$LastDarkBarrackTrainDonatedTroop: " & $LastDarkBarrackTrainDonatedTroop)
				EndIf
				;#########################################################################
				If Not (IsTrainPage()) Then Return
				$icount = 0
				If $brrDarkNum >= $numDarkBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
				_TrainMoveBtn(+1) ;click Next button
				If _Sleep($iDelayTrain2) Then ExitLoop
			WEnd
			$isDarkBuild = False
		EndIf
	EndIf

	If $debugSetlog = 1 Then SetLog("---=====================END TRAIN =======================================---", $COLOR_PURPLE)
	If _Sleep($iDelayTrain4) Then Return
	BrewSpells() ; Create Spells
	If _Sleep($iDelayTrain4) Then Return
	ClickP($aAway, 2, $iDelayTrain5, "#0504"); Click away twice with 250ms delay
	$FirstStart = False
	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep($iDelayTrain4) Then Return
	VillageReport(True, True)
	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 30
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
	EndIf
	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirSpent = ($tempDElixir - $iDarkCurrent)
		$iTrainCostDElixir += $tempDElixirSpent
		$iDarkTotal -= $tempDElixirSpent
	EndIf

	$FirstStartIsNotAttack = False
	UpdateStats()

EndFunc   ;==>Train2
