local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["Text"]) then return end
local print = function(...) Addon.print('text', ...) end
local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']









--==============================================--
--	Hide PVP text
--==============================================--
if (not C["Tooltip"]["Text"]["PvP"]) then
  -- PVP_ENABLED = 'PvP'
	PVP_ENABLED = ''
end


--==============================================--
-- Hide Realm text - 5.4
--==============================================--
if (not C["Tooltip"]["Text"]["Realms"]) then
  -- COALESCED_REALM_TOOLTIP = "Coalesced Realm (*)\nGroup, Whisper";
	COALESCED_REALM_TOOLTIP = ""

  -- INTERACTIVE_REALM_TOOLTIP = "Interactive Realm (#)\nYou can interact with this player as if they were on your own realm";
	INTERACTIVE_REALM_TOOLTIP = ""
end












--==============================================--
--	Different Method (works identically)
--==============================================--
--[[
local t = CreateFrame('Frame')
t:RegisterEvent('ADDON_LOADED')
t:SetScript('OnEvent', function(self, event, ao)
	if (event == 'ADDON_LOADED') then
		if (ao == 'Blizzard_CombatLog') then
			-- Hide PVP text
			PVP_ENABLED = ''					-- PVP_ENABLED = 'PvP'

			-- Hide Realm text - 5.4
			COALESCED_REALM_TOOLTIP = ""			-- COALESCED_REALM_TOOLTIP = "Coalesced Realm (*)\nGroup, Whisper";
			INTERACTIVE_REALM_TOOLTIP = ""		-- INTERACTIVE_REALM_TOOLTIP = "Interactive Realm (#)\nYou can interact with this player as if they were on your own realm";
		end
	end
end)
--]]
--==============================================--
--	Non-Working Methods
--==============================================--
--[[
	-- Hide Faction text
	if (not C["Tooltip"].text.faction) then
		FACTION_ALLIANCE = ''
		FACTION_HORDE = ''
	end

	-- Hide Level text
	if (not C["Tooltip"].text.level) then
		TOOLTIP_UNIT_LEVEL = ''
		TOOLTIP_WILDBATTLEPET_LEVEL_CLASS = ''
	end


	-- Hide PVP & Faction text
	for i = 2, GameTooltip:NumLines() do
		local line = _G['GameTooltipTextLeft' .. i]
		local text = line:GetText()

		if (text == PVP_ENABLED) or (text == FACTION_ALLIANCE or text == FACTION_HORDE) then
			line:SetText(nil)
		end
	end
--]]
--==============================================--
--	Backup
--==============================================--
--[[ C.Config.Tooltip = {
	['ANCHOR_NONE']		= false,	-- Tooltip appears in the default position (bottom-right corner)
	['ANCHOR_CURSOR']		= true,	-- Anchor tooltip to cursor
	['SMART_ANCHOR']		= false,

	['PVP']				= true,	-- Display player pvp status
	['FACTION']			= true,	-- Dispaly player faction
	['LEVEL']				= true,	--

	['TITLES']			= true,	-- Display player titles
	['REALMS']			= true,	-- Display player realms
	['SPECIALIZATION']		= true,	-- Display the players talent spec in the tooltip
	['RANKS'] 			= true,	-- Display guild ranks if a unit is guilded

	['ITEM_COUNT'] 		= false,	-- Display how many of a certain item you have in your possession
	['ITEM_ID']			= true,	-- Display the spellID in spell mouseovers
	['SPELL_ID'] 			= true,	-- Display the spellID in spell mouseovers

  -- ['UNITFRAMES']			= false,	-- Display the tooltip when mousing over a unitframe
  -- ['WHOS_TARGET'] 		= false,	-- When in a raid group display if anyone in your raid is targetting the current tooltip unit
  -- ['COMBAT_HIDE'] 		= false,	-- Hide tooltip while in combat
}
--]]

--[[ GlobalStrings
	---------------------------------------------
	FACTION_ALLIANCE 				= 'Alliance',		-- Faction
	FACTION_HORDE    				= 'Horde',		-- Faction
	PVP_ENABLED 					= 'PvP',			-- PvP
	TOOLTIP_UNIT_LEVEL				= 'Level %s',		-- Level
	TOOLTIP_WILDBATTLEPET_LEVEL_CLASS	= 'Pet Level %s %s'	-- Level (Pet)
--]]


--==============================================--
--	Unit Status
--==============================================--
--[[	if (UnitIsDead(self.unit)) then
		parent.portrait:SetVertexColor()

	elseif (UnitIsGhost(self.unit)) then
		parent.portrait:SetVertexColor()
	end
--]]

--==============================================--
--	GetUnitName (Blizzard Function Reference)
--==============================================--
--[[	GetUnitName
	---------------------------------------------
	Returns a string summarizing a unit's name and server

	nameString = GetUnitName("unit", showServerName)
	  ●  unit - Unit to query (string, unitID)
	  ●  showServerName - True to include the server name in the return value if the unit is not from the same server as the player; false to only include a short label in such circumstances (boolean)

	nameString (string) - The unit's name, possibly followed by the name of the unit's home server or a label indicating the unit is not from the player's server

	--------------------------------------------- -- UnitFrame.lua
	function GetUnitName(unit, showServerName)

		local name, server = UnitName(unit)

		if (server and server ~= '') then
			if (showServerName) then
				return name..' - '..server
			else
				return name .. FOREIGN_SERVER_LABEL
			end
		else
			return name
		end
	end
--]]