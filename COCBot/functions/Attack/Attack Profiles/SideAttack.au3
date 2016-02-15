Func LaunchSideAttack($listInfoDeploy, $CC, $King, $Queen, $Warden, $overrideSmartDeploy = -1)
	Local $listListInfoDeployTroopPixel[0]
	Local $barPosition = -1, $earthquakeDropped = 0, $spellCount = 0, $unitCount = 0
	Local $RandomEdge = $Edges[$BuildingEdge], $RandomXY = 2
	Local $kind, $position, $spellPositionString, $positionside
	Local $deployX, $deployY

	If $debugSetLog = 1 Then SetLog("LaunchSideAttackTroop with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

	; $debugSetlog = 1
	Local $aDeployButtonPositions = getUnitLocationArray()
	; $debugSetlog = 0

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$position = Number($listInfoDeploy[$i][4])
		$barPosition = $aDeployButtonPositions[$kind]

		If StringUpper(StringRight($listInfoDeploy[$i][4], 1)) = "R" Then
			$deployX = $RandomEdge[4][0]
			$deployY = $RandomEdge[4][1]
  		    $positionSide = "R"
			$spellPositionString = String($position) & " distance from right corner"
		ElseIf StringUpper(StringRight($listInfoDeploy[$i][4], 1)) = "L" Then
			$deployX = $RandomEdge[0][0]
			$deployY = $RandomEdge[0][1]
  		    $positionSide = "L"
			$spellPositionString = String($position) & " distance from left corner"
		Else
			$deployX = $RandomEdge[$RandomXY][0]
			$deployY = $RandomEdge[$RandomXY][1]
			$spellPositionString = String($position) & " distance from middle"
		EndIf

		If $kind <> $DeDeployEmptyString And $barPosition <> -1 Then
			Switch $kind
				Case $eKing
					dropHeroes($deployX, $deployY, $King, -1, -1)
				Case $eQueen
					dropHeroes($deployX, $deployY, -1, $Queen, -1)
				Case $eWarden
					dropHeroes($deployX, $deployY, -1, -1, $Warden)
				Case $eCastle
					dropCC($deployX,$deployY, $CC)
				Case $eRSpell, $eHSpell, $eJSpell, $eHaSpell, $eFSpell, $ePSpell
					$spellCount = spellCount($kind)

					If $spellCount > 0 Then
						SetLog("Dropping spell " & getTranslatedTroopName($kind) & " at " & $spellPositionString)
						If $BuildingLoc = 1 Then
							;drop spell towards the DE storage
							dropSpell(ceiling((((100 - $position) * $deployX) + ($position * $BuildingLocx)) / 100), _
									  ceiling((((100 - $position) * $deployY) + ($position * $BuildingLocy)) / 100), _
									  $kind)
						Else
							;drop spell towards the center
							dropSpell(ceiling((((100 - $position) * $deployX) + ($position * 430)) / 100), _
									  ceiling((((100 - $position) * $deployY) + ($position * 313)) / 100), _
									  $kind)
						EndIf
					EndIf
				Case $eESpell
					; $debugSetlog = 1
					$spellCount = spellCount($kind)

					If $spellCount >= 4 Then ;4 quakes or go home
						SetLog("Dropping " & getTranslatedTroopName($kind) & " at " & $spellPositionString)

						If $BuildingLoc = 1 Then
							;drop spell towards the DE storage
							dropEarth(ceiling((((100 - $position) * $deployX) + ($position * $BuildingLocx)) / 100), _
									  ceiling((((100 - $position) * $deployY) + ($position * $BuildingLocy)) / 100), _
									  $kind)
						Else
							;drop spell towards the center
							dropEarth(ceiling((((100 - $position) * $deployX)+($position * 430)) / 100), _
									  ceiling((((100 - $position) * $deployY)+($position * 313)) / 100), _
									  $kind)
						EndIf

						$earthquakeDropped = 1
					Else
						If $spellCount > 0 and $spellCount < 4 Then SetLog("Only " & $spellCount & " " & getTranslatedTroopName($kind) & " available.  Waiting for 4.")
					EndIf
					; $debugSetlog = 0
				Case Else
					$unitCount = unitCount($kind)
					If $unitCount > 0 Then
						If $positionside <> "L" and $positionSide <> "R" Then
							If LaunchTroops($kind, $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $position, $overrideSmartDeploy) Then
								If _Sleep(SetSleep(1)) Then Return
							EndIf
						Else
							SetLog("Pixel Dropping " & $kind & " at " & $deployX & "," & $deployY)
							dropUnit($deployX, $deployY, $kind, Ceiling($unitCount / $listInfoDeploy[$i][3]))
						EndIf
					EndIf
			EndSwitch
		Else
			If $position > 0 and $kind = $DeDeployEmptyString Then
				SetLog("Waiting for " & $position & " seconds.")
				If _Sleep(1000*$position) Then Return
			EndIf
		EndIf
	Next

	Return True
EndFunc   ;==>LaunchSideAttackTroop
