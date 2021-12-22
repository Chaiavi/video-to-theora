#include <File.au3>

; Handling the commandline executable
Global $commandlineEXE = IniRead(@WorkingDir & "\Video2theora.ini", "Video2theora", "CommandLineFileName", "NotFound")
if $commandlineEXE = "NotFound" then
	$commandlineEXE = findF2TConverter()
	IniWrite(@WorkingDir & "\Video2theora.ini", "Video2theora", "CommandLineFileName", $commandlineEXE)
endif

; Returns the path and actual file of the ffmpeg2theora converting commandline executable 
Func findF2TConverter()
	$ffmpeg2theoraEXE = ''
	$files = _FileListToArray(@WorkingDir, "ffmpeg2theora*.exe", 1)

	if NOT IsArray($files) OR $files[0] < 1 then
		$message = "Please choose the ffmpeg2theora executable file"
		$ffmpeg2theoraEXE = FileOpenDialog($message, @WorkingDir & "", "Executable (*.exe)", 1)
	else
		$ffmpeg2theoraEXE = @WorkingDir & "\" & $files[1]
	endif

	return $ffmpeg2theoraEXE
EndFunc