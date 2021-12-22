#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; GUI Elements file

Global $LEFT_BORDER_LIST 	= 120
Global $LEFT_BORDER_BUTTONS = 10
Global $BUTTON_WIDTH 		= 100
Global $BUTTON_HEIGHT 		= 40

; Create GUI
$guiHandler 		= GUICreate("Convert Video to Theora", 640, 430)

; Create ListView
GUICtrlCreateLabel("List of Video Files you want to Convert to theora", $LEFT_BORDER_LIST, 15, 500, 20)
$videoFilesListView = _GUICtrlListView_Create($guiHandler, "Video Files to Convert", $LEFT_BORDER_LIST, 40, 500, 300, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT, $WS_BORDER))
_GUICtrlListView_SetExtendedListViewStyle($videoFilesListView, $LVS_EX_FULLROWSELECT)
_GUICtrlListView_SetColumnWidth($videoFilesListView, 0, 500)
_GUICtrlListView_SetInsertMarkColor($videoFilesListView, 0)
$listView_index 	= _GUIListViewEx_Init($videoFilesListView, $array_List, 0, 0x00FF00) ; Initiate LVEx - no count - green insert parameter

; Creating menu Items
$fileMenu 			= GUICtrlCreateMenu("File")
$addVideoMenuItem 	= GUICtrlCreateMenuItem("Add Video Files", $fileMenu)
$convertMenuItem 	= GUICtrlCreateMenuItem("Convert Video Files", $fileMenu)
$exitMenuItem 		= GUICtrlCreateMenuItem("Exit", $fileMenu)
$helpMenu 			= GUICtrlCreateMenu("Help")
$helpMenuItem 		= GUICtrlCreateMenuItem("How to Use?", $helpMenu)
$aboutMenuItem 		= GUICtrlCreateMenuItem("About", $helpMenu)

; Creating buttons
; TODO add small & nice icons (famfam?)
$insertBtn 	= GUICtrlCreateButton("Add", $LEFT_BORDER_BUTTONS, 40, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($insertBtn, "shell32.dll", -269)
GUICtrlSetTip($insertBtn, "Add Video Files to Convert")
$deleteBtn 	= GUICtrlCreateButton("Delete", $LEFT_BORDER_BUTTONS, 90, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($deleteBtn, "shell32.dll", -132)
GUICtrlSetTip($deleteBtn, "Remove Video files from the list")
$upBtn 		= GUICtrlCreateButton("Move Up", $LEFT_BORDER_BUTTONS, 160, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($upBtn, "shell32.dll", -247)
GUICtrlSetTip($upBtn, "Move the selected video file up")
$downBtn 	= GUICtrlCreateButton("Move Down", $LEFT_BORDER_BUTTONS, 210, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($downBtn, "shell32.dll", -248)
GUICtrlSetTip($downBtn, "Move the selected video file down")
$convertbtn = GUICtrlCreateButton("Convert", 420, 360, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($convertbtn, "shell32.dll", -242)
GUICtrlSetTip($convertbtn, "Convert the listed Video files to Theora")
$exitBtn 	= GUICtrlCreateButton("Exit", 530, 360, $BUTTON_WIDTH, $BUTTON_HEIGHT, $BS_ICON)
GUICtrlSetImage($exitBtn, "shell32.dll", -28)
GUICtrlSetTip($exitBtn, "Exit")

; Creating Quality Components
GUICtrlCreateLabel("Video Quality", $LEFT_BORDER_LIST, 360, $BUTTON_WIDTH, 15)
$videoQuality		= GUICtrlCreateCombo( "1", $LEFT_BORDER_LIST, 380, $BUTTON_WIDTH, 20)
GUICtrlSetData($videoQuality, "2|3|4|5|6|7|8|9|10", "6")
GUICtrlSetTip($videoQuality, "Please Choose Video Quality ([Low]1 - 10[High])")

GUICtrlCreateLabel("Audio Quality", 240, 360, $BUTTON_WIDTH, 15)
$audioQuality		= GUICtrlCreateCombo("-2", 240, 380, $BUTTON_WIDTH, 20)
GUICtrlSetData($audioQuality, "-1|0|1|2|3|4|5|6|7|8|9|10", "1")
GUICtrlSetTip($audioQuality, "Please Choose Audio Quality ([Low]-2 - 10[High])")

$debugMode = GUICtrlCreateCheckbox("Debug Mode", $LEFT_BORDER_BUTTONS, 370, $BUTTON_WIDTH, $BUTTON_HEIGHT)

GUISetState()

; Register for dragging
_GUIListViewEx_DragRegister()