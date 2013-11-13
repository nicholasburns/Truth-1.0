-- credit: Shestak - Announce spellcasts
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2,  ...))
if (not C["Announce"]["Spells"]["Enable"]) then return end


local pairs = pairs
local format = string.format

local UnitName = UnitName
local UnitGUID = UnitGUID
local GetSpellLink = GetSpellLink
local GetInstanceInfo = GetInstanceInfo
local SendChatMessage = SendChatMessage

--==============================================--
--	Whiteboard
--==============================================--
--[[

--[Spells from All Sources]
	|
	+ Cast on --> Nil
	|	|--	Expected:  Source cast [Spell]
	|	|--	Recieved:
	|
	+ Cast on --> Destination
		|
		+==> Cast by Me
		|	|--	Expected:  [My Spell] cast on -> Destination
		|	|--	Recieved:  [Tricks of the Trade] cast on -> Drakani
		|
		|
		+==> NOT Cast by Me
			|--	Expected:  Source cast [Spell] -> Destination
			|--	Recieved:


--[Only My Spells]
	|
	+ Cast on --> Nil
	|	|--	Expected:	[Spell] used
	|	|--	Recieved:
	|
	+ Cast on --> Destination
		|--	Expected: [My Spell] -> Destination
		|--	Recieved:

--]]
--==============================================--
--	Events
--==============================================--
local spellLink

local f = CreateFrame('Frame')
f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
f:SetScript('OnEvent', function(self, event,  ...)
	local spells = C["Announce"]["Spells"]["SpellIDs"]
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID =  ...
	local _, _, difficultyID = GetInstanceInfo()
	if (event ~= 'SPELL_CAST_SUCCESS') then return end
	if (difficultyID == 0) then return end
	if (not (sourceGUID == UnitGUID('player'))) then return end
	if (not sourceName) then return end
	if (not sourceName == A["MyName"]) then return end	-- if (not sourceName == T.myname) then return end


   --[[ Spells from All Sources ]]

	if (C["Announce"]["Spells"]["Allsources"]) then
		for i, spells in pairs(spells) do
			if (spellID == spells) then

			--[[ Cast on --> Nil ]]

				if (destName == nil) then	spellLink = GetSpellLink(spellID)

				--[[ Source cast [Spell] ]]

					SendChatMessage(format('%s used %s', sourceName, spellLink), T.GetAnnounceChannel())															-- SendChatMessage(format(L_ANNOUNCE_SPELL_USE, sourceName, GetSpellLink(spellID)), T.GetAnnounceChannel())

			--[[ Cast on --> Destination ]]

				else						spellLink = GetSpellLink(spellID)

				--[[ Cast by Me ]]

					if (sourceName == UnitName('player')) then

					--[[ [MySpell] cast on -> Destination ]]

						SendChatMessage(format('%s cast on -> %s', spellLink, destName), T.GetAnnounceChannel())														-- SendChatMessage(format(L_ANNOUNCE_SPELL_USE, sourceName, GetSpellLink(spellID) .. ' -> ' .. destName), T.GetAnnounceChannel())

				--[[ NOT Cast by Me ]]

					else

					--[[ Source cast [Spell] -> Destination ]]

						SendChatMessage(format('%ss -> %s', sourceName .. ' used ' .. spellLink, destName), T.GetAnnounceChannel())

					end
				end
			end
		end
	else

	--[[ Only My Spells ]]

		for i, spells in pairs(spells) do
			if (spellID == spells) then

			--[[ Cast on --> Nil ]]

				if (destName == nil) then

				--[[ [Spell] used ]]

					SendChatMessage(GetSpellLink(spellID), T.GetAnnounceChannel())

			--[[ Cast on --> Destination ]]

				else

				--[[ Player used [MySpell] -> Destination ]]

					SendChatMessage(GetSpellLink(spellID) .. ' -> ' .. destName, T.GetAnnounceChannel())

				end
			end
		end
	end
end)


--==============================================--
--	Backup
--==============================================--
--[[
local L_ANNOUNCE_SPELL_USE = '%s used %s'			-- revert:  '%s used a %s.'
local L_MY_PLAYER_NAME = A["MyName"]
local SpellList = {
	34477,	-- Misdirection
	19801,	-- Tranquilizing Shot
	57934,	-- Tricks of the Trade
	633,		-- Lay on Hands
	20484,	-- Rebirth
	113269,	-- Rebirth (Symbiosis)
	61999,	-- Raise Ally
	20707,	-- Soulstone
	2908,	-- Soothe
	120668,	-- Stormlash Totem
	16190,	-- Mana Tide Totem
	64901,	-- Hymn of Hope
	108968,	-- Void Shift
}
--]]



--==============================================--
--	Badgear (check for badgear in instance)
--==============================================--
--[[ Low-Interest Feature (currently) - Keep it for later

	local BadgearList = {
		[1] = {		-- Head
			88710,	-- Nat's Hat
			33820,	-- Weather-Beaten Fishing Hat
			19972,	-- Lucky Fishing Hat
			46349,	-- Chef's Hat
			92738,	-- Safari Hat
		},
		[2] = {		-- Neck
			32757,	-- Blessed Medallion of Karabor
		},
		[8] = {		-- Feet
			50287,	-- Boots of the Bay
			19969,	-- Nat Pagle's Extreme Anglin' Boots
		},
		[15] = {		-- Back
			65360,	-- Cloak of Coordination
			65274,	-- Cloak of Coordination
		},
		[16] = {		-- Main-Hand
			44050,	-- Mastercraft Kalu'ak Fishing Pole
			19970,	-- Arcanite Fishing Pole
			84660,	-- Pandaren Fishing Pole
			84661,	-- Dragon Fishing Pole
			45992,	-- Jeweled Fishing Pole
			86559,	-- Frying Pan
			45991,	-- Bone Fishing Pole
		},
		[17] = {		-- Off-hand
			86558,	-- Rolling Pin
		},
	}

	local badgear = CreateFrame('Frame')
	badgear:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	badgear:SetScript('OnEvent', function()
		if (not IsInInstance()) then return end

		local item = {}
		for i = 1, 17 do
			if (BadgearList[i] ~= nil) then
				item[i] = GetInventoryItemID('player', i) or 0

				for j, baditem in pairs(BadgearList[i]) do

					if (item[i] == baditem) then
						PlaySound('RaidWarning', 'master')
						RaidNotice_AddMessage(RaidWarningFrame, format('%s %s', CURRENTLY_EQUIPPED, GetItemInfo(item[i]) .. '!!!'), ChatTypeInfo['RAID_WARNING'])

						print(format('|cffff3300%s %s', CURRENTLY_EQUIPPED, GetItemInfo(item[i]) .. '!!!|r'))
					end
				end
			end
		end
	end)
--]]
