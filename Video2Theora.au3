#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

#include <ProgressConstants.au3>
#include <SendMessage.au3>
#include <GuiComboBox.au3>

#include "GUIListViewEx.au3"

Global $array_List;

; Create GUI
$hGUI 			= GUICreate("Convert Video to Theora", 640, 430)

; Create ListView
GUICtrlCreateLabel("List of Video Files you want to Convert to theora", 120, 15, 500, 20)
$hListView 		= _GUICtrlListView_Create($hGUI, "Video Files to Convert", 120, 40, 500, 300, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT, $WS_BORDER))
_GUICtrlListView_SetExtendedListViewStyle($hListView, $LVS_EX_FULLROWSELECT)
_GUICtrlListView_SetColumnWidth($hListView, 0, 500)
_GUICtrlListView_SetInsertMarkColor($hListView, 0)
$listView_index = _GUIListViewEx_Init($hListView, $array_List, 0, 0x00FF00) ; Initiate LVEx - no count - green insert parameter

; Creating menu Items
$fileMenu 			= GUICtrlCreateMenu("File")
$addVideoMenuItem 	= GUICtrlCreateMenuItem("Add Video Files", $fileMenu)
$convertMenuItem 	= GUICtrlCreateMenuItem("Convert Video Files", $fileMenu)
$exitMenuItem 		= GUICtrlCreateMenuItem("Exit", $fileMenu)
$helpMenu 			= GUICtrlCreateMenu("Help")
$aboutMenuItem 		= GUICtrlCreateMenuItem("About", $helpMenu)
GUICtrlSetOnEvent($aboutMenuItem, "onAbout")

; Creating buttons
; TODO add small & nice icons (famfam?)
$hInsert_Button 	= GUICtrlCreateButton("Add", 10, 40, 100, 30)
$hDelete_Button 	= GUICtrlCreateButton("Delete", 10, 80, 100, 30)
$hUp_Button 		= GUICtrlCreateButton("Move Up", 10, 140, 100, 30)
$hDown_Button 		= GUICtrlCreateButton("Move Down", 10, 180, 100, 30)
$hConvert_Button 	= GUICtrlCreateButton("Convert", 420, 370, 100, 30)
$hExit_Button 		= GUICtrlCreateButton("Exit", 530, 370, 100, 30)

; Creating Quality Components
$hLabel2 			= GUICtrlCreateLabel( "Video Quality", 120, 360, 100, 15)
$videoQuality		= GUICtrlCreateCombo( "1", 120, 380, 100, 20)
GUICtrlSetData( $videoQuality, "2|3|4|5|6|7|8|9|10", "6")
GUICtrlSetTip( $videoQuality, "Please Choose Video Quality ([Low]1 - 10[High])")

$hLabel3 			= GUICtrlCreateLabel( "Audio Quality", 240, 360, 100, 15)
$audioQuality		= GUICtrlCreateCombo( "-2", 240, 380, 100, 20)
GUICtrlSetData( $audioQuality, "-1|0|1|2|3|4|5|6|7|8|9|10", "1")
GUICtrlSetTip( $audioQuality, "Please Choose Audio Quality ([Low]-2 - 10[High])")


GUISetState()

; Register for dragging
_GUIListViewEx_DragRegister()

; GUI's Main Logic
While 1
	Switch GUIGetMsg()
		Case $hDelete_Button
			_GUIListViewEx_Delete()
		Case $hUp_Button
			_GUIListViewEx_Up()
		Case $hDown_Button
			_GUIListViewEx_Down()
			
		Case $hInsert_Button, $addVideoMenuItem
		   onBrowse()
	    Case $hConvert_Button, $convertMenuItem
			onConvert()
	    Case $aboutMenuItem
			onAbout()
	    Case $GUI_EVENT_CLOSE, $hExit_Button, $exitMenuItem
			Exit
	EndSwitch
WEnd


; Application Specific Functions

; Browses for video file/s to convert and adds them to the list
Func onBrowse()
	; Multiple filter group
   $message 			= "Hold down Ctrl or Shift to choose multiple files."
   ;$chosenFiles 		= FileOpenDialog($message, @WorkingDir & "", "Videos (*.avi;*.dv)", 1 + 4)
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
   ; TODO Auto detect the actual exe file and have an option to define it manually
   $files2convert 		= _GUIListViewEx_Return_Array($listView_index);
   $number_of_videos 	= UBound($files2convert)
   $videoQualityToUse	= GUICtrlRead($videoQuality)
   $audioQualityToUse	= GUICtrlRead($audioQuality)
   
   if $number_of_videos > 1 Then
	  ProgressOn("Video to Theora", "Converting " & $number_of_videos & " Files", "Working...")
	  For $i = 0 to $number_of_videos - 1
         ProgressSet(($i+1) * 100 / ($i + 2))
		 RunWait(@WorkingDir & '\ffmpeg2theora-0.29.exe --optimize -v ' & $videoQualityToUse & ' -a ' & $audioQualityToUse & ' "' & $files2convert[$i] & '"', "", @SW_HIDE)
      Next
	  closeProgressBarNicely()
   ElseIf $number_of_videos = 1 Then
	  ProgressOn("Converting Video", "Converting your Video File", "Working...")
	  ProgressSet(50)
	  RunWait(@WorkingDir & '\ffmpeg2theora-0.29.exe --optimize -v ' & $videoQualityToUse & ' -a ' & $audioQualityToUse & ' "' & $files2convert[0] & '"', "", @SW_HIDE)
	  closeProgressBarNicely()
   Else
	  MsgBox(48, "No Video File Added to the List", "Please add video file/s you want to convert to the main application's list", 10)
   EndIf
EndFunc   ;==>onConvert

Func onAbout()
   MsgBox(0, "About Video to Theora v1.0", "Simple GUI which keeps converting video files to the Theora format easy." & @LF & @LF & "Initially created for the 3d Remake of King's Quest IV" & @LF & @LF & "http://unicorntales.org" & @LF & @LF & "This tool is free for the general use")
EndFunc   ;==>onAbout

; Private Functions
Func closeProgressBarNicely()
   ProgressSet(100)
   Sleep(750)
   ProgressOff()
   MsgBox(4096, "Video Converted", "Video was successfully converted to the Theora format")
EndFunc