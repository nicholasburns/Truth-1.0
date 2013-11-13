-- Credit: RepWatch | by Greenhorns on Vek'Nilash
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Peputation"]) then return end
local print = function(...) Addon.print('reputation', ...) end
local select, unpack, ceil = select, unpack, math.ceil






-- local db 						= TruthDB.Reputation
-- local EVENT_ANNOUNCEMENTS 			= db.EVENT_ANNOUNCEMENTS		-- Hide messages from chat
-- local EVENT_COUNTER 				= db.EVENT_COUNTER			-- Number of reputation earning EVENT_COUNTER (kills / turn-ins)
-- local EVENT_TIMESTAMP 			= db.EVENT_TIMESTAMP		-- Your amount of reputation (currently) with a faction (1100 / 3000)


-- DB
if (not TruthDB.Reputation) then
	TruthDB.Reputation = {}
end


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
local ProcessRepEvent = function(faction, amt)
  -- @[use]:	ProcessRepEvent("The Black Prince", 50)

	TruthDB.Reputation.EVENT_COUNTER	= TruthDB.Reputation.EVENT_COUNTER + 1
	TruthDB.Reputation.EVENT_TIMESTAMP	= TruthDB.Reputation.EVENT_TIMESTAMP + amt

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


	if (not TruthDB.Reputation.EVENT_ANNOUNCEMENTS) then
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

--==============================================--
--	Events
--==============================================--
local pew = CreateFrame('Frame', nil, PlayerFrame)
pew:RegisterEvent('PLAYER_ENTERING_WORLD')
pew:SetScript('OnEvent', function(self, event, a1, a2, a3)
	if (event == 'PLAYER_ENTERING_WORLD') then
		if (not TruthDB.Reputation.EVENT_COUNTER) then
			TruthDB.Reputation.EVENT_COUNTER = 0
		end
		if (not TruthDB.Reputation.EVENT_TIMESTAMP) then
			TruthDB.Reputation.EVENT_TIMESTAMP = 0
		end
		if (not TruthDB.Reputation.EVENT_ANNOUNCEMENTS) then
			TruthDB.Reputation.EVENT_ANNOUNCEMENTS = true
		end
	end
end)

--==============================================--
--	Rep
--==============================================--
local reps = CreateFrame('Frame', nil, PlayerFrame)
reps:RegisterEvent('COMBAT_TEXT_UPDATE')
reps:SetScript('OnEvent', function(self, event, a1, a2, a3)
	if (event == 'COMBAT_TEXT_UPDATE' and a1 == 'FACTION') then
		ProcessRepEvent(a2, a3)
	end
end)

--==============================================--
--	Slash
--==============================================--
SLASH_TRUTH_REP1 = '/rep'
SlashCmdList['TRUTH_REP'] = function(msg)
	if (msg == 'on') then
		TruthDB.Reputation.EVENT_ANNOUNCEMENTS = false

		print('Faction Update Reports', 'ON')
	end
	if (msg == 'off') then
		TruthDB.Reputation.EVENT_ANNOUNCEMENTS = true

		print('Faction Update Reports', 'OFF')
	end
end


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