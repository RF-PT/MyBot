Func modDropTroop($troop, $nbSides, $number, $slotsPerEdge = 0, $indexToAttack = -1, $overrideSmartDeploy = -1)
	If isProblemAffect(True) Then Return

	$nameFunc = "[modDropTroop]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / nbSides : [" & $nbSides & "] / number : [" & $number & "] / slotsPerEdge [" & $slotsPerEdge & "]")

	If ($iChkRedArea[$iMatchMode]) And $overrideSmartDeploy = -1 Then
		If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number
		If _Sleep($iDelayDropTroop1) Then Return
		SelectDropTroop($troop) ;Select Troop
		If _Sleep($iDelayDropTroop2) Then Return

		If $nbSides < 1 Then Return
		Local $nbTroopsLeft = $number
		If ($iChkSmartAttack[$iMatchMode][0] = 0 And $iChkSmartAttack[$iMatchMode][1] = 0 And $iChkSmartAttack[$iMatchMode][2] = 0) Then
			If $nbSides = 4 Then
				Local $edgesPixelToDrop = GetPixelDropTroop($troop, $number, $slotsPerEdge)

				For $i = 0 To $nbSides - 3
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $listEdgesPixelToDrop[2] = [$edgesPixelToDrop[$i], $edgesPixelToDrop[$i + 2]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				Next
				Return
			EndIf

			For $i = 0 To $nbSides - 1
				If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $edgesPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[1] = [$edgesPixelToDrop[$i]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge
				ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $edgesPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[2] = [$edgesPixelToDrop[$i + 3], $edgesPixelToDrop[$i + 1]]

					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				EndIf
			Next
		Else
			Local $listEdgesPixelToDrop[0]
			If ($indexToAttack <> -1) Then
				Local $nbTroopsPerEdge = $number
				Local $maxElementNearCollector = $indexToAttack
				Local $startIndex = $indexToAttack
			Else
				Local $nbTroopsPerEdge = Round($number / UBound($PixelNearCollector))
				Local $maxElementNearCollector = UBound($PixelNearCollector) - 1
				Local $startIndex = 0
			EndIf
			If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
			For $i = $startIndex To $maxElementNearCollector
				$pixel = $PixelNearCollector[$i]
				ReDim $listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) + 1]
				If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini or $troop = $eBarb) Then
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($PixelRedAreaFurther, $pixel, 5)
				Else
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($PixelRedArea, $pixel, 5)
				EndIf
			Next
			DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)

		EndIf
	Else
		If $nbSides = 5 Then
			FourFingerDropOnEdges($troop, $nbSides, $number, $slotsPerEdge)
		Else
			DropOnEdges($troop, $nbSides, $number, $slotsPerEdge)
		EndIf
	EndIf

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>modDropTroop

Func getWaveName($numWave = 1, $maxWave = -1)
	Local $waveName

	If $numWave = $maxWave And $maxWave = 1 Then
		$waveName = "only"
	ElseIF $numWave = $maxWave Or $maxWave = -1 Then
		$waveName = "last"
	Else
		Switch $numWave
			Case 1
				$waveName = "first"
			Case 2
				$waveName = "second"
			Case 3
				$waveName = "third"
			Case Else
				$waveName = "next"
		EndSwitch
	EndIf

	Return $waveName
EndFunc   ;==>getWaveName

Func LaunchTroops($kind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0, $overrideSmartDeploy = -1)
	Local $troop = unitLocation($kind)
	Local $troopNb = Ceiling(unitCount($kind) / $maxWaveNb)
	Local $name = getTranslatedTroopName($kind)

	If ($troop = -1) Or ($troopNb = 0) Then ; Troop not trained or 0 units to deploy
		Return False; nothing to do => skip this wave
	EndIf

	SetLog("Dropping " & getWaveName($waveNb, $maxWaveNb) & " wave of " & $troopNb & " " & $name, $COLOR_GREEN)
	modDropTroop($troop, $nbSides, $troopNb, $slotsPerEdge, -1, $overrideSmartDeploy)

	Return True
EndFunc   ;==>LaunchTroops

Func LaunchStandard($listInfoDeploy, $CC, $King, $Queen, $Warden, $overrideSmartDeploy = -1)
	Local $listListInfoDeployTroopPixel[0]

	Local $isCCDropped = False
	Local $isHeroesDropped = False

	Local $troop = -1
	Local $troopNb = 0
	Local $name = ""

	If $debugSetlog = 1 Then SetLog("Launch Standard Attack with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

	If ($iChkRedArea[$iMatchMode]) Then
		For $i = 0 To UBound($listInfoDeploy) - 1
			$troopKind = $listInfoDeploy[$i][0]
			$nbSides = $listInfoDeploy[$i][1]
			$waveNb = $listInfoDeploy[$i][2]
			$maxWaveNb = $listInfoDeploy[$i][3]
			$slotsPerEdge = $listInfoDeploy[$i][4]
			$troop = -1
			$troopNb = 0
			$name = ""

			If $debugSetlog = 1 Then SetLog("**ListInfoDeploy row " & $i & ": USE "  &$troopKind & " SIDES " &  $nbSides & " WAVE " & $waveNb & " XWAVE " & $maxWaveNb & " SLOTXEDGE " & $slotsPerEdge, $COLOR_PURPLE)

			If (IsNumber($troopKind)) Then
				$troop = unitLocation($troopKind)
				$troopNb = Ceiling(unitCount($troopKind) / $maxWaveNb)
				$name = getTranslatedTroopName($troopKind)
			EndIf

			If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
				Local $listInfoDeployTroopPixel

				If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
					ReDim $listListInfoDeployTroopPixel[$waveNb]
					Local $newListInfoDeployTroopPixel[0]
					$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
				EndIf
				$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

				ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
				If (IsString($troopKind)) Then
					Local $arrCCorHeroes[1] = [$troopKind]
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
				Else
					Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
				EndIf
				$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
			EndIf
		Next

		If (($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) And UBound($PixelNearCollector) = 0) Then
			SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf

		If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
					Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
					If (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
						If Ubound($PixelRedArea) > 0 Then
							Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1, 1)]
						Else
							Local $pixelRandomDrop = [747, 367] ;
						EndIf

						If ($infoPixelDropTroop[0] = "CC") Then
							dropCC($pixelRandomDrop[0], $pixelRandomDrop[1], $CC)
						ElseIf ($infoPixelDropTroop[0] = "HEROES") Then
							dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
							$isHeroesDropped = True
						EndIf
					Else
						If _Sleep($iDelayLaunchTroop21) Then Return

						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop

						If _Sleep($iDelayLaunchTroop21) Then Return

						SetLog("Dropping " & getWaveName($numWave) & " wave of " & $infoPixelDropTroop[5] & " " & $infoPixelDropTroop[4], $COLOR_GREEN)

						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], $infoPixelDropTroop[2], $infoPixelDropTroop[3])
					EndIf
					If ($isHeroesDropped) Then
						If _Sleep($iDelayLaunchTroop22) then return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
						CheckHeroesHealth()
					EndIf
					If _Sleep(SetSleep(1)) Then Return
				Next
			Next
		Else
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If (UBound($listInfoDeployTroopPixel) > 0) Then
					Local $infoTroopListArrPixel = $listInfoDeployTroopPixel[0]
					Local $numberSidesDropTroop = 1

					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						$infoTroopListArrPixel = $listInfoDeployTroopPixel[$i]
						If (UBound($infoTroopListArrPixel) > 1) Then
							Local $infoListArrPixel = $infoTroopListArrPixel[1]
							$numberSidesDropTroop = UBound($infoListArrPixel)
							ExitLoop
						EndIf
					Next

					If ($numberSidesDropTroop > 0) Then
						For $i = 0 To $numberSidesDropTroop - 1
							For $j = 0 To UBound($listInfoDeployTroopPixel) - 1
								$infoTroopListArrPixel = $listInfoDeployTroopPixel[$j]
								If (IsString($infoTroopListArrPixel[0]) And ($infoTroopListArrPixel[0] = "CC" Or $infoTroopListArrPixel[0] = "HEROES")) Then
									If Ubound($PixelRedArea) > 0 Then
										Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1, 1)]
									Else
										Local $pixelRandomDrop = [747, 367] ;
									EndIf

									If ($isCCDropped = False And $infoTroopListArrPixel[0] = "CC") Then
										dropCC($pixelRandomDrop[0], $pixelRandomDrop[1], $CC)
										$isCCDropped = True
									ElseIf ($isHeroesDropped = False And $infoTroopListArrPixel[0] = "HEROES" And $i = $numberSidesDropTroop - 1) Then
										dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
										$isHeroesDropped = True
									EndIf
								Else
									$infoListArrPixel = $infoTroopListArrPixel[1]
									$listPixel = $infoListArrPixel[$i]
									;infoPixelDropTroop : First element in array contains troop and list of array to drop troop
									If _Sleep($iDelayLaunchTroop21) Then Return
									SelectDropTroop($infoTroopListArrPixel[0]) ;Select Troop
									If _Sleep($iDelayLaunchTroop23) Then Return
									SetLog("Dropping " & $infoTroopListArrPixel[2] & "  of " & $infoTroopListArrPixel[5] & " => on each side (side : " & $i + 1 & ")", $COLOR_GREEN)
									Local $pixelDropTroop[1] = [$listPixel]
									DropOnPixel($infoTroopListArrPixel[0], $pixelDropTroop, $infoTroopListArrPixel[2], $infoTroopListArrPixel[3])
								EndIf
								If ($isHeroesDropped) Then
									If _sleep (1000) then return ; delay Queen Image has to be at maximum size : CheckHeroesHealth checks the y = 573
									CheckHeroesHealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return
			Next
		EndIf

		For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
			Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
			For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
				Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
				If Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
					Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
					;SetLog("NumberLeft : " & $numberLeft)
					If ($numberLeft > 0) Then
						If _Sleep($iDelayLaunchTroop21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($iDelayLaunchTroop23) Then Return
						SetLog("Dropping last " & $numberLeft & "  of " & $infoPixelDropTroop[5], $COLOR_GREEN)

						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
					EndIf
				EndIf
			Next
		Next
	Else
		For $i = 0 To UBound($listInfoDeploy) - 1
			If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES")) Then
				Local $RandomEdge = $Edges[Round(Random(0, 3))]
				Local $RandomXY = Round(Random(0, 4))

				If ($listInfoDeploy[$i][0] = "CC") Then
					dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $CC)
				ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
					dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $King, $Queen,$Warden)
				EndIf
			Else
				If LaunchTroops($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4], $overrideSmartDeploy) Then
					If _Sleep(SetSleep(1)) Then Return
				EndIf
			EndIf
		Next
	EndIf

	Return True
EndFunc   ;==>LaunchStandard
