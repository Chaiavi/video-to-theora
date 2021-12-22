#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>
#include <GuiComboBox.au3>
#include <ButtonConstants.au3>
#include <File.au3>

#include <Array.au3>
#include <Constants.au3>

#include "GUIListViewEx.au3"

Global $array_List ; ArrayList which shadows the ListView

; Creating GUI Elements
Opt("WinTitleMatchMode",2)
#include "Video2TheoraGraphicElements.au3"
; Handling the commandline executable
#include "Video2TheoraGetCLExe.au3"

HotKeySet("{F1}", "onHelp")

; Main Logic
While 1
	Switch GUIGetMsg()
		Case $deleteBtn
			_GUIListViewEx_Delete()
		Case $upBtn
			_GUIListViewEx_Up()
		Case $downBtn
			_GUIListViewEx_Down()
			
		Case $insertBtn, $addVideoMenuItem
		  	onBrowse()
	    Case $convertbtn, $convertMenuItem
			onConvert()
		Case $helpMenuItem
			onHelp()
	    Case $aboutMenuItem
			onAbout()
	    Case $GUI_EVENT_CLOSE, $exitBtn, $exitMenuItem
			Exit
	EndSwitch
WEnd


; Application Specific Functions

; Browses for video file/s to convert and adds them to the list
Func onBrowse()
	; Multiple filter group
   $message 			= "Hold down Ctrl or Shift to choose multiple files."
   $chosenFiles 		= FileOpenDialog($message, @WorkingDir & "", "All Video Formats (*.*)", 1 + 4)
   $video2convertArr 	= StringSplit($chosenFiles, "|")
   
   if StringInStr($chosenFiles, "|") > 0 Then
	  $video2convertArr = StringSplit($chosenFiles, "|")
	  for $i = 2 to $video2convertArr[0]
		 $video2convert = $video2convertArr[1] & "\" & $video2convertArr[$i]
		 if StringLen ($video2convert) > 3 Then
			_GUIListViewEx_Insert($video2convert)
		 EndIf
	  Next
   ElseIf StringLen ($chosenFiles) > 3 Then
	  _GUIListViewEx_Insert($chosenFiles)
   EndIf
EndFunc   ;==>onBrowse

; Iterates over the list and converts all of the video files
Func onConvert()
	$files2convert 		= _GUIListViewEx_Return_Array($listView_index);
	$number_of_videos 	= UBound($files2convert)
   
   if $number_of_videos > 1 Then
	  ProgressOn("Video to Theora", "Converting " & $number_of_videos & " Files", "Working...")
	  For $i = 0 to $number_of_videos - 1
         ProgressSet(($i+1) * 100 / ($i + 2))
         commandLineConvert($files2convert[$i])
      Next
	  closeProgressBarNicely()
   ElseIf $number_of_videos = 1 Then
	  ProgressOn("Converting Video", "Converting your Video File", "Working...")
	  ProgressSet(50)
	  commandLineConvert($files2convert[0])
	  closeProgressBarNicely()
   Else
	  MsgBox(48, "No Video File Added to the List", "Please add video file/s you want to convert to the main application's list", 10)
   EndIf
EndFunc

; Display this message box when the "Help" is clicked
Func onHelp()
	$helpMessage = "How to convert any Video to the Theeora format (.ogv)?" & @LF & @LF 
	$helpMessage &= "1. Add files to the list by clicking on the spying glass button" & @LF
	$helpMessage &= "2. (Optional) Add as many files as you want - they will be converted one after the after" & @LF
	$helpMessage &= "3. (Optional) Sort the video files in the list - they will be converted one after the other in the same order as listed" & @LF 
	$helpMessage &= "4. (Optional) Choose custom quality parameters for the audio & video" & @LF
	$helpMessage &= "5. Click the 'Convert' button" & @LF
	$helpMessage &= "6. Go to the folder where your original video is stored and enjoy your new video files (same filename with .ogv extension)"

	MsgBox(0, "How to use Video to Theora v2.0", $helpMessage)
EndFunc

; Display this message box when the "About" is clicked
Func onAbout()
	$aboutMessage = "Simple GUI which keeps converting video files to the Theora format easy." & @LF & @LF 
	$aboutMessage &= "Initially created for the 3d Remake of King's Quest IV" & @LF
	$aboutMessage &= "http://unicorntales.org" & @LF & @LF 
	$aboutMessage &= "This tool is free for the general use" & @LF & @LF & @LF 
	$aboutMessage &= "Please send me an email about any bug or feature request or just to say thanks: chaiware@gmail.com" & @LF & @LF
	$aboutMessage &= "Video2Theora official site: http://chaiware.org/about-me/commandline-wra/video-theora/"

	MsgBox(0, "About Video to Theora v2.0", $aboutMessage)
EndFunc

; Private Functions
Func closeProgressBarNicely()
   ProgressSet(100)
   Sleep(750)
   ProgressOff()
   MsgBox(4096, "Video Converted", "Video was successfully converted to the Theora format")
EndFunc

; The Actual CommandLine running function
Func commandLineConvert($file2Convert)
	$videoQualityToUse	= GUICtrlRead($videoQuality)
	$audioQualityToUse	= GUICtrlRead($audioQuality)
	$isDebugMode		= GUICtrlRead($debugMode)

	$commandLineCMD 	= $commandlineEXE & ' --optimize -v ' & $videoQualityToUse & ' -a ' & $audioQualityToUse & ' "' & $file2Convert & '"'
	
	if $isDebugMode = $GUI_CHECKED Then
		$cmdPID = Run("cmd", "", @SW_SHOWNORMAL)
		WinWaitActive("cmd.exe")
		$hDos 	= WingetHandle("cmd.exe")
		SendKeepActive($hDos)
		Send($commandLineCMD & @CRLF)
	Else			
		RunWait($commandLineCMD, "", @SW_HIDE)	
	EndIf
EndFunc