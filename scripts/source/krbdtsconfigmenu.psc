Scriptname krbDTSConfigMenu extends SKI_ConfigBase  
{MCM configuration menu for Dynamic TimeScale}

krbDTSMain Property dynamicTimeScale Auto

Int timeScaleWildernessID
Int timeScaleOutdoorsID
Int timeScaleIndoorsID
Int timeScaleWildernessCombatID
Int timeScaleOutdoorsCombatID
Int timeScaleIndoorsCombatID
Int timeScaleInCombatMeansID
Int timeScaleInCombatMeansNPCAgroID
Int timeScaleInCombatMeansWeaponOutID
Int autoSaveReoccurringTimeID
Int autoSaveLockPickTimeID
Int autoSaveInCombatTimeID
Int autoSaveInCombatMeansID
Int autoSaveInCombatMeansNPCAgroID
Int autoSaveInCombatMeansWeaponOutID
Int autoSaveDelayID
Int autoSaveShowWarningID
Int uninstallID

Bool uninstall

Event OnPageReset(String page)
	Int timeScaleOutdoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleWildernessCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleOutdoorsCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansNPCAgroFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansWeaponOutFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansNPCAgroFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansWeaponOutFlag = OPTION_FLAG_DISABLED
	Int autoSaveDelayFlag = OPTION_FLAG_DISABLED
	Int autoSaveShowWarningFlag = OPTION_FLAG_DISABLED

	If dynamicTimeScale.timeScaleWilderness > 0.0
		timeScaleOutdoorsFlag = OPTION_FLAG_NONE
		timeScaleIndoorsFlag = OPTION_FLAG_NONE
		timeScaleWildernessCombatFlag = OPTION_FLAG_NONE
		If dynamicTimeScale.timeScaleOutdoors > 0.0
			timeScaleOutdoorsCombatFlag = OPTION_FLAG_NONE
		EndIf
		If dynamicTimeScale.timeScaleIndoors > 0.0
			timeScaleIndoorsCombatFlag = OPTION_FLAG_NONE
		EndIf
		If (dynamicTimeScale.timeScaleWildernessCombat > 0.0) || ((dynamicTimeScale.timeScaleOutdoorsCombat > 0.0) && (dynamicTimeScale.timeScaleOutdoors > 0.0)) || ((dynamicTimeScale.timeScaleIndoorsCombat > 0.0) && (dynamicTimeScale.timeScaleIndoors > 0.0))
			timeScaleInCombatMeansFlag = OPTION_FLAG_NONE
			timeScaleInCombatMeansNPCAgroFlag = OPTION_FLAG_NONE
			timeScaleInCombatMeansWeaponOutFlag = OPTION_FLAG_NONE
		EndIf
	EndIf
	If (dynamicTimeScale.autoSaveReoccurringTime > 0.0) || (dynamicTimeScale.autoSaveLockPickTime > 0.0) || (dynamicTimeScale.autoSaveInCombatTime > 0.0)
		If dynamicTimeScale.autoSaveInCombatTime > 0.0
			autoSaveInCombatMeansFlag = OPTION_FLAG_NONE
			autoSaveInCombatMeansNPCAgroFlag = OPTION_FLAG_NONE
			autoSaveInCombatMeansWeaponOutFlag = OPTION_FLAG_NONE
		EndIf
		autoSaveDelayFlag = OPTION_FLAG_NONE
		If dynamicTimeScale.autoSaveDelay >= 5.0
			autoSaveShowWarningFlag = OPTION_FLAG_NONE
		EndIf
	EndIf
	uninstall = False
	SetCursorFillMode(TOP_TO_BOTTOM)
	; Left side of the menu. Non-combat, default and combat TimeScales.
	SetCursorPosition(0)
	AddHeaderOption("Standard TimeScales")
	timeScaleWildernessID = AddSliderOption("Wilderness", dynamicTimeScale.timeScaleWilderness)
	timeScaleOutdoorsID = AddSliderOption("Outdoors", dynamicTimeScale.timeScaleOutdoors, "{0}", timeScaleOutdoorsFlag)
	timeScaleIndoorsID = AddSliderOPtion("Indoors", dynamicTimeScale.timeScaleIndoors, "{0}", timeScaleIndoorsFlag)
	AddEmptyOption()
	AddHeaderOption("Combat TimeScales")
	timeScaleWildernessCombatID = AddSliderOption("Wilderness", dynamicTimeScale.timeScaleWildernessCombat, "{0}", timeScaleWildernessCombatFlag)
	timeScaleOutdoorsCombatID = AddSliderOption("Outdoors", dynamicTimeScale.timeScaleOutdoorsCombat, "{0}", timeScaleOutdoorsCombatFlag)
	timeScaleIndoorsCombatID = AddSliderOPtion("Indoors", dynamicTimeScale.timeScaleIndoorsCombat, "{0}", timeScaleIndoorsCombatFlag)
	timeScaleInCombatMeansID = AddTextOption("  'In Combat' means...", "", timeScaleInCombatMeansFlag)
	timeScaleInCombatMeansNPCAgroID = AddToggleOption("    A NPC is fighting you", dynamicTimeScale.timeScaleInCombatMeansNPCAgro, timeScaleInCombatMeansNPCAgroFlag)
	timeScaleInCombatMeansWeaponOutID = AddToggleOption("    You have your weapon drawn", dynamicTimeScale.timeScaleInCombatMeansWeaponOut, timeScaleInCombatMeansWeaponOutFlag)
	; Right side of the menu. AutoSave and advanced options.
	SetCursorPosition(1)
	AddHeaderOption("AutoSave")
	autoSaveReoccurringTimeID = AddSliderOption("Reoccurring Time", dynamicTimeScale.autoSaveReoccurringTime, "{0} Min")
	autoSaveLockPickTimeID = AddSliderOption("After picking a lock time", dynamicTimeScale.autoSaveLockPickTime, "{0} Sec")
	autoSaveInCombatTimeID = AddSliderOption("After combat time", dynamicTimeScale.autoSaveInCombatTime, "{0} Sec")
	autoSaveInCombatMeansID = AddTextOption("  'In Combat' means...", "", autoSaveInCombatMeansFlag)
	autoSaveInCombatMeansNPCAgroID = AddToggleOption("    A NPC is fighting you", dynamicTimeScale.autoSaveInCombatMeansNPCAgro, autoSaveInCombatMeansNPCAgroFlag)
	autoSaveInCombatMeansWeaponOutID = AddToggleOption("    You have your weapon drawn", dynamicTimeScale.autoSaveInCombatMeansWeaponOut, autoSaveInCombatMeansWeaponOutFlag)
	autoSaveDelayID = AddSliderOption("Delay before AutoSave.", dynamicTimeScale.autoSaveDelay, "{0} Sec", autoSaveDelayFlag)
	autoSaveShowWarningID = AddToggleOption("  Show warning before AutoSave", dynamicTimeScale.autoSaveShowWarning, autoSaveShowWarningFlag)
	SetCursorPosition(23)
	uninstallID = AddToggleOption("Uninstall Dynamic TimeScale", uninstall)
EndEvent


Event OnOptionHighlight(Int optionID)
	If optionID == timeScaleWildernessID
		SetInfoText("TimeScale when you're out in the general wilderness and not in combat. Set to 0 to disable.\nDefault: " + dynamicTimeScale.timeScaleWildernessDefault As Int)
	ElseIf optionID == timeScaleOutdoorsID
		SetInfoText("TimeScale when you're in a major city or some 'outdoor' dungeon and not in combat. Set to 0 to disable.\nDefault: " + dynamicTimeScale.timeScaleOutdoorsDefault As Int)
	ElseIf optionID == timeScaleIndoorsID
		SetInfoText("TimeScale when you're inside a building or dungeon and not in combat. Set to 0 to disable.\nDefault: " + dynamicTimeScale.timeScaleIndoorsDefault As Int)
	ElseIf optionID == timeScaleWildernessCombatID
		SetInfoText("TimeScale when you're out in the general wilderness during combat. Set to 0 to disable.\nDefault: " + dynamicTimeScale.timeScaleWildernessCombatDefault As Int)
	ElseIf optionID == timeScaleOutdoorsCombatID
		SetInfoText("TimeScale when you're in a major city or some 'outdoor' dungeon during combat. Set to 0 to disable\nDefault: " + dynamicTimeScale.timeScaleOutdoorsCombatDefault As Int)
	ElseIf optionID == timeScaleIndoorsCombatID
		SetInfoText("TimeScale when you're inside a building or dungeon during combat. Set to 0 to disable.\nDefault: " + dynamicTimeScale.timeScaleIndoorsCombatDefault As Int)
	ElseIf optionID == timeScaleInCombatMeansID
		SetInfoText("This decides when you are considered to be 'in combat' and the in combat TimeScales are used. You must enable at least one of the options.")
	ElseIf optionID == timeScaleInCombatMeansNPCAgroID
		SetInfoText("A NPC is either fighting you, actively looking for you or running away from you. You will be 'in combat' any time there's a red dot on your compass.\nDefault: " + dynamicTimeScale.timeScaleInCombatMeansNPCAgroDefault As String)
	ElseIf optionID == timeScaleInCombatMeansWeaponOutID
		SetInfoText("You have your weapon(s) drawn, spell(s) ready or your fists out.\nDefault: " + dynamicTimeScale.timeScaleInCombatMeansWeaponOutDefault As String)
	ElseIf optionID == autoSaveReoccurringTimeID
		SetInfoText("Set the time between reoccurring AutoSaves. Set to 0 to disable.\nDefault: " + dynamicTimeScale.autoSaveReoccurringTimeDefault As Int + " Minute(s)")
	ElseIf optionID == autoSaveLockPickTimeID
		SetInfoText("Set the minimum amount of time you must spend in the Lock Pick screen before an AutoSave will be performed when you're finished. Set to 0 to disable.\nDeault: "  + dynamicTimeScale.autoSaveLockPickTimeDefault As Int + " second(s)")
	ElseIf optionID == autoSaveInCombatTimeID
		SetInfoText("Set the minimum amount of time you must spend in combat before an AutoSave will be performed. Set to 0 to disable\nDefault: " + dynamicTimeScale.autoSaveInCombatTimeDefault As Int + " second(s)")
	ElseIf optionID == autoSaveInCombatMeansID
		SetInfoText("This decides when you are considered 'in combat' and eligible for an AutoSave after combat is finished. You must enable at least one of the options.")
	ElseIf optionID == autoSaveInCombatMeansNPCAgroID
		SetInfoText("A NPC is either fighting you, actively looking for you or running away from you. You will be 'in combat' any time there's a red dot on your compass.\nDefault: " + dynamicTimeScale.autoSaveInCombatMeansNPCAgroDefault As String)
	ElseIf optionID == autoSaveInCombatMeansWeaponOutID
		SetInfoText("You have your weapon(s) drawn, spell(s) ready or your fists out.\nDefault: " + dynamicTimeScale.autoSaveInCombatMeansWeaponOutDefault As String)
	ElseIf optionId == autoSaveDelayID
		SetInfoText("Set how long to wait before performing an AutoSave. Since an AutoSave freezes the game for a few seconds, this gives you time to get ready for it. The AutoSave will abort if combat starts before this time expires.\nDefault: " + dynamicTimeScale.autoSaveDelayDefault As Int + " second(s)")
	ElseIf optionID == autoSaveShowWarningID
		SetInfoText("Show a warning message that an AutoSave of about to be performed. This message will not show if the delay is less than five seconds.\nDefault: " + dynamicTimeScale.autoSaveShowWarningDefault As String)
	ElseIf optionID == uninstallID
		SetInfoText("Shuts down all of the scripts and quests to let you safely disable this mod. Uninstall will start when you leave the menus. You will be asked to confirm your decision.")
	EndIf		
EndEvent


Event OnOptionDefault(Int optionID)
	If optionID == timeScaleWildernessID
		dynamicTimeScale.timeScaleWilderness = dynamicTimeScale.timeScaleWildernessDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleWilderness)
	ElseIf optionID == timeScaleOutdoorsID
		dynamicTimeScale.timeScaleOutdoors = dynamicTimeScale.timeScaleOutdoorsDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleOutdoors)
	ElseIf optionID == timeScaleIndoorsID
		dynamicTimeScale.timeScaleIndoors = dynamicTimeScale.timeScaleIndoorsDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleIndoors)
	ElseIf optionID == timeScaleWildernessCombatID
		dynamicTimeScale.timeScaleWildernessCombat = dynamicTimeScale.timeScaleWildernessCombatDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleWildernessCombat)
	ElseIf optionID == timeScaleOutdoorsCombatID
		dynamicTimeScale.timeScaleOutdoorsCombat = dynamicTimeScale.timeScaleOutdoorsCombatDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleOutdoorsCombat)
	ElseIf optionID == timeScaleIndoorsCombatID
		dynamicTimeScale.timeScaleIndoorsCombat = dynamicTimeScale.timeScaleIndoorsCombatDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.timeScaleIndoorsCombat)
	ElseIf optionID == timeScaleInCombatMeansNPCAgroID
		dynamicTimeScale.timeScaleInCombatMeansNPCAgro = dynamicTimeScale.timeScaleInCombatMeansNPCAgroDefault
		SetToggleOptionValue(optionID, dynamicTimeScale.timeScaleInCombatMeansNPCAgro)
	ElseIf optionID == timeScaleInCombatMeansWeaponOutID
		dynamicTimeScale.timeScaleInCombatMeansWeaponOut = dynamicTimeScale.timeScaleInCombatMeansWeaponOutDefault
		SetToggleOptionValue(optionID, dynamicTimeScale.timeScaleInCombatMeansWeaponOut)
	ElseIf optionID == autoSaveReoccurringTimeID
		dynamicTimeScale.autoSaveReoccurringTime = dynamicTimeScale.autoSaveReoccurringTimeDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.autoSaveReoccurringTime, "{0} Min")
	ElseIf optionID == autoSaveLockPickTimeID
		dynamicTimeScale.autoSaveLockPickTime = dynamicTimeScale.autoSaveLockPickTimeDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.autoSaveLockPickTime, "{0} Sec")
	ElseIf optionID == autoSaveInCombatTimeID
		dynamicTimeScale.autoSaveInCombatTime = dynamicTimeScale.autoSaveInCombatTimeDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.autoSaveInCombatTime, "{0} Sec")
	ElseIf optionID == autoSaveInCombatMeansNPCAgroID
		dynamicTimeScale.autoSaveInCombatMeansNPCAgro = dynamicTimeScale.autoSaveInCombatMeansNPCAgroDefault
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveInCombatMeansNPCAgro)
	ElseIf optionID == autoSaveInCombatMeansWeaponOutID
		dynamicTimeScale.autoSaveInCombatMeansWeaponOut = dynamicTimeScale.autoSaveInCombatMeansWeaponOutDefault
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveInCombatMeansWeaponOut)
	ElseIf optionID == autoSaveDelayID
		dynamicTimeScale.autoSaveDelay = dynamicTimeScale.autoSaveDelayDefault
		SetSliderOptionValue(optionID, dynamicTimeScale.autoSaveDelay, "{0} Sec")
	ElseIf optionID == autoSaveShowWarningID
		dynamicTimeScale.autoSaveShowWarning = dynamicTimeScale.autoSaveShowWarningDefault
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveShowWarning)
	ElseIf optionID == uninstallID
		uninstall = False
		SetToggleOptionValue(optionID, uninstall)
	EndIf
	enableOptions()
EndEvent


Event OnOptionSliderOpen(Int optionID)
	If optionID == timeScaleWildernessID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleWilderness)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleWildernessDefault)
	ElseIf optionID == timeScaleOutdoorsID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleOutdoors)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleOutdoorsDefault)
	ElseIf optionID == timeScaleIndoorsID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleIndoors)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleIndoorsDefault)
	ElseIf optionID == timeScaleWildernessCombatID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleWildernessCombat)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleWildernessCombatDefault)
	ElseIf optionID == timeScaleOutdoorsCombatID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleOutdoorsCombat)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleOutdoorsCombatDefault)
	ElseIf optionID == timeScaleIndoorsCombatID
		SetSliderDialogStartValue(dynamicTimeScale.timeScaleIndoorsCombat)
		SetSliderDialogDefaultValue(dynamicTimeScale.timeScaleIndoorsCombatDefault)
	ElseIf optionID == autoSaveReoccurringTimeID
		SetSliderDialogStartValue(dynamicTimeScale.autoSaveReoccurringTime)
		SetSliderDialogDefaultValue(dynamicTimeScale.autoSaveReoccurringTimeDefault)
	ElseIf optionID == autoSaveLockPickTimeID
		SetSliderDialogStartValue(dynamicTimeScale.autoSaveLockPickTime)
		SetSliderDialogDefaultValue(dynamicTimeScale.autoSaveLockPickTimeDefault)
	ElseIf optionID == autoSaveInCombatTimeID
		SetSliderDialogStartValue(dynamicTimeScale.autoSaveInCombatTime)
		SetSliderDialogDefaultValue(dynamicTimeScale.autoSaveInCombatTimeDefault)
	ElseIf optionID == autoSaveDelayID
		SetSliderDialogStartValue(dynamicTimeScale.autoSaveDelay)
		SetSliderDialogDefaultValue(dynamicTimeScale.autoSaveDelayDefault)
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
	ElseIf optionID == timeScaleWildernessCombatID
		dynamicTimeScale.timeScaleWildernessCombat = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == timeScaleOutdoorsCombatID
		dynamicTimeScale.timeScaleOutdoorsCombat = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == timeScaleIndoorsCombatID
		dynamicTimeScale.timeScaleIndoorsCombat = value
		SetSliderOptionValue(optionID, value, "{0}")
	ElseIf optionID == autoSaveReoccurringTimeID
		dynamicTimeScale.autoSaveReoccurringTime = value
		SetSliderOptionValue(optionID, value, "{0} Min")
	ElseIf optionID == autoSaveLockPickTimeID
		dynamicTimeScale.autoSaveLockPickTime = value
		SetSliderOptionValue(optionID, value, "{0} Sec")
	ElseIf optionID == autoSaveInCombatTimeID
		dynamicTimeScale.autoSaveInCombatTime = value
		SetSliderOptionValue(optionID, value, "{0} Sec")
	ElseIf optionID == autoSaveDelayID
		dynamicTimeScale.autoSaveDelay = value
		SetSliderOptionValue(optionID, value, "{0} Sec")
	EndIf
	enableOptions()
EndEvent

Event OnOptionSelect(Int optionID)
	If optionID == timeScaleInCombatMeansNPCAgroID
		dynamicTimeScale.timeScaleInCombatMeansNPCAgro = !dynamicTimeScale.timeScaleInCombatMeansNPCAgro
		SetToggleOptionValue(optionID, dynamicTimeScale.timeScaleInCombatMeansNPCAgro)
		If !dynamicTimeScale.timeScaleInCombatMeansNPCAgro && !dynamicTimeScale.timeScaleInCombatMeansWeaponOut
			dynamicTimeScale.timeScaleInCombatMeansWeaponOut = True
			SetToggleOptionValue(timeScaleInCombatMeansWeaponOutID, dynamicTimeScale.timeScaleInCombatMeansWeaponOut)
		EndIf
	ElseIf optionID == timeScaleInCombatMeansWeaponOutID
		dynamicTimeScale.timeScaleInCombatMeansWeaponOut = !dynamicTimeScale.timeScaleInCombatMeansWeaponOut
		SetToggleOptionValue(optionID, dynamicTimeScale.timeScaleInCombatMeansWeaponOut)
		If !dynamicTimeScale.timeScaleInCombatMeansNPCAgro && !dynamicTimeScale.timeScaleInCombatMeansWeaponOut
			dynamicTimeScale.timeScaleInCombatMeansNPCAgro = True
			SetToggleOptionValue(timeScaleInCombatMeansNPCAgroID, dynamicTimeScale.timeScaleInCombatMeansNPCAgro)
		EndIf
	ElseIf optionID == autoSaveInCombatMeansNPCAgroID
		dynamicTimeScale.autoSaveInCombatMeansNPCAgro = !dynamicTimeScale.autoSaveInCombatMeansNPCAgro
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveInCombatMeansNPCAgro)
		If !dynamicTimeScale.autoSaveInCombatMeansNPCAgro && !dynamicTimeScale.autoSaveInCombatMeansWeaponOut
			dynamicTimeScale.autoSaveInCombatMeansWeaponOut = True
			SetToggleOptionValue(autoSaveInCombatMeansWeaponOutID, dynamicTimeScale.autoSaveInCombatMeansWeaponOut)
		EndIf
	ElseIf optionID == autoSaveInCombatMeansWeaponOutID
		dynamicTimeScale.autoSaveInCombatMeansWeaponOut = !dynamicTimeScale.autoSaveInCombatMeansWeaponOut
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveInCombatMeansWeaponOut)
		If !dynamicTimeScale.autoSaveInCombatMeansNPCAgro && !dynamicTimeScale.autoSaveInCombatMeansWeaponOut
			dynamicTimeScale.autoSaveInCombatMeansNPCAgro = True
			SetToggleOptionValue(autoSaveInCombatMeansNPCAgroID, dynamicTimeScale.autoSaveInCombatMeansNPCAgro)
		EndIf
	ElseIf optionID == autoSaveShowWarningID
		dynamicTimeScale.autoSaveShowWarning = !dynamicTimeScale.autoSaveShowWarning
		SetToggleOptionValue(optionID, dynamicTimeScale.autoSaveShowWarning)
	ElseIf optionID == uninstallID
		uninstall = !uninstall
		SetToggleOptionValue(optionID, uninstall)
	EndIf
EndEvent


Function enableOptions()
	Int timeScaleOutdoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsFlag = OPTION_FLAG_DISABLED
	Int timeScaleWildernessCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleOutdoorsCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleIndoorsCombatFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansNPCAgroFlag = OPTION_FLAG_DISABLED
	Int timeScaleInCombatMeansWeaponOutFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansNPCAgroFlag = OPTION_FLAG_DISABLED
	Int autoSaveInCombatMeansWeaponOutFlag = OPTION_FLAG_DISABLED
	Int autoSaveDelayFlag = OPTION_FLAG_DISABLED
	Int autoSaveShowWarningFlag = OPTION_FLAG_DISABLED

	If dynamicTimeScale.timeScaleWilderness > 0.0
		timeScaleOutdoorsFlag = OPTION_FLAG_NONE
		timeScaleIndoorsFlag = OPTION_FLAG_NONE
		timeScaleWildernessCombatFlag = OPTION_FLAG_NONE
		If dynamicTimeScale.timeScaleOutdoors > 0.0
			timeScaleOutdoorsCombatFlag = OPTION_FLAG_NONE
		EndIf
		If dynamicTimeScale.timeScaleIndoors > 0.0
			timeScaleIndoorsCombatFlag = OPTION_FLAG_NONE
		EndIf
		If (dynamicTimeScale.timeScaleWildernessCombat > 0.0) || ((dynamicTimeScale.timeScaleOutdoorsCombat > 0.0) && (dynamicTimeScale.timeScaleOutdoors > 0.0)) || ((dynamicTimeScale.timeScaleIndoorsCombat > 0.0) && (dynamicTimeScale.timeScaleIndoors > 0.0))
			timeScaleInCombatMeansFlag = OPTION_FLAG_NONE
			timeScaleInCombatMeansNPCAgroFlag = OPTION_FLAG_NONE
			timeScaleInCombatMeansWeaponOutFlag = OPTION_FLAG_NONE
		EndIf
	EndIf
	If (dynamicTimeScale.autoSaveReoccurringTime > 0.0) || (dynamicTimeScale.autoSaveLockPickTime > 0.0) || (dynamicTimeScale.autoSaveInCombatTime > 0.0)
		If dynamicTimeScale.autoSaveInCombatTime > 0.0
			autoSaveInCombatMeansFlag = OPTION_FLAG_NONE
			autoSaveInCombatMeansNPCAgroFlag = OPTION_FLAG_NONE
			autoSaveInCombatMeansWeaponOutFlag = OPTION_FLAG_NONE
		EndIf
		autoSaveDelayFlag = OPTION_FLAG_NONE
		If dynamicTimeScale.autoSaveDelay >= 5.0
			autoSaveShowWarningFlag = OPTION_FLAG_NONE
		EndIf
	EndIf
	SetOptionFlags(timeScaleOutdoorsID, timeScaleOutdoorsFlag)
	SetOptionFlags(timeScaleIndoorsID, timeScaleIndoorsFlag)
	SetOptionFlags(timeScaleWildernessCombatID, timeScaleWildernessCombatFlag)
	SetOptionFlags(timeScaleOutdoorsCombatID, timeScaleOutdoorsCombatFlag)
	SetOptionFlags(timeScaleIndoorsCombatID, timeScaleIndoorsCombatFlag)
	SetOptionFlags(timeScaleInCombatMeansID, timeScaleInCombatMeansFlag)
	SetOptionFlags(timeScaleInCombatMeansNPCAgroID, timeScaleInCombatMeansNPCAgroFlag)
	SetOptionFlags(timeScaleInCombatMeansWeaponOutID, timeScaleInCombatMeansWeaponOutFlag)
	SetOptionFlags(autoSaveInCombatMeansID, autoSaveInCombatMeansFlag)
	SetOptionFlags(autoSaveInCombatMeansNPCAgroID, autoSaveInCombatMeansNPCAgroFlag)
	SetOptionFlags(autoSaveInCombatMeansWeaponOutID, autoSaveInCombatMeansWeaponOutFlag)
	SetOptionFlags(autoSaveDelayID, autoSaveDelayFlag)
	SetOptionFlags(autoSaveShowWarningID, autoSaveShowWarningFlag)
EndFunction


Event OnConfigClose()
	If uninstall
		dynamicTimeScale.uninstall()
	EndIf
EndEvent


Int Function GetVersion()
	Return 4
EndFunction
