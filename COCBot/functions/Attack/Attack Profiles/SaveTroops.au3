Func LaunchSaveTroops($listInfoDeploy, $CC, $King, $Queen, $Warden, $overrideSmartDeploy = -1)
	Local $listListInfoDeployTroopPixel[0]

	$countFindPixCloser = 0
	$countCollectorexposed = 0

	Local $isCCDropped = False
	Local $isHeroesDropped = False

	Local $troop = -1
	Local $troopNb = 0
	Local $name = ""

	If $debugSetlog = 1 Then SetLog("LaunchSaveTroops with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

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

			If $debugSetlog =1 Then SetLog("**ListInfoDeploy row " & $i & ": USE "  &$troopKind & " SIDES " &  $nbSides & " WAVE " & $waveNb & " XWAVE " & $maxWaveNb & " SLOTXEDGE " & $slotsPerEdge, $COLOR_PURPLE)

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

		If $saveTroops = 1 And $useFFBarchST = 1 And ($countCollectorexposed / Ubound($PixelNearCollector)) * 100 < $percentCollectors Then
			Setlog("There are " & $countCollectorexposed & " collector(s) near RED LINE out of " & Ubound($PixelNearCollector) & " collectors")
			SetLog("Change the Attack Strategy to Four Finger...")

			$endbattle = False

			If _Sleep(500) Then Return

			$nbSides = 5

			Local $FFListDeploy = getDeploymentInfo($nbSides, 4)

			LaunchFourFinger($FFListDeploy, $CC, $King, $Queen, $Warden, 1)

			Return True
		Endif

		If (($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) And UBound($PixelNearCollector) = 0) Then
				SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf

		If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
					Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
					If (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
						;TEMP FIX NEED TO IMPROVED... IF NO PIXELREDAREA DEPLOY IN A PRECISE POINT
						;Local $pixelRandomDrop = $PixelRedArea[Round(Random(0, UBound($PixelRedArea) - 1))]
						If Ubound($PixelRedArea) > 0 Then
							Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1,1)]
						Else
							Local $pixelRandomDrop = [747,367] ;
						EndIf
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
									;TEMP FIX NEED TO IMPROVED... IF NO PIXELREDAREA DEPLOY IN A PRECISE POINT
									;Local $pixelRandomDrop = $PixelRedArea[Round(Random(0, UBound($PixelRedArea) - 1))]
									If Ubound($PixelRedArea) > 0 Then
										Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1,1)]
									Else
										Local $pixelRandomDrop = [747,367] ;
									EndIf
									;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
									If _sleep (1000) then return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
									CheckHeroesHealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return
			Next
		EndIf

		If $saveTroops = 1 Then
			$endbattle = False

			Local $TimeWaitSaveColl = 5,$timeSC = 0

			;Activate KQ's power
			useHeroesAbility()

			For $saveWave = 0 to 2
				$timeSC = 0

				If $saveWave <> 0 Then $TimeWaitSaveColl = 3

				While $timeSC < $TimeWaitSaveColl
					If _Sleep(5000) Then Return

					CheckHeroesHealth()
					$timeSC += 1
				Wend

				If _Sleep(150) Then Return

				Local $contMine = False, $contEli = False

				If $contMine And $contEli Then
					SetLog("Checking for remaining gold & elixir collectors...")
				Elseif $contMine Then
					SetLog("Checking for remaining gold collectors...")
				Elseif $contEli Then
					SetLog("Checking for remaining elixir collectors...")
				Endif

				Setlog("Checking for remaining collectors...")

				Local $foundRemainingCollectors = 0
				_WinAPI_DeleteObject($hBitmapFirst)
				$hBitmapFirst = _CaptureRegion2()

				Global $PixelMine[0]
				Global $PixelElixir[0]
				Global $PixelDarkElixir[0]
				Global $PixelNearCollector[0]

				; If drop troop near gold mine
				If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
					$PixelMine = GetLocationMine()

					If (IsArray($PixelMine)) Then
						_ArrayAdd($PixelNearCollector, $PixelMine)
						$foundRemainingCollectors = 1
					EndIf
				EndIf

				; If drop troop near elixir collector
				If ($iChkSmartAttack[$iMatchMode][1] = 1)  Then
					$PixelElixir = GetLocationElixir()

					If (IsArray($PixelElixir)) Then
						_ArrayAdd($PixelNearCollector, $PixelElixir)
						$foundRemainingCollectors = 1
					EndIf
				EndIf

				; If drop troop near dark elixir drill
				If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
					$PixelDarkElixir = GetLocationDarkElixir()
					If (IsArray($PixelDarkElixir)) Then
						_ArrayAdd($PixelNearCollector, $PixelDarkElixir)
						$foundRemainingCollectors = 1
					EndIf
				EndIf

				 $Barb = 0
				 $Arch = 0

			      If $foundRemainingCollectors = 1 Then
					 $Barb = -1
					 For $i = 0 To 11
						If $atkTroops[$i][0] = $eBarb Then
						   $Barb = $i
						EndIf
					 Next
				  EndIf

				  If $foundRemainingCollectors = 1 Then
					 For $i = 0 To 11
						If $atkTroops[$i][0] = $eArch Then
						   $Arch = $i
						EndIf
					 Next
				  EndIf

				If $foundRemainingCollectors = 1 And $Arch = -1 And $Barb = -1 Then
					SetLog("[" & UBound($PixelMine) & "] Gold Mines")
					SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
					SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")

					If $saveWave = 2 Then
						SetLog("Continue attacking with remaining troops...")
						Return True
					Else
						SetLog("Continue attacking...")
					Endif

					Local $TotalArmyNeed = 0 ;required army for remaining collectors, basis 5 bar and 5 arch each

					$TotalArmyNeed=UBound($PixelNearCollector) * 5
				Else
					; if not $contMine then SetLog("Gold resources below requirement. End battle!...")
					; if not $contEli then SetLog("Elixir resources below requirement. End battle!...")
					If Not $foundRemainingCollectors Then SetLog("No remaining collectors. End battle!...")

					$endbattle = True
					Return True
				Endif

				Local $listListInfoDeployTroopPixel[0]
				For $i = 0 To UBound($listInfoDeploy) - 1
					Local $troop = -1
					Local $troopNb = 0
					Local $name = ""

					$troopKind = $listInfoDeploy[$i][0]
					$nbSides = $listInfoDeploy[$i][1]
					$waveNb = $listInfoDeploy[$i][2]
					$maxWaveNb = $listInfoDeploy[$i][3]
					$slotsPerEdge = $listInfoDeploy[$i][4]

					If (IsNumber($troopKind)) Then
						For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
							If $atkTroops[$j][0] = $troopKind Then
								$troop = $j
								$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
								Local $plural = 0

								If $troopNb > 1 Then $plural = 1

								$name = NameOfTroop($troopKind, $plural)
							EndIf
						Next
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

				For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
					Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
						If Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
							Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
							if $numberLeft - $TotalArmyNeed > 0 and $saveWave <> 2 then
								$numberLeft =$TotalArmyNeed
							Endif

							;SetLog("NumberLeft : " & $numberLeft)
							If ($numberLeft > 0) Then
								If _Sleep(100) Then Return

								SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop

								If _Sleep(300) Then Return

								SetLog("Dropping another " & $numberLeft & "  of " & $infoPixelDropTroop[5], $COLOR_GREEN)
								DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
							EndIf
						EndIf
					Next
				Next
			Next
		Else
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
		EndIf
	EndIf

	Return True
EndFunc   ;==>LaunchSaveTroop2
