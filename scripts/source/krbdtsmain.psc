Scriptname krbDTSMain extends Quest  
{Handles changing the TimeScale based on whether you're indoors, outdoors, or in the wilderness.}

Float Property timeScaleWilderness Auto
Float Property timeScaleOutdoors Auto
Float Property timeScaleIndoors Auto
Float Property currentTimeScale Auto
Float Property defaultTimeScale Auto

WorldSpace Property Tamriel Auto
WorldSpace Property DLC1HunterHQWorld Auto
WorldSpace Property DLC2SolstheimWorld Auto
GlobalVariable Property TimeScale Auto
Quest Property dynamicTimeScale Auto
Quest Property dynamicTimeScaleConfig Auto

bool Property is_enabled Auto
bool Property is_paused Auto
bool Property timeScaleReset Auto

Actor player

Bool menuOpened
Float startedPicking

Event OnMenuOpen(String menuName)
	menuOpened = True
	; TimeScale.SetValue(defaultTimeScale)
EndEvent

Event onMenuClose(String menuName)
	; TimeScale.SetValue(currentTimeScale)
	menuOpened = False
Endevent


Cell previousCell
WorldSpace previousWorldSpace

Function initialize()
	RegisterForMenu("MapMenu")											; DTS is temporarily disabled for this menu for fast travel
	RegisterForMenu("Sleep/Wait Menu")									; DTS is temporarily disabled for sleeping and waiting
	RegisterForUpdate(1.0)

	player = Game.GetPlayer()
	previousWorldSpace = player.GetWorldSpace()
	previousCell = player.GetParentCell()

	currentTimeScale = getNewTimeScale(previousWorldSpace)
	TimeScale.SetValue(currentTimeScale)
	timeScaleReset = False
EndFunction

Function resetTimeScale()
	If (!is_enabled || is_paused)
		currentTimeScale = defaultTimeScale
		TimeScale.SetValue(defaultTimeScale)
		timeScaleReset = False
	EndIf
EndFunction

Event OnUpdate()

	if !is_enabled || is_paused
		return
	endif

	player = Game.GetPlayer()

	WorldSpace currentWorldSpace = player.GetWorldSpace()
	Cell currentCell = player.GetParentCell()
	Bool changedEnvironment	= (currentWorldSpace != PreviousWorldSpace) || (player.isInInterior() && (currentCell != previousCell))

	Float fCheckTimeScale = TimeScale.GetValue()
	if (fCheckTimeScale != timeScaleWilderness) && (fCheckTimeScale != timeScaleOutdoors) && (fCheckTimeScale != timeScaleIndoors)
		debug.notification("Dynamic Timescale: Setting timescale...")
		changedEnvironment = true
		registerForKey(38)
	EndIf

	If changedEnvironment
		currentTimeScale = getNewTimeScale(currentWorldSpace)
		TimeScale.SetValue(currentTimeScale)
	EndIf

	previousCell = currentCell
	previousWorldSpace = currentWorldSpace
EndEvent

Event OnKeyDown(int keycode)
	printTimescale()
EndEvent

Float Function getNewTimeScale(WorldSpace thisWorld)
	If player.IsInInterior()
		Return timeScaleIndoors
	ElseIf (timeScaleOutdoors > 0.0) && (thisWorld != None) && (thisWorld != Tamriel) && (thisWorld != DLC1HunterHQWorld) && (thisWorld != DLC2SolstheimWorld)
		Return timeScaleOutdoors
	Else
		Return timeScaleWilderness
	EndIf
EndFunction

Function printTimescale()
	debug.notification("Dynamic TimeScale: " + TimeScale.GetValue())
EndFunction

Function uninstall()
	Utility.Wait(0.001)
	UnregisterForKey(38)
	Self.UnregisterForUpdate()
	dynamicTimeScaleConfig.Stop()
	dynamicTimeScale.Stop()
	TimeScale.SetValue(defaultTimeScale)
	debug.notification("Uninstalling Dynamic TimeScale...")
EndFunction