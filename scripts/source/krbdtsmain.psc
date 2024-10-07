Scriptname krbDTSMain extends Quest  
{Handles changing the TimeScale based on whether you're indoors, outdoors, in the wilderness or in the middle of a fight.}

Float Property timeScaleWildernessDefault = 24.0 AutoReadOnly
{Non-combat TimeScale when player is in the wilderness (Skyrim or Solstheim). Default: 24.0}
Float Property timeScaleOutdoorsDefault = 12.0 AutoReadOnly
{Non-combat TimeScale when the player is in a major city or outdoor "dungeon". Default: 12.0}
Float Property timeScaleIndoorsDefault = 6.0 AutoReadOnly
{Non-combat TimeScale when the player is in a building or dungeon. Default: 6.0}
Float Property timeScaleWildernessCombatDefault = 12.0 AutoReadOnly
{In combat TimeScale when player is in the wilderness (Skyrim or Solsthiem). Default: 12.0}
Float Property timeScaleOutdoorsCombatDefault = 6.0 AutoReadOnly
{In combat TimeScale when the player is in a major city or outdoor "dungeon". Default: 6.0}
Float Property timeScaleIndoorsCombatDefault = 3.0 AutoReadOnly
{In combat TimeScale when the player is in a building or dungeon. Default: 3.0}
Bool Property timeScaleInCombatMeansNPCAgroDefault = True AutoReadOnly
{Player is 'In Combat' when (s)he has agroed a NPC (red dot on compass.) Used for TimeScale. Default: True}
Bool Property timeScaleInCombatMeansWeaponOutDefault = False AutoReadOnly
{Player is 'In Combat' when (s)he has a weapon drawn. Used for TimeScale. Default: False}
Float Property autoSaveReoccurringTimeDefault = 5.0 AutoReadOnly
{The interval between periodic AutoSaves. Default: 5 Minutes}
Float Property autoSaveLockPickTimeDefault = 10.0 AutoReadOnly
{Minimum time the player must be in the pick lock menu before an AutoSave should be performed. Default: 10 Seconds}
Float Property autoSaveInCombatTimeDefault = 10.0 AutoReadOnly
{Minimum number of seconds combat must last before an AutoSave should be performed. Default: 10.0 Seconds}
Bool Property autoSaveInCombatMeansNPCAgroDefault = True AutoReadOnly
{Player is 'In Combat' when (s)he has agroed a NPC (red dot on compass.) Used for AutoSave. Default: True}
Bool Property autoSaveInCombatMeansWeaponOutDefault = False AutoReadOnly
{Player is 'In Combat' when (s)he has a weapon drawn. Used for AutoSave. Default: False}
Float Property autoSaveDelayDefault = 10.0 AutoReadOnly
{A brief delay, to get the player time to prepare for the AutoSave. Default: 5.0 Seconds}
Bool Property autoSaveShowWarningDefault = True AutoReadOnly
{Show warning message asDefaultDelay seconds before performing an AutoSave. Default: True}

Float Property timeScaleWilderness Auto
Float Property timeScaleOutdoors Auto
Float Property timeScaleIndoors Auto
Float Property timeScaleWildernessCombat Auto
Float Property timeScaleOutdoorsCombat Auto
Float Property timeScaleIndoorsCombat Auto
Bool Property timeScaleInCombatMeansNPCAgro Auto
Bool Property timeScaleInCombatMeansWeaponOut Auto
Float Property autoSaveReoccurringTime Auto
Float Property autoSaveLockPickTime Auto
Float Property autoSaveInCombatTime Auto
Bool Property autoSaveInCombatMeansNPCAgro Auto
Bool Property autoSaveInCombatMeansWeaponOut Auto
Float Property autoSaveDelay Auto
Bool Property autoSaveShowWarning Auto
Float Property currentTimeScale Auto

WorldSpace Property Tamriel Auto
WorldSpace Property DLC1HunterHQWorld Auto
WorldSpace Property DLC2SolstheimWorld Auto
GlobalVariable Property TimeScale Auto
Message Property krbAutoSaveMsg Auto
Message Property krbDTSDoUninstallMsg Auto
Message Property krbDTSUninstalledMsg Auto
Quest Property dynamicTimeScale Auto
Quest Property dynamicTimeScaleConfig Auto


Actor player																; Use this variable so I don't have to keep calling Game.GetPlayer()
Float defaultTimeScale = 20.0

Event OnInit()
	timeScaleWilderness = timeScaleWildernessDefault
	timeScaleOutdoors = timeScaleOutdoorsDefault
	timeScaleIndoors = timeScaleIndoorsDefault
	timeScaleWildernessCombat = timeScaleWildernessCombatDefault
	timeScaleOutdoorsCombat = timeScaleOutdoorsCombatDefault
	timeScaleIndoorsCombat = timeScaleIndoorsCombatDefault
	timeScaleInCombatMeansNPCAgro = timeScaleInCombatMeansNPCAgroDefault
	timeScaleInCombatMeansWeaponOut = timeScaleInCombatMeansWeaponOutDefault
	autoSaveReoccurringTime = autoSaveReoccurringTimeDefault
	autoSaveLockPickTime = autoSaveLockPickTimeDefault
	autoSaveInCombatTime = autoSaveInCombatTimeDefault
	autoSaveInCombatMeansNPCAgro = autoSaveInCombatMeansNPCAgroDefault
	autoSaveInCombatMeansWeaponOut = autoSaveInCombatMeansWeaponOutDefault
	autoSaveDelay = autoSaveDelayDefault
	autoSaveShowWarning = autoSaveShowWarningDefault
	player = Game.GetPlayer()
	Self.RegisterForMenu("MapMenu")											; DTS is temporarily disabled for this menu for fast travel
	Self.RegisterForMenu("Sleep/Wait Menu")									; DTS is temporarily disabled for sleeping and waiting
	Self.RegisterForMenu("Lockpicking Menu")								; For AutoSave after closing this menu
	Self.RegisterForUpdate(1.0)
EndEvent


Bool menuOpened
Float startedPicking
Float lockPickMenuTime

Event OnMenuOpen(String menuName)
	menuOpened = True
	TimeScale.SetValue(defaultTimeScale)
	startedPicking = Utility.GetCurrentRealTime()
	lockPickMenuTime = 0.0
EndEvent

Event onMenuClose(String menuName)
	TimeScale.SetValue(currentTimeScale)
	menuOpened = False
	If menuName == "Lockpicking Menu"
		lockPickMenuTime = Utility.GetCurrentRealTime() - startedPicking
	EndIf
Endevent


Bool wasInCombat
Cell previousCell
WorldSpace previousWorldSpace
Bool timeScaleReset

Event OnUpdate()
	Bool amInCombat = getInCombat(timeScaleInCombatMeansNPCAgro, timeScaleInCombatMeansWeaponOut)
	WorldSpace currentWorldSpace = player.GetWorldSpace()
	Cell currentCell = player.GetParentCell()
	Bool changedEnvironment	= (currentWorldSpace != PreviousWorldSpace) || (player.isInInterior() && (currentCell != previousCell))
	Bool performAutoSave

	Float fCheckTimeScale = TimeScale.GetValue()
	if (fCheckTimeScale != timeScaleWilderness) || (fCheckTimeScale != timeScaleOutdoors) || (fCheckTimeScale != timeScaleIndoors) || (fCheckTimeScale != timeScaleWildernessCombat) || (fCheckTimeScale != timeScaleOutdoorsCombat) || (fCheckTimeScale != timeScaleIndoorsCombat)
		debug.notification("Dynamic Timescale: Setting timescale...")
		changedEnvironment = true
	EndIf
	
	If timeScaleWilderness > 0.0
		If (amInCombat != wasInCombat) || changedEnvironment
			currentTimeScale = getNewTimeScale(amInCombat, currentWorldSpace)
			If !menuOpened
				TimeScale.SetValue(currentTimeScale)
			EndIf
			wasInCombat = amInCombat
		EndIf
		timeScaleReset = False
	Else
		If !timeScaleReset
			currentTimeScale = defaultTimeScale
			TimeScale.SetValue(defaultTimeScale)
			timeScaleReset = True
		EndIf
	EndIf
	If (autoSaveReoccurringTime > 0.0) || (autoSaveLockPickTime > 0.0) || (autoSaveInCombatTime > 0.0)
		performAutoSave = handleAutoSave(getInCombat(autoSaveInCombatMeansNPCAgro, autoSaveInCombatMeansWeaponOut), changedEnvironment, lockPickMenuTime)
		lockPickMenuTime = 0.0
	EndIf
	previousCell = currentCell
	previousWorldSpace = currentWorldSpace
	If performAutoSave
		Utility.Wait(0.001)
		Game.RequestAutoSave()
	EndIf
EndEvent

Float Function getNewTimeScale(Bool inCombat, WorldSpace thisWorld)
	If  (timeScaleIndoors > 0.0) && player.IsInInterior()
		If (timeScaleIndoorsCombat > 0.0) && inCombat  						; Indoors
			Return timeScaleIndoorsCombat
		Else
			Return timeScaleIndoors
		EndIf
	ElseIf  (timeScaleOutdoors > 0.0) && (thisWorld != None) && (thisWorld != Tamriel) && (thisWorld != DLC1HunterHQWorld) && (thisWorld != DLC2SolstheimWorld)
		If (timeScaleOutdoorsCombat > 0.0) && inCombat						; Outdoors
			Return timeScaleOutdoorsCombat
		Else
			Return timeScaleOutdoors
		EndIf
	Else
		If (timeScaleWildernessCombat > 0.0) && inCombat					; Wilderness
			Return timeScaleWildernessCombat
		Else
			Return timeScaleWilderness
		EndIf
	EndIf
EndFunction


Bool Function getInCombat(Bool useNPCAgro, Bool useWeaponOut)
	If useNPCAgro && useWeaponOut
		Return player.IsInCombat() && player.IsWeaponDrawn()
	Else
		Return (useNPCAgro && player.IsInCombat()) || (useWeaponOut && player.IsWeaponDrawn())
	EndIf
EndFunction


Float autoSaveTimer
Float combatDelayTimer
Float inCombatTimer
Float reoccurringTimer

Bool Function handleAutoSave(Bool inCombat, Bool newLocation, Float lockPickTimer)
	If player.IsDead() || newLocation
		autoSaveTimer = 0.0
		combatDelayTimer = 0.0
		inCombatTimer = 0.0
		reoccurringTimer = 0.0
		Return False
	EndIf
	If UI.IsMenuOpen("Crafting Menu") || UI.IsMenuOpen("Dialogue Menu") || UI.IsMenuOpen("RaceSex Menu")
		If autoSaveTimer > 1.0
			autoSaveTimer = 1.0
		EndIf
		Return False
	EndIf
	If inCombat
		combatDelayTimer = 0.0
		If autoSaveInCombatTime > 0.0
			inCombatTimer += 1.0
		EndIf
		If autoSaveTimer > 1.0
			autoSaveTimer = 1.0
		EndIf
		Return False
	EndIf
	If (autoSaveTimer == 1.0) && autoSaveShowWarning && (autoSaveDelay >= 5.0)
		krbAutoSaveMsg.Show(autoSaveDelay)
	ElseIf autoSaveTimer > autoSaveDelay
		autoSaveTimer = 0.0
		combatDelayTimer = 0.0
		inCombatTimer = 0.0
		reoccurringTimer = 0.0
		Return True
	EndIf
	If autoSaveTimer > 0.0
		autoSaveTimer += 1.0
	EndIf
	If (autoSaveInCombatTime > 0.0) && (inCombatTimer > autoSaveInCombatTime)
		autoSaveTimer = 1.0
		inCombatTimer = 0.0
	ElseIf (autoSaveInCombatTime > 0.0) && (inCombatTimer > 0.0) && (autoSaveTimer == 0.0)
		If combatDelayTimer > autoSaveDelay
			inCombatTimer = 0.0
		EndIf
		combatDelayTimer += 1.0
	EndIf
	If (autoSaveLockPickTime > 0.0) && (lockPickTimer >= autoSaveLockPickTime)
		autoSaveTimer = 1.0
	EndIf
	If (autoSaveReoccurringTime > 0.0)
		reoccurringTimer += 1.0
		If (reoccurringTimer > autoSaveReoccurringTime * 60) && (autoSaveTimer == 0.0)
			autoSaveTimer = 1.0
		EndIf
	EndIf
	Return False
EndFunction


Function uninstall()
	Utility.Wait(0.001)
	If krbDTSDoUninstallMsg.Show() == 0
		Self.UnregisterForAllMenus()
		Self.UnregisterForUpdate()
		dynamicTimeScaleConfig.Stop()
		dynamicTimeScale.Stop()
		TimeScale.SetValue(defaultTimeScale)
		krbDTSUninstalledMsg.Show()
		Game.RequestAutoSave()
	EndIf		
EndFunction
