; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot Theme
; Description ...:
; Syntax ........: GUI Theme
; Parameters ....: None
; Return values .: None
; Author ........: Bushido-21 (2015)
; Modified ......: RF (2016)
; Remarks .......: This file is part of MyBot.Run Copyright 2015
;                  MyBot.run is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func btnLoadTheme()

	Local $sFileOpenDialog = FileOpenDialog("Open theme file", @ScriptDir & "\Themes\", "MS Theme (*.msstyles;)", $FD_FILEMUSTEXIST)

	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "Error opening file!")
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir(@ScriptDir)
		$sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)
		$ThemeConfig = $sFileOpenDialog
	    _USkin_LoadSkin($ThemeConfig)

		writeThemeConfig()
	EndIf
EndFunc   ;==>btnLoadTheme

Func readThemeConfig()
    $ThemeConfig = IniRead(@ScriptDir & "\Themes\skin.ini", "skin", "skin", @ScriptDir & "\skins\dark0.msstyles")
	_USkin_Init($ThemeConfig)
 EndFunc

Func writeThemeConfig()
	IniWrite(@ScriptDir & "\Themes\skin.ini", "skin", "skin", $ThemeConfig)
_SelfRestart()
EndFunc

Func _SelfRestart() ; restart the app

Local $stext, $MsgBox
    _ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = "Restarting The Bot Please wait a Sec...."& @CRLF & @CRLF & "To Take Effect The Changes Of Themes"& @CRLF & @CRLF & "And To Prevent BS Crashing!!!" & @CRLF
	$MsgBox = _ExtMsgBox(48, "OK", "Restarting...", $stext, 10, $frmBot)

    If @Compiled Then
        Run(FileGetShortName(@ScriptFullPath))
    Else
        Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
	Exit
EndFunc   ;==>_SelfRestart
