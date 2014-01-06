local AddOn, Addon = ...
local X = _G[AddOn]['pixel']


local cfg

cfg = {											-- http://wowpedia.org/Console_variables

-- useLocal							= 1,

scriptErrors 						= 1,
taintLog 							= 2,				-- Records taint msgs (file is written periodically & 1x @ logout) Default: 0 --> 0 = No taint data, 1 = Basic taint data, 2 = Full taint data --> /console taintLog 2

--[[PIXELPERFECT]]
useUiScale						= 1,
uiScale							= Addon[1]["UIScale"],		--[[ uiScale = Addon.uiscale, ]] -- T.uiscale, -- min(2, max(.64, 768 / match(GetCVar('gxResolution'), '%d+x(%d+)'))),
gxMultisample						= 1,
--[[/PIXELPERFECT]]

-- actionbars
alwaysShowActionBars 				= 1,				-- Whether to always show the action bar grid. Default: 0

-- buffs
buffDurations 						= 1,				-- Whether to show buff durations. Default: 1
consolidateBuffs 					= 1,				-- This CVar sets whether Buffs and Debuffs should be consolidated in the buffs section of the UI. Default: 0

-- camera
cameraDistanceMax 					= 30,			-- Sets the maximum distance (0-50) which you can zoom out to. Default: 15
cameraDistanceMaxFactor 				= 2,				-- Sets the factor (0-4) by which cameraDistanceMax is multiplied. Default: 1
cameraWaterCollision 				= 1,				-- Enables water collision for the camera. Depending on the player being above or below the water level, the camera will follow.
cameraSmoothStyle 					= 1,				-- Controls the automatic camera adjustment-the 'following style' (0-4). Default: 4 (Adjust camera only when moving.) -- 1 = Adjust camera only horizontal when moving.
screenshotQuality 					= 10,

-- chat
chatStyle  						= 'classic',
conversationMode  					= 'inline',
bnWhisperMode  					= 'inline',
whisperMode 						= 'inline',
chatBubbles 						= 1,
chatBubblesParty 					= 0,
chatMouseScroll 					= 1,
colorChatNamesByClass 				= 1,				--
profanityFilter 					= 0,
removeChatDelay 					= 1,
spamFilter 						= 0,

-- combat											-- showVKeyCastbar = 1, -- UNKNOWN:  /run print('GetCVar(\'showVKeyCastbar\') = ' .. GetCVar('showVKeyCastbar'))
spellActivationOverlayOpacity 		= 1,
threatPlaySounds 					= 1,		--[[NB]]	-- MODIFIED '0' 10.10.2013
threatWarning						= 3,				-- 3 = enhanced threat (somehow) ?

-- combattext
enableCombatText 					= 0,
PetMeleeDamage						= 0,
CombatDamage						= 0,
CombatHealing						= 0,
CombatLogPeriodicSpells				= 0,

-- guild
guildMemberNotify  					= 0,
guildRewardsCategory  				= 0,
guildRewardsUsable  				= 0,
guildRosterView 					= 'playerStatus',	-- The current guild roster display mode (playerStatus, guildStatus, weeklyxp, totalxp, achievement, tradeskill). Default: playerStatus
guildShowOffline 					= 0,				-- Whether to show offline members in the guild UI. Default: 1

-- maps
miniWorldMap						= 1,				-- WorldMap: set smaller version to default

-- mouse
alwaysCompareItems 					= 1,				-- "1" to Always show item comparison tooltips. "0" to Always hide. (0 or 1) Default: 0
lootUnderMouse  					= 0,
UberTooltips  						= 1,
deselectOnClick  					= 0,
interactOnLeftClick  				= 1,

-- names
UnitNameOwn 						= 1,
UnitNameNPC 						= 1,
UnitNameNonCombatCreatureName 		= 0,
UnitNameGuildTitle  				= 0,
UnitNamePlayerGuild 				= 1,
UnitNamePlayerPVPTitle 				= 0,
UnitNameFriendlyPlayerName 			= 1,
UnitNameFriendlyPetName 				= 0,
UnitNameFriendlyGuardianName 			= 0,
UnitNameFriendlyTotemName 			= 0,
UnitNameEnemyPlayerName 				= 1,
UnitNameEnemyPetName 				= 0,
UnitNameEnemyGuardianName 			= 0,
UnitNameEnemyTotemName 				= 1,


-- nameplates
nameplateShowFriends				= 0,
nameplateShowFriendlyPets 			= 0,
nameplateShowFriendlyGuardians 		= 0,
nameplateShowFriendlyTotems 			= 0,
nameplateShowEnemies				= 1,
nameplateShowEnemyPets 				= 0,
nameplateShowEnemyGuardians 			= 0,
nameplateShowEnemyTotems 			= 1,
ShowClassColorInNameplate 			= 1,

-- party
showPartyBackground					= 1,

											--[[
-- raidframes
raidFramesHeight 					= 30,
raidFramesWidth 					= 50,
raidFramesHealthText  				= 'none',
raidFramesDisplayAggroHighlight 		= 0,
raidFramesDisplayClassColor 			= 0,
raidFramesDisplayIncomingHeals 		= 1,				-- 5.4 bug
raidFramesDisplayPowerBars 			= 1,
raidFramesDisplayOnlyDispellableDebuffs	= 0,

-- raidoptions
raidOptionDisplayMainTankAndAssist 	= 1,
raidOptionDisplayPets  				= 0,
raidOptionIsShown  					= 1,
raidOptionKeepGroupsTogether  		= 0,				-- RED
raidOptionLocked  					= 'unlock',		-- Whether the raid frames are locked. When unlocked, you can move the raidframes into a more convenient location. Default: lock
raidOptionShowBorders  				= 1,				-- RED
raidOptionSortMode  				= 'role',			-- How to sort the users (role or group) in the raid frames. Default: role
useCompactPartyFrames 				= 1,				-- This CVar controls the type of party frames used in-game (0 = default partyframes / 1 = raid frame style with 5-man group). Default: 0 ]]

-- unitframes
showArenaEnemyFrames 				= 0,

-- toast
showToastOnline 					= 0,
showToastOffline 					= 0,
showToastBroadcast 					= 0,
showToastConversation 				= 0,
showToastWindow 					= 0,

-- quest
autoQuestWatch 					= 1,
autoQuestProgress 					= 1,
mapQuestDifficulty 					= 1,

-- sound
Sound_EnableAllSound 				= 1,
Sound_EnableMusic 					= 0,
Sound_EnableAmbience 				= 0,
Sound_EnableSoundWhenGameIsInBG 		= 1,

-- other
autoLootDefault 					= 1,
autoDismountFlying 					= 0,
movieSubtitle 						= 0,
showTutorials 						= 0,
timeMgrUseLocalTime					= 1,

-- shestak choices
shadowMode						= 0,
ffxDeath							= 0,
ffxNetherWorld						= 0,

-- floating combat text (fct)
fctLowManaHealth					= 0,
fctReactives						= 0,

}


--==============================================--
--	Events
--==============================================--
local cvar = CreateFrame('Frame')
cvar:RegisterEvent('PLAYER_ENTERING_WORLD')
cvar:SetScript('OnEvent', function(self, event, addon)
	SetMultisampleFormat(1)					-- PixelPerfection requires value to be (1)

	for k, v in pairs(cfg) do
		SetCVar(k, v)
	end

	cfg = nil								-- Release the table

	SetActionBarToggles(1, 1, 1, 1, 1)			-- SetActionBarToggles(bar1, bar2, bar3, bar4, alwaysShow)

	self:UnregisterEvent(event)
end)


--==============================================--
--	Tidyup
--==============================================--
-- do
  -- SetAllowLowLevelRaid(1)
  -- ShowAccountAchievements(1)
  -- SetAutoDeclineGuildInvites(1)


  -- debug
  -- _G[AddOn].print('cvar', 'GetCVar(uiScale)', GetCVar('uiScale'))
-- end


--==============================================--
--	CVar Variables
--==============================================--
--[[ CombatText CVars

	enableCombatText = { text = "SHOW_COMBAT_TEXT_TEXT" },
	fctCombatState = { text = "COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT" },
	fctDodgeParryMiss = { text = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT" },
	fctDamageReduction = { text = "COMBAT_TEXT_SHOW_RESISTANCES_TEXT" },
	fctRepChanges = { text = "COMBAT_TEXT_SHOW_REPUTATION_TEXT" },
	fctReactives = { text = "COMBAT_TEXT_SHOW_REACTIVES_TEXT" },
	fctFriendlyHealers = { text = "COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT" },
	fctComboPoints = { text = "COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT" },
	fctLowManaHealth = { text = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT" },
	fctEnergyGains = { text = "COMBAT_TEXT_SHOW_ENERGIZE_TEXT" },
	fctPeriodicEnergyGains = { text = "COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT" },
	fctHonorGains = { text = "COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT" },
	fctAuras = { text = "COMBAT_TEXT_SHOW_AURAS_TEXT" },

	CombatDamage = { text = "SHOW_DAMAGE_TEXT" },
	CombatLogPeriodicSpells = { text = "LOG_PERIODIC_EFFECTS" },
	PetMeleeDamage = { text = "SHOW_PET_MELEE_DAMAGE" },
	CombatHealing = { text = "SHOW_COMBAT_HEALING" },
	fctSpellMechanics = { text = "SHOW_TARGET_EFFECTS" },
	fctSpellMechanicsOther = { text = "SHOW_OTHER_TARGET_EFFECTS" },
--]]

--[[ UVars
  -- Interface\FrameXML\InterfaceOptionsFrame.lua

	UVARINFO = {
		["REMOVE_CHAT_DELAY"] = { default = "0", cvar = "removeChatDelay", event = "REMOVE_CHAT_DELAY_TEXT" },
		["LOCK_ACTIONBAR"] = { default = "0", cvar = "lockActionBars", event = "LOCK_ACTIONBAR_TEXT" },
		["SHOW_BUFF_DURATIONS"] = { default = "1", cvar = "buffDurations", event = "SHOW_BUFF_DURATION_TEXT", func = function () SHOW_BUFF_DURATIONS = GetCVar("buffDurations"); BuffFrame_UpdatePositions(); end},
		["ALWAYS_SHOW_MULTIBARS"] = { default = "0", cvar = "alwaysShowActionBars", event = "ALWAYS_SHOW_MULTIBARS_TEXT" },
		["SHOW_PARTY_PETS"] = { default = "1", cvar = "showPartyPets", event = "SHOW_PARTY_PETS_TEXT" },
		["SHOW_PARTY_BACKGROUND"] = { default = "0", cvar = "showPartyBackground", event = "SHOW_PARTY_BACKGROUND_TEXT" },
		["SHOW_TARGET_OF_TARGET"] = { default = "0", cvar = "showTargetOfTarget", event = "SHOW_TARGET_OF_TARGET_TEXT" },
		["SHOW_TARGET_OF_TARGET_STATE"] = { default = "5", cvar = "targetOfTargetMode", event = "SHOW_TARGET_OF_TARGET_STATE" },
		["AUTO_QUEST_WATCH"] = { default = "1", cvar = "autoQuestWatch", event = "AUTO_QUEST_WATCH_TEXT" },
		["LOOT_UNDER_MOUSE"] = { default = "0", cvar = "lootUnderMouse", event = "LOOT_UNDER_MOUSE_TEXT" },
		["AUTO_LOOT_DEFAULT"] = { default = "0", cvar = "autoLootDefault", event = "AUTO_LOOT_DEFAULT_TEXT" },

		["SHOW_COMBAT_TEXT"] = { default = "1", cvar = "enableCombatText", event = "SHOW_COMBAT_TEXT_TEXT" },
		["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"] = { default = "1", cvar = "fctLowManaHealth", event = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT" },
		["COMBAT_TEXT_SHOW_AURAS"] = { default = "0", cvar = "fctAuras", event = "COMBAT_TEXT_SHOW_AURAS_TEXT" },
		["COMBAT_TEXT_SHOW_AURA_FADE"] = { default = "0", cvar = "fctAuras", event = "COMBAT_TEXT_SHOW_AURAS_TEXT" },
		["COMBAT_TEXT_SHOW_COMBAT_STATE"] = { default = "0", cvar = "fctCombatState", event = "COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT" },
		["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"] = { default = "0", cvar = "fctDodgeParryMiss", event = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT" },
		["COMBAT_TEXT_SHOW_RESISTANCES"] = { default = "0", cvar = "fctDamageReduction", event = "COMBAT_TEXT_SHOW_RESISTANCES_TEXT" },
		["COMBAT_TEXT_SHOW_REPUTATION"] = { default = "1", cvar = "fctRepChanges", event = "COMBAT_TEXT_SHOW_REPUTATION_TEXT" },
		["COMBAT_TEXT_SHOW_REACTIVES"] = { default = "0", cvar = "fctReactives", event = "COMBAT_TEXT_SHOW_REACTIVES_TEXT" },
		["COMBAT_TEXT_SHOW_FRIENDLY_NAMES"] = { default = "0", cvar = "fctFriendlyHealers", event = "COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT" },
		["COMBAT_TEXT_SHOW_COMBO_POINTS"] = { default = "0", cvar = "fctComboPoints", event = "COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT" },
		["COMBAT_TEXT_SHOW_ENERGIZE"] = { default = "0", cvar = "fctEnergyGains", event = "COMBAT_TEXT_SHOW_ENERGIZE_TEXT" },
		["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"] = { default = "0", cvar = "fctPeriodicEnergyGains", event = "COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT" },
		["COMBAT_TEXT_FLOAT_MODE"] = { default = "1", cvar = "combatTextFloatMode", event = "COMBAT_TEXT_FLOAT_MODE" },
		["COMBAT_TEXT_SHOW_HONOR_GAINED"] = { default = "0", cvar = "fctHonorGains", event = "COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT" },
		["ALWAYS_SHOW_MULTIBARS"] = { default = "0", cvar = "alwaysShowActionBars", },
		["SHOW_CASTABLE_BUFFS"] = { default = "0", cvar = "showCastableBuffs", event = "SHOW_CASTABLE_BUFFS_TEXT" },
		["SHOW_DISPELLABLE_DEBUFFS"] = { default = "1", cvar = "showDispelDebuffs", event = "SHOW_DISPELLABLE_DEBUFFS_TEXT" },
		["SHOW_ARENA_ENEMY_FRAMES"] = { default = "1", cvar = "showArenaEnemyFrames", event = "SHOW_ARENA_ENEMY_FRAMES_TEXT" },
		["SHOW_ARENA_ENEMY_CASTBAR"] = { default = "1", cvar = "showArenaEnemyCastbar", event = "SHOW_ARENA_ENEMY_CASTBAR_TEXT" },
		["SHOW_ARENA_ENEMY_PETS"] = { default = "1", cvar = "showArenaEnemyPets", event = "SHOW_ARENA_ENEMY_PETS_TEXT" },
		["SHOW_ALL_ENEMY_DEBUFFS"] = { default = "0", cvar = "showAllEnemyDebuffs", event = "SHOW_ALL_ENEMY_DEBUFFS_TEXT" },
	}
--]]
