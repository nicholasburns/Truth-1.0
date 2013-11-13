local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Sounds"]["Enable"]) then return end
local print = function(...) Addon.print('sounds', ...) end

local PlaySoundFile = PlaySoundFile



-- Constant
local name = UnitName('player')
local soundpath = [=[Interface\AddOns\]=] .. AddOn .. [=[\media\sound\]=]
--[[	sound = {
		['acquire']	= SOUND_PATH .. 'acquire.mp3',
		['electronic']	= SOUND_PATH .. 'estring.mp3',
		['error']		= SOUND_PATH .. 'error.mp3',
		['msn']		= SOUND_PATH .. 'msn.mp3',
		['warn']		= SOUND_PATH .. 'warn.ogg',
		['fwarn']		= SOUND_PATH .. 'fwarn.mp3',
		['whisper']	= SOUND_PATH .. 'whisper.mp3',	-- Addon.media.sound.whisper
		['yoshi']		= SOUND_PATH .. 'yoshi.mp3',
		['zelda']		= SOUND_PATH .. 'zelda.mp3',
	},
--]]
local EventSounds = {
	['CHAT_MSG_GUILD'] 			= 'acquire',
	['CHAT_MSG_OFFICER'] 		= 'acquire',

	['CHAT_MSG_INSTANCE']		= 'switchy',
	['CHAT_MSG_INSTANCE_LEADER']	= 'doublehit',

	['CHAT_MSG_PARTY'] 			= 'electronic',
	['CHAT_MSG_PARTY_LEADER'] 	= 'electronic',

	['CHAT_MSG_RAID'] 			= 'whisper',
	['CHAT_MSG_RAID_LEADER'] 	= 'whisper',

	['CHAT_MSG_WHISPER'] 		= 'msn',
	['CHAT_MSG_BN_WHISPER'] 		= 'msn',
	['CHAT_MSG_REALID']			= 'zelda',

	['CHAT_MSG_CHANNEL']		=  true, 								-- dummy
}


--==============================================--
--	Events
--==============================================--
local s = CreateFrame('Frame')
s:RegisterEvent('CHAT_MSG_CHANNEL')
s:SetScript('OnEvent', function(self, event, ...)

	local msg, author, lang, channel = ...								-- if (author == name) then --[[ return ]] end

	if (event ~= 'CHAT_MSG_CHANNEL') then
		local sound = soundpath .. EventSounds[event] .. '.mp3'

		PlaySoundFile(sound, 'Master')								-- print('<sounds> PlaySoundFile: ' .. sound)
	end

end)

for event, sound in pairs(EventSounds) do
	s:RegisterEvent(event)
end


--==============================================--
--	Whisper Notifications
--==============================================--
local w = CreateFrame('Frame')
w:RegisterEvent('CHAT_MSG_WHISPER')
w:RegisterEvent('CHAT_MSG_BN_WHISPER')
w:SetScript('OnEvent', function(self, event)

	--[[ PlaySoundFile('sndFile', ['sndChannel'])
		---------------------------------------------------------------------------
		● sndFile 	A path to the sound file to be played (string)
		● sndChannel 	Which of the following volume sliders the sound should use:
				 --> SFX, Music, Ambience, Master (string)
	--]]

	if (event == 'CHAT_MSG_WHISPER' or event == 'CHAT_MSG_BN_WHISPER') then
		PlaySoundFile(Addon.media.sound.whisper, 'Master')
	end

end)


--================================================================================================--
--[[ Playable Game Sounds List (not all produce sound)
	-------------------------------------------------
	PVPENTERQUEUE 					- Sound for entering BG queue and when it refreshes periodicly
	PVPTHROUGHQUEUE 				- You are eligible to enter the battleground!

	GLUESCREENSMALLBUTTONMOUSEDOWN
	GLUESCREENSMALLBUTTONMOUSEUP
	GLUESCREENSMALLBUTTONMOUSEOVER
	GLUESCREENMEDIUMBUTTONMOUSEDOWN
	GLUESCREENMEDIUMBUTTONMOUSEUP
	GLUESCREENMEDIUMBUTTONMOUSEOVER
	GLUESCREENLARGEBUTTONMOUSEDOWN
	GLUESCREENLARGEBUTTONMOUSEUP
	GLUESCREENLARGEBUTTONMOUSEOVER
	GLUESCREENEDITBOXKEYCLICK
	GLUECHECKBOXMOUSEDOWN
	GLUECHECKBOXMOUSEUP
	GLUECHECKBOXMOUSEOVER
	GLUECHARCUSTOMIZATIONMOUSEDOWN
	GLUECHARCUSTOMIZATIONMOUSEUP
	GLUECHARCUSTOMIZATIONMOUSEOVER
	GLUESCROLLBUTTONMOUSEDOWN
	GLUESCROLLBUTTONMOUSEUP
	GLUESCROLLBUTTONMOUSEOVER

	GAMEABILITYBUTTONMOUSEDOWN
	GAMESPELLBUTTONMOUSEDOWN
	GAMEWINDOWOPEN
	GAMEWINDOWCLOSE
	GAMEDIALOGOPEN
	GAMEDIALOGCLOSE
	GAMENEWWINDOWTAB
	GAMESCREENSMALLBUTTONMOUSEDOWN
	GAMESCREENSMALLBUTTONMOUSEUP
	GAMESCREENSMALLBUTTONMOUSEOVER
	GAMESCREENMEDIUMBUTTONMOUSEDOWN
	GAMESCREENMEDIUMBUTTONMOUSEUP
	GAMESCREENMEDIUMBUTTONMOUSEOVER
	GAMESCREENLARGEBUTTONMOUSEDOWN
	GAMESCREENLARGEBUTTONMOUSEUP
	GAMESCREENLARGEBUTTONMOUSEOVER
	GAMETARGETFRIENDLYUNIT
	GAMETARGETHOSTILEUNIT
	GAMETARGETNEUTRALUNIT
	GAMEHIGHLIGHTFRIENDLYUNIT
	GAMEHIGHLIGHTHOSTILEUNIT
	GAMEHIGHLIGHTNEUTRALUNIT
	GAMEINITIALATTACK
	GAMEERROROUTOFRANGE
	GAMEERROROUTOFMANA
	GAMEERRORUNABLETOEQUIP
	GAMEERRORINVALIDTARGET

	ACTIONBARBUTTONDOWN

	MAINBUTTONBARMENU

	MINIMAPZOOMOUT
	MINIMAPZOOMIN
	MINIMAPOPEN
	MINIMAPCLOSE

	BAGMENUBUTTONPRESS

	LOOTWINDOWOPEN
	LOOTWINDOWCLOSE
	LOOTWINDOWCOINSOUND

	ITEMWEAPONSOUND
	ITEMARMORSOUND
	ITEMGENERICSOUND

	LEVELUPSOUND

	GLUECREATECHARACTERBUTTON
	GLUEENTERWORLDBUTTON

	SPELLBOOKOPEN
	SPELLBOOKCLOSE
	SPELLBOOKCHANGEPAGE

	PAPERDOLLOPEN
	PAPERDOLLCLOSE

	QUESTADDED
	QUESTCOMPLETED
	QUESTLOGOPEN
	QUESTLOGCLOSE

	GLUEGENERICBUTTONPRESS
	GAMEGENERICBUTTONPRESS

	INTERFACESOUND_MONEYFRAMEOPEN
	INTERFACESOUND_MONEYFRAMECLOSE
	INTERFACESOUND_CHARWINDOWOPEN
	INTERFACESOUND_CHARWINDOWCLOSE
	INTERFACESOUND_CHARWINDOWTAB
	INTERFACESOUND_GAMEMENUOPEN
	INTERFACESOUND_GAMEMENUCLOSE
	INTERFACESOUND_LOSTTARGETUNIT
	INTERFACESOUND_BACKPACKOPEN
	INTERFACESOUND_BACKPACKCLOSE
	INTERFACESOUND_GAMESCROLLBUTTON
	INTERFACESOUND_CURSORGRABOBJECT
	INTERFACESOUND_CURSORDROPOBJECT

	SHEATHINGSHIELDSHEATHE
	SHEATHINGWOODWEAPONSHEATHE
	SHEATHINGMETALWEAPONSHEATHE
	SHEATHINGWOODWEAPONUNSHEATHE
	SHEATHINGMETALWEAPONUNSHEATHE
	SHEATHINGSHIELDUNSHEATHE

	igCreatureAggroDeselect
	igQuestListOpen
	igQuestListClose
	igQuestListSelect
	igQuestListComplete
	igQuestCancel
	igPlayerInvite
	igPlayerInviteAccept
	igPlayerInviteDecline

	GAMEERRORUNABLETOEQUIP

	ITEMGENERICSOUND

	GAMEERRORINVALIDTARGET

	LEVELUP

	GAMEERROROUTOFRANGE

	QUESTADDED

	MONEYFRAMEOPEN
	MONEYFRAMECLOSE

	LOOTWINDOWOPEN
	LOOTWINDOWCLOSE
	LOOTWINDOWCOINSOUND

	GAMEHIGHLIGHTHOSTILEUNIT
	GAMEHIGHLIGHTNEUTRALUNIT
	GAMEHIGHLIGHTFRIENDLYUNIT

	INTERFACESOUND_LOSTTARGETUNIT
	INTERFACESOUND_CURSORGRABOBJECT
	INTERFACESOUND_CURSORDROPOBJECT

	GAMESCREENMEDIUMBUTTONMOUSEDOWN
	GAMEABILITYACTIVATE
	GAMESPELLACTIVATE

	gsTitleEnterWorld
	gsTitleOptions
	gsTitleQuit
	gsTitleCredits
	gsTitleIntroMovie
	gsTitleOptionScreenResolution
	gsTitleOption16bit
	gsTitleOption32bit
	gsTitleOptionOpenGL
	gsTitleOptionDirect3D
	gsTitleOptionFullScreenMode
	gsTitleOptionOK
	gsTitleOptionExit
	gsLogin
	gsLoginNewAccount
	gsLoginChangeRealm
	gsLoginExit
	gsLoginChangeRealmOK
	gsLoginChangeRealmSelect
	gsLoginChangeRealmCancel
	gsCharacterSelection
	gsCharacterSelectionEnterWorld
	gsCharacterSelectionDelCharacter
	gsCharacterSelectionAcctOptions
	gsCharacterSelectionExit
	gsCharacterSelectionCreateNew
	gsCharacterCreationClass
	gsCharacterCreationRace
	gsCharacterCreationGender
	gsCharacterCreationLook
	gsCharacterCreationCreateChar
	gsCharacterCreationCancel

	igCurrentActiveSpell
	igMiniMapOpen
	igMiniMapClose
	igMiniMapZoomIn
	igMiniMapZoomOut
	igChatEmoteButton
	igChatScrollUp
	igChatScrollDown
	igChatBottom
	igSpellBookOpen
	igSpellBookClose
	igSpellBokPageTur n
	igSpellBookSpellIconPickup
	igSpellBookSpellIconDrop
	igAbilityOpen
	igAbilityClose
	igAbiliityPageTurn
	igAbilityIconPickup
	igAbilityIconDrop

	TalentScreenOpen
	TalentScreenClose

	igCharacterInfoOpen
	igCharacterInfoClose
	igCharacterInfoTab
	igCharacterInfoScrollUp
	igCharacterInfoScrollDown
	igQuestLogOpen
	igQuestLogClose
	igQuestLogAbandonQuest
	igQuestFailed
	igSocialOepn (sic)
	igSocialClose
	igMainMenuOpen
	igMainMenuClose
	igMainMenuOption
	igMainMenuLogout
	igMainMenuQuit
	igMainMenuContinue
	igMainMenuOptionCheckBoxOn
	igMainMenuOptionCheckBoxOff
	igMainMenuOptionFaerTab
	igInventoryOepn (sic)
	igInventoryClose
	igInventoryRotateCharacter
	igBackPackOpen
	igBackPackClose
	igBackPackCoinSelect
	igBackPackCoinOK
	igBackPackCoinCancel
	igCharacterNPCSelect
	igCharacterNPCDeselect
	igCharacterSelect
	igCharacterDeselect
	igCreatureNeutralSelect
	igCreatureNeutralDeselect
	igCreatureAggroSelect

	UChatScrollButton

	Deathbind Sound

	LOOTWINDOWOPENEMPTY

	TaxiNodeDiscovered

	UnwrapGift

	TellMessage

	WriteQuest

	MapPing

	igBonusBarOpen

	FriendJoinGame

	Fishing Reel in

	HumanExploration
	OrcExploration
	UndeadExploration
	TaurenExploration
	TrollExploration
	NightElfExploration
	GnomeExploration
	DwarfExploration

	igPVPUpdate

	ReadyCheck
	RaidWarning

	AuctionWindowOpen
	AuctionWindowClose
--]]
--================================================================================================--
