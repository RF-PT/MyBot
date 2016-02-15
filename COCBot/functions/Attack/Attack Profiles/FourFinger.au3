; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchFourFinger
; Description ...:
; Syntax ........: LaunchFourFinger($listInfoDeploy, $CC, $King, $Queen, $Warden[, $overrideSmartDeploy = -1])
; Parameters ....: $listInfoDeploy      - Troop deployment array.
;                  $CC                  - Clan Castle.
;                  $King                - Barbarian King.
;                  $Queen               - Archer Queen.
;                  $Warden              - Warden.
;                  $overrideSmartDeploy - [optional] Specifies whether to override Smart Deploy settings.
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func FourFingerDropOnEdge($troop, $edge, $number, $slotsPerEdge = 0, $edge2 = -1, $x = -1)
	Local $minX, $maxX, $minY, $maxY, $minXTL, $maxXTL, $minYTL, $maxYTL
	Local $minX2, $maxX2, $minY2, $maxY2, $minX2TR, $maxX2TR, $minY2TR, $maxY2TR
	Local $posX, $posY, $posX2, $posY2
	Local $nbtroopPerSlot, $nbTroopsLeft

	If isProblemAffect(True) Then Return
	If $number = 0 Then Return
	If _Sleep($iDelayDropOnEdge1) Then Return

	SelectDropTroop($troop) ;Select Troop
	If _Sleep($iDelayDropOnEdge2) Then Return

	If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number

	If $slotsPerEdge = 2 Then
		Local $half = Ceiling($number / 2)

		Click($edge[1][0], $edge[1][1], $half, 0, "#0104")
		If $edge2 <> -1 Then
			If _Sleep(SetSleep(0)) Then Return
			Click($edge2[1][0], $edge2[1][1], $half, 0, "#0105")
		EndIf
		If _Sleep(SetSleep(0)) Then Return

		Click($edge[3][0], $edge[3][1], $number - $half, 0, "#0106")
		If $edge2 <> -1 Then
			If _Sleep(SetSleep(0)) Then Return
			Click($edge2[3][0], $edge2[3][1], $number - $half, 0, "#0107")
		EndIf
		If _Sleep(SetSleep(0)) Then Return
	Else
		$minX = $edge[0][0]
		$maxX = $edge[4][0]
		$minY = $edge[0][1]
		$maxY = $edge[4][1]
		$minXTL = $TopLeft[0][0]
		$maxXTL = $TopLeft[4][0]
		$minYTL = $TopLeft[0][1]
		$maxYTL = $TopLeft[4][1]

		If $edge2 <> -1 Then
			$minX2 = $edge2[0][0]
			$maxX2 = $edge2[4][0]
			$minY2 = $edge2[0][1]
			$maxY2 = $edge2[4][1]
			$minX2TR = $TopRight[0][0]
			$maxX2TR = $TopRight[4][0]
			$minY2TR = $TopRight[0][1]
			$maxY2TR = $TopRight[4][1]
		EndIf

		$nbTroopsLeft = $number

		For $i = 0 To $slotsPerEdge - 1
			$nbtroopPerSlot = Round($nbTroopsLeft / ($slotsPerEdge - $i)) ; progressively adapt the number of drops to fill at the best

			$posX = $minX + (($maxX - $minX) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
			$posY = $minY + (($maxY - $minY) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
			Click($posX, $posY, $nbtroopPerSlot, 0, "#0108")

			$posX = $minXTL + (($maxXTL - $minXTL) * $i) / ($slotsPerEdge - 1)
			$posY = $minYTL + (($maxYTL - $minYTL) * $i) / ($slotsPerEdge - 1)
			Click($posX, $posY, $nbtroopPerSlot, 0, "#0108")

			If $edge2 <> -1 Then
				$posX2 = $maxX2 - (($maxX2 - $minX2) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
				$posY2 = $maxY2 - (($maxY2 - $minY2) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
				Click($posX2, $posY2, $nbtroopPerSlot, 0, "#0109")

				$posX2 = $maxX2TR - (($maxX2TR - $minX2TR) * $i) / ($slotsPerEdge - 1)
				$posY2 = $maxY2TR - (($maxY2TR - $minY2TR) * $i) / ($slotsPerEdge - 1)
				Click($posX2, $posY2, $nbtroopPerSlot, 0, "#0109")
			EndIf

			$nbTroopsLeft -= $nbtroopPerSlot

			If $iCmbUnitDelay[$iMatchMode] <> 0 Then
				If _Sleep(SetSleep(0)) Then Return
			EndIf
		Next
	EndIf
EndFunc   ;==>FourFingerDropOnEdge

Func FourFingerDropOnEdges($troop, $nbSides, $number, $slotsPerEdge = 0)
	Local $nbTroopsLeft = $number
	Local $nbTroopsPerEdge

	If $slotsPerEdge = 2 Then
		For $i = 0 To $nbSides - 4
			$nbTroopsPerEdge = Round($nbTroopsLeft / (($nbSides - 1) - $i * 2))
			$nbTroopsLeft -= $nbTroopsPerEdge * 2

			FourFingerDropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 2], $i)
		Next
	Else
		For $i = 0 To $nbSides - 5
			$nbTroopsPerEdge = Round($nbTroopsLeft / (($nbSides - 1) - $i * 2))
			$nbTroopsLeft -= $nbTroopsPerEdge

			FourFingerDropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 2], $i)
		Next
	EndIf

	Return True
EndFunc   ;==>FourFingerDropOnEdges

Func LaunchFourFinger($listInfoDeploy, $CC, $King, $Queen, $Warden, $overrideSmartDeploy = -1)
	Local $RandomEdge, $RandomXY

	If $debugSetLog = 1 Then SetLog("Launch Four Finger with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

	For $i = 0 To UBound($listInfoDeploy) - 1
		If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES")) Then
			$RandomEdge = $Edges[Round(Random(0, 3))]
			$RandomXY = Round(Random(0, 4))

			If ($listInfoDeploy[$i][0] = "CC") Then
				dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $CC)
			ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
				dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $King, $Queen, $Warden)
			EndIf
		Else
			If LaunchTroops($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4], $overrideSmartDeploy) Then
				If _Sleep(SetSleep(1)) Then Return
			EndIf
		EndIf
	Next

	Return True
EndFunc   ;==>LaunchFourFinger
