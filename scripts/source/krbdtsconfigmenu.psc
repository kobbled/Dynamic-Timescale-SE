Scriptname krbDTSConfigMenu extends SKI_ConfigBase  
{MCM configuration menu for Dynamic TimeScale}

krbDTSMain Property dynamicTimeScale Auto

Float Property timeScaleWildernessDefault = 24.0 AutoReadOnly
{TimeScale when player is in the wilderness (Skyrim or Solstheim). Default: 24.0}
Float Property timeScaleOutdoorsDefault = 12.0 AutoReadOnly
{TimeScale when the player is in a major city or outdoor "dungeon". Default: 12.0}
Float Property timeScaleIndoorsDefault = 6.0 AutoReadOnly
{TimeScale when the player is in a building or dungeon. Default: 6.0}
Float Property defaultTimeScaleDefault = 10.0 AutoReadOnly
{Default TimeScale when Dynamic TimeScale is disabled. Default: 10.0}


Int timeScaleWildernessID
Int timeScaleOutdoorsID
Int timeScaleIndoorsID
Int defaultTimeScaleID
int is_enabled_id
int is_paused_id

Int uninstallID

Bool uninstall

bool debug_mode = True
Function _debug(string str)
    if debug_mode
        Debug.Trace("Dynamic TimeScale Config: " + str)
    endif
EndFunction

Int Function GetVersion()
	Return 4
EndFunction

Event OnConfigInit()
    initialize()
    _debug("Initialized for the first time")
EndEvent

Function initialize()
	load_defaults()

	If dynamicTimeScale.is_enabled
		dynamicTimeScale.is_paused = False

		dynamicTimeScale.initialize()
	EndIf
EndFunction

Function load_defaults()
	dynamicTimeScale.timeScaleWilderness = timeScaleWildernessDefault
	dynamicTimeScale.timeScaleOutdoors = timeScaleOutdoorsDefault
	dynamicTimeScale.timeScaleIndoors = timeScaleIndoorsDefault
	dynamicTimeScale.defaultTimeScale = defaultTimeScaleDefault

	uninstall = False
EndFunction

Event OnConfigClose()
	If !dynamicTimeScale.is_enabled
		dynamicTimeScale.resetTimeScale()
	ElseIf uninstall
		dynamicTimeScale.uninstall()
	EndIf
EndEvent

Event OnPageReset(String page)
	Int timeScaleOutdoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleDefaultFlag = OPTION_FLAG_DISABLED


	timeScaleOutdoorsFlag = OPTION_FLAG_NONE
	timeScaleIndoorsFlag = OPTION_FLAG_NONE
	timeScaleDefaultFlag = OPTION_FLAG_NONE
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)
	AddHeaderOption("TimeScales")

	is_enabled_id = addToggleOption("Enable", dynamicTimeScale.is_enabled)
	is_paused_id = addToggleOption("Pause", dynamicTimeScale.is_paused)
	AddEmptyOption()
	timeScaleWildernessID = AddSliderOption("Wilderness", dynamicTimeScale.timeScaleWilderness)
	timeScaleOutdoorsID = AddSliderOption("Outdoors", dynamicTimeScale.timeScaleOutdoors, "{0}", timeScaleOutdoorsFlag)
	timeScaleIndoorsID = AddSliderOPtion("Indoors", dynamicTimeScale.timeScaleIndoors, "{0}", timeScaleIndoorsFlag)
	defaultTimeScaleID = AddSliderOption("Default TimeScale", dynamicTimeScale.defaultTimeScale, "{0}", timeScaleDefaultFlag)
	AddEmptyOption()
	uninstallID = AddToggleOption("Uninstall Dynamic TimeScale", uninstall)
EndEvent

Event OnOptionDefault(int optionID)

	If optionID == is_enabled_id
		dynamicTimeScale.is_enabled = True
		SetToggleOptionValue(is_enabled_id, True)

		initialize()
	ElseIf optionID == is_paused_id
			dynamicTimeScale.is_paused = False
			SetToggleOptionValue(is_paused_id, True)
	EndIf
EndEvent

Event OnOptionHighlight(Int optionID)
	If optionID == is_enabled_id
        setInfoText("Enable or disable TimeScale")
	ElseIf optionID == is_paused_id
		setInfoText("Pause Timescale to use Default value")
	ElseIf optionID == timeScaleWildernessID
		SetInfoText("TimeScale when you're out in the general wilderness. Default: " + self.timeScaleWildernessDefault As Int)
	ElseIf optionID == timeScaleOutdoorsID
		SetInfoText("TimeScale when you're in a major city or some 'outdoor' dungeon. Default: " + self.timeScaleOutdoorsDefault As Int)
	ElseIf optionID == timeScaleIndoorsID
		SetInfoText("TimeScale when you're inside a building or dungeon. Default: " + self.timeScaleIndoorsDefault As Int)
	ElseIf optionID == defaultTimeScaleID
		SetInfoText("TimeScale when Dynamic TimeScale is disabled. Default: " + self.defaultTimeScaleDefault As Int)
	ElseIf optionID == uninstallID
		uninstall = False
		SetToggleOptionValue(optionID, uninstall)
	EndIf
	enableOptions()
EndEvent


Event OnOptionSliderOpen(Int optionID)
	If optionID == timeScaleWildernessID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleWilderness)
		SetSliderDialogDefaultValue(self.timeScaleWildernessDefault)
	ElseIf optionID == timeScaleOutdoorsID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleOutdoors)
		SetSliderDialogDefaultValue(self.timeScaleOutdoorsDefault)
	ElseIf optionID == timeScaleIndoorsID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleIndoors)
		SetSliderDialogDefaultValue(self.timeScaleIndoorsDefault)
	ElseIf optionID == defaultTimeScaleID
		SetSliderDialogStartValue(dynamicTimeScale.defaultTimeScale)
		SetSliderDialogDefaultValue(self.defaultTimeScaleDefault)
	EndIf
	SetSliderDialogRange(0.0, 60.0)
	SetSliderDialogInterval(1.0)
EndEvent

Event OnOptionSliderAccept(Int optionID, Float value)
	If optionID == timeScaleWildernessID
		dynamicTimeScale.timeScaleWilderness = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == timeScaleOutdoorsID
		dynamicTimeScale.timeScaleOutdoors = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == timeScaleIndoorsID
		dynamicTimeScale.timeScaleIndoors = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == defaultTimeScaleID
		dynamicTimeScale.defaultTimeScale = value
		SetSliderOptionValue(optionID, value, "{0}")
	EndIf
	enableOptions()
EndEvent

Function enableOptions()
	Int timeScaleOutdoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleDefaultFlag = OPTION_FLAG_DISABLED

	If dynamicTimeScale.timeScaleWilderness > 0.0
		timeScaleOutdoorsFlag = OPTION_FLAG_NONE
		timeScaleIndoorsFlag = OPTION_FLAG_NONE
		timeScaleDefaultFlag = OPTION_FLAG_NONE
	EndIf

	SetOptionFlags(timeScaleOutdoorsID, timeScaleOutdoorsFlag)
	SetOptionFlags(timeScaleIndoorsID, timeScaleIndoorsFlag)
	SetOptionFlags(defaultTimeScaleID, timeScaleDefaultFlag)
EndFunction

Event OnOptionSelect(Int optionID)
	If optionID == is_enabled_id
        dynamicTimeScale.is_enabled = !dynamicTimeScale.is_enabled
        SetToggleOptionValue(is_enabled_id, dynamicTimeScale.is_enabled)
	ElseIf optionID == is_paused_id
		dynamicTimeScale.is_paused = !dynamicTimeScale.is_paused
		SetToggleOptionValue(is_paused_id, dynamicTimeScale.is_paused)

		If dynamicTimeScale.is_paused
			dynamicTimeScale.resetTimeScale()
		EndIf
	ElseIf optionID == uninstallID
		uninstall = !uninstall
		SetToggleOptionValue(optionID, uninstall)
	EndIf
EndEvent


