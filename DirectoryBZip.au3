#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Spacetech

 Script Function:
	Directory BZip

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Include <File.au3>
#Include <Array.au3>

$RanDirectories = 0
$TotalDirectories = 0
$BZipExe = @ScriptDir & "\bzip.exe"

If(Not FileExists($BZipExe)) Then
	Exit
EndIf

local $Path = @ScriptDir
Local $DirLength = StringLen($Path) + 1

Func BZip($File)
	$FilePath = StringTrimLeft($File, $DirLength)
	If(Not StringInStr($FilePath, "svn") And Not StringInStr($FilePath, "exe") And Not StringInStr($FilePath, "au3")) Then
		RunWait($BZipExe & " -k -z " & $FilePath & "\*.*", "", @SW_HIDE)
	EndIf
EndFunc

Func DirListRecursive($SearchPath, $Check = False)
	Local $Directories = _FileListToArray($SearchPath, "*", 2)
	
	If(Not IsArray($Directories)) Then
		Return
	EndIf
	
	If($Check) Then
		$TotalDirectories += $Directories[0]
	EndIf

	For $i=1 To $Directories[0]
		If(Not $Check) Then
			BZip($SearchPath & "\" & $Directories[$i])
			$RanDirectories = $RanDirectories + 1
		EndIf
		ProgressSet(($RanDirectories / $TotalDirectories) * 100, $RanDirectories & " / " & $TotalDirectories)
	Next
	
	For $i=1 To $Directories[0]
		DirListRecursive($SearchPath & "\" & $Directories[$i], $Check)
	Next
EndFunc

ProgressOn("Directory BZip", "Zipping")

DirListRecursive($Path, True)

DirListRecursive($Path)

ProgressOff()

Sleep(1000)

While(1)
	If(Not ProcessExists("bzip.exe")) Then
		MsgBox(64, "DirectoryBZip", "Finished", 10)
		Exit
	EndIf
	Sleep(10)
WEnd
