-- credit: Shestak - Announce your interrupts
local AddOn, Addon =  ...
local A, C, T, L = unpack(select(2,  ...))
if (not C["Announce"]["Interrupts"]["Enable"]) then return end
local print = function(...) Addon.print('interrupts', ...) end



--==============================================--
--	Whiteboard
--==============================================--
--[[

[Only My Spells]

	Cast on --> Nil

	  |--	Expected:
	  |--	Recieved:

	Cast on --> Player

	  |--	Expected:
	  |--[I]	Recieved:  Interrupted Seabasz-GrizzlyHills's [Touch of Y'Shaarj]!	<-- Player
	  |--[P]	Recieved:
	  |--[R]	Recieved:
	  |--[S]	Recieved:  Interrupted [Rend Soul] -> Shao-Tien Soul-Caller		<-- NPC
	  |--[S]	Recieved:  Interrupted Shao-Tien Antiquator's [Icy Destruction]!		<-- NPC

--]]
--==============================================--
--	Interrupts
--==============================================--
local divider = ' -> '
local channel
local spellLink

do
	local IsInGroup  = IsInGroup
	local IsInRaid   = IsInRaid
	local IsPartyLFG = IsPartyLFG
	local UnitGUID   = UnitGUID
	local SendChatMessage = SendChatMessage

	local f = CreateFrame('Frame')
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:SetScript('OnEvent', function(self, event,  ...)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID, spellName =  ...
		if (not (event == 'SPELL_INTERRUPT' and sourceGUID == UnitGUID('player'))) then return end

		spellLink = ' \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r'


	  -- Instance
		if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'

	  -- Party
		elseif (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'

	  -- Raid
		elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then					-- LE_PARTY_CATEGORY_HOME - Checks for home-realm parties
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'RAID'

	  -- Solo
		else
			channel = 'SAY'
		end


	  -- Interrupted [Icy Destruction] -> Shao-Tien Antiquator
		SendChatMessage(INTERRUPTED .. spellLink .. divider .. destName, channel)
	end)
end


--==============================================--
--	Reference
--==============================================--
--[[ For Future [ ElvUI\modules\misc\misc.lua ]

local elv = CreateFrame('Frame')
elv:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
elv:SetScript('OnEvent', function(self, event,  ...)
	local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID, spellName = ...
	if (not (event == 'SPELL_INTERRUPT' and sourceGUID == UnitGUID('player'))) then return end

	local inGroup = IsInGroup()
	local inRaid  = IsInRaid()

	if (E.db.general.interruptAnnounce == 'PARTY' and inGroup) then
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r!', IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
	elseif (E.db.general.interruptAnnounce == 'RAID' and inGroup) then
		if (inRaid) then
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r!', IsPartyLFG() and 'INSTANCE_CHAT' or 'RAID')
		else
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r!', IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
		end
	elseif E.db.general.interruptAnnounce == 'SAY' and inGroup then
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r', 'SAY')
	end
end
--]]
--==============================================--
--	Example Function  [ AsphyxiaUI/Toolkit.lua ]
--==============================================--
--[[
function A.CheckChatChannels( warning )

	if( IsInGroup( LE_PARTY_CATEGORY_INSTANCE ) ) then
		return "INSTANCE_CHAT"

	elseif( IsInRaid( LE_PARTY_CATEGORY_HOME ) ) then

		if( warning and ( UnitIsGroupLeader( "player" ) or UnitIsGroupAssistant( "player" ) or IsEveryoneAssistant() ) ) then
			return "RAID_WARNING"
		else
			return "RAID"
		end

	elseif( IsInGroup( LE_PARTY_CATEGORY_HOME ) ) then
		return "PARTY"
	end

	return "SAY"
end
--]]


--==============================================--
--	COMBAT_LOG_EVENT_UNFILTERED
--==============================================--
--[[	Arguments:
	---------
	timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...


	Returns:
	--------
	timeStamp 		- The time on the server that the event occurred (number)
	event 			- The name of the combat sub-event that occurred (string)
	hideCaster 		- The purpose of this boolean flag is currently unknown (boolean)
	sourceGUID 		- A string containing the hexadecimal representation of the source of the event's GUID (string, GUID)
	sourceName 		- The name of the source of the event (string)
	sourceFlags 		- A bitfield containing information about the source of the event (number, bitfield)
	sourceRaidFlags	- Added in Patch 4.2 (number, bitfield)
	destGUID 			- A string containing the hexadecimal representation of the destination of the event's GUID (string, GUID)
	destName 			- The name of the destination of the event (string)
	destFlags 		- A bitfield containing information about the destination of the event (number, bitfield)
	destRaidFlags 		- Added in Patch 4.2 (number, bitfield)
	... 				- A list of additional arguments, dependent on the particular combat sub-event. See Chapter 21 for more detailed information (varies)
--]]


--==============================================--
--	Backup
--==============================================--
--[[
	local f = CreateFrame('Frame')
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:SetScript('OnEvent', function(self, event,  ...)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID, spellName =  ...
		if (not (event == 'SPELL_INTERRUPT' and sourceGUID == UnitGUID('player'))) then return end


		-- local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)	-- http://wowprogramming.com/docs/api/IsInGroup

		-- if (inInstanceGroup) then
			-- channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'

		-- elseif (IsInGroup()) then
			-- channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'

		-- elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then					-- LE_PARTY_CATEGORY_HOME - Checks for home-realm parties
			-- channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'RAID'

		-- else
			-- channel = 'SAY'
		-- end


		-- SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r!', channel)


		if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then					-- LE_PARTY_CATRGORY_INSTANCE - Checks for instance-specific groups
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'
		  -- channel = 'INSTANCE_CHAT'

		elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then					-- LE_PARTY_CATEGORY_HOME - Checks for home-realm parties
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'RAID'
		  -- channel = 'RAID'

		elseif (IsInGroup(LE_PARTY_CATEGORY_HOME)) then					-- LE_PARTY_CATEGORY_HOME - Checks for home-realm parties
			channel = IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY'
		  -- channel = 'PARTY'

		else
			channel = 'SAY'
		  -- channel = 'SAY'
		end


		SendChatMessage(INTERRUPTED .. ' ' .. destName .. '\'s \124cff71d5ff\124Hspell:' .. spellID .. '\124h[' .. spellName .. ']\124h\124r!', channel)
	  -- SendChatMessage(INTERRUPTED .. ' ' .. destName .. ': ' .. GetSpellLink(spellID), channel)
	end)


--]]
--[[
	local f = CreateFrame('Frame')
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:SetScript('OnEvent', function(self, event,  ...)

		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID =  ...


		--====================================--
		-- Escape
		--====================================--
		if (not (event == 'SPELL_INTERRUPT' and sourceGUID == UnitGUID('player'))) then
			return
		end


		--====================================--
		-- VERSION I
		-- Create code to determine correct channel
		--====================================--
		if (IsInRaid()) then
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. ': ' .. GetSpellLink(spellID), "RAID")
		elseif (IsInGroup()) then
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. ': ' .. GetSpellLink(spellID), "PARTY")
		else
			SendChatMessage(INTERRUPTED .. ' ' .. destName .. ': ' .. GetSpellLink(spellID), "SAY")
		end


		--====================================--
		-- VERSION II
		-- Rely on T.GetAnnounceChannel()
		-- to determine correct channel
		--====================================--
		SendChatMessage(INTERRUPTED .. ' ' .. destName .. ': ' .. GetSpellLink(spellID), T.GetAnnounceChannel())
	end)
--]]
