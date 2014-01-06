local AddOn, Addon = ...																-- credit: RepWatch | by Greenhorns on Vek'Nilash
local A, C, T, L = unpack(select(2, ...))
if (not C["Announce"]["Reputation"]["Enable"]) then return end
local print = function(...) Addon.print('reputation', ...) end
local select, unpack, ceil = select, unpack, math.ceil





local Announcements
local EventCounter
local RunningTotal
local Timestamp

--==============================================--
--	Guild Name Parser
--==============================================--
local GetGuildName = function()
	local guildindex

	for i = 1, GetNumFactions() do
		local name, _, _, _, _, _, _, _, isHeader = GetFactionInfo(i)

		if (isHeader and name == 'Guild') then
			guildindex = i + 1
		end
	end
	local name = GetFactionInfo(guildindex)

	return name
end

--==============================================--
--	Reputation Handler
--==============================================--
local ProcessRepEvent = function(faction, amt)											-- @[use]:	ProcessRepEvent("The Black Prince", 50)
	EventCounter = EventCounter + 1
  -- RunningTotal = RunningTotal + amt
	Timestamp = date()

	local index
	local curr_standing
	local next_standing

	if (faction == 'Guild') then
		faction = GetGuildName()
	end

	for factionIndex = 1, (GetNumFactions()) do
		local n = GetFactionInfo(factionIndex)
		if (n == faction) then
			index = factionIndex
		end
	end

	local faction_name, _, standingId, _, topValue, earnedValue = GetFactionInfo(index)

	curr_standing = _G['FACTION_STANDING_LABEL' .. standingId]

	if (standingId < 8) then
		next_standing = _G['FACTION_STANDING_LABEL' .. standingId + 1]
	end
	if (standingId == 8) then
		next_standing = 'Repcap'
	end


	if (TruthDB["Reputation"]["Announcements"]) then
		local a, b, c
		local remaining_rep = topValue - earnedValue
		local remaining_numevents = ceil((topValue - earnedValue) / amt)

		----------------------------------------------------------------------------------------------------
		--	Reputation with The Black Prince increased by 50. --> Blizzard message
		--	Honored with The Black Prince. Revered in 1293 rep [26]
		--[[ Honored with Orgrimar.		]]--	curr_standing .. ' with ' .. faction_name .. '. '
		--[[ Revered in 1293 reputation	]]--	next_standing .. ' in ' .. remaining_rep .. ' reputation '
		--[[ [26]						]]--	'[' .. remaining_numevents .. ']'

		a = curr_standing .. ' with ' .. faction_name .. '. '
		b = next_standing .. ' in ' .. remaining_rep .. ' reputation '
		c = '[' .. remaining_numevents .. ']'

		DEFAULT_CHAT_FRAME:AddMessage('|cff82ffc5' .. a .. '|r|cffffffff' .. b .. c .. '|r')
	end
end


local function InitDB()
	TruthDB["Reputation"]["Timestamp"] = date()
	TruthDB["Reputation"]["Announcements"] = true
	TruthDB["Reputation"]["EventCounter"] = 0
end


--==============================================--
--	Events
--==============================================--
local pew = CreateFrame('Frame', nil, PlayerFrame)
pew:RegisterEvent('PLAYER_ENTERING_WORLD')
pew:SetScript('OnEvent', function(self, event, a1, a2, a3)

	if (event == 'PLAYER_ENTERING_WORLD') then

		if (TruthDB["Reputation"]) then
			TruthDB["Reputation"]["Timestamp"]		= TruthDB["Reputation"]["Timestamp"]
			TruthDB["Reputation"]["Announcements"]	= TruthDB["Reputation"]["Announcements"]
			TruthDB["Reputation"]["EventCounter"]	= TruthDB["Reputation"]["EventCounter"]

			Timestamp		= TruthDB["Reputation"]["Timestamp"]
			Announcements	= TruthDB["Reputation"]["Announcements"]
			EventCounter	= TruthDB["Reputation"]["EventCounter"]
		else
			TruthDB["Reputation"] = {}
			TruthDB["Reputation"]["Timestamp"] = date()
			TruthDB["Reputation"]["Announcements"] = true
			TruthDB["Reputation"]["EventCounter"] = 0
		end

	end

	if (event == 'PLAYER_LOGOUT') then
		TruthDB["Reputation"]["Timestamp"] = Timestamp
		TruthDB["Reputation"]["Announcements"] = Announcements
		TruthDB["Reputation"]["EventCounter"] = EventCounter
	end

end)

--==============================================--
--	Rep
--==============================================--
local reps = CreateFrame('Frame', nil, PlayerFrame)
reps:RegisterEvent('COMBAT_TEXT_UPDATE')
reps:SetScript('OnEvent', function(self, event, a1, a2, a3)
	if (event == 'COMBAT_TEXT_UPDATE' and a1 == 'FACTION') then
		-- EventCounter = EventCounter + 1
		TruthDB["Reputation"]["EventCounter"] = TruthDB["Reputation"]["EventCounter"] + 1

		ProcessRepEvent(a2, a3)
	end
end)

--==============================================--
--	Slash
--==============================================--
SlashCmdList['TRUTH_REP'] = function(msg)
	if (msg == 'on') then
		TruthDB["Reputation"]["Announcements"] = true

		print('Faction Update Reports:', 'ON')
	end
	if (msg == 'off') then
		TruthDB["Reputation"]["Announcements"] = false

		print('Faction Update Reports:', 'OFF')
	end
	if (msg == 'reset') then
		InitDB()

		print('Data Reset:', 'Successful')
	end

end
SLASH_TRUTH_REP1 = '/rep'


--==============================================--
--	Backup
--==============================================--
--[[ DB

	local tbl = {
		Reputation = {
			['EVENT_COUNTER'] = 0,
			['EVENT_TIMESTAMP'] = '',
			['EVENT_ANNOUNCEMENTS'] = true,
		},
	}
--]]

--[[ GetFactionInfo(index1)

	---------------------------------------------
	--	Linear
	---------------------------------------------
	name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(index1)

	---------------------------------------------
	--	Staggered
	---------------------------------------------
	name, description, standingId,
	bottomValue, topValue, earnedValue,
	atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(index1)
 --]]