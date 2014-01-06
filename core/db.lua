local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('db', ...) end



local ONE_MINUTE	= 60
local ONE_HOUR		= 60 * ONE_MINUTE
local ONE_DAY		= 24 * ONE_HOUR
local ONE_MONTH	= 30 * ONE_DAY
local ONE_YEAR		= 12 * ONE_MONTH

local function GetLastTime(timeDifference, isAbsolute)
	if (not isAbsolute) then
		timeDifference = time() - timeDifference
	end

	local year, month, day, hour, minute

	if (timeDifference < ONE_MINUTE) then
		return LASTONLINE_SECS

	elseif (timeDifference >= ONE_MINUTE and timeDifference < ONE_HOUR) then
		return format(LASTONLINE_MINUTES, floor(timeDifference / ONE_MINUTE))

	elseif (timeDifference >= ONE_HOUR and timeDifference < ONE_DAY) then
		return format(LASTONLINE_HOURS, floor(timeDifference / ONE_HOUR))

	elseif (timeDifference >= ONE_DAY and timeDifference < ONE_MONTH) then
		return format(LASTONLINE_DAYS, floor(timeDifference / ONE_DAY))

	elseif (timeDifference >= ONE_MONTH and timeDifference < ONE_YEAR) then
		return format(LASTONLINE_MONTHS, floor(timeDifference / ONE_MONTH))

	else
		return format(LASTONLINE_YEARS, floor(timeDifference / ONE_YEAR))
	end
end


local function InitDB()
	TruthDB = {
		["Eventstamp"] = {
			["ADDON_LOADED"] = true,
			["PLAYER_ENTERING_WORLD"] = true,
		},
		["Datestamp"] = {
			["Login"] = true,
			["ZoneIn"] = true,
			["Logout"] = true,
			["Slash"] = true,
		},
		["Timestamp"] = {
			["Login"] = 0,
			["ZoneIn"] = 0,
			["Logout"] = 0,
			["Slash"] = 0,
		},
		["Counter"] = {
			["Login"] = 0,
			["ZoneIn"] = 0,
			["Logout"] = 0,
			["Slash"] = 0,
		},
	}
end

--==============================================--
--	Database Engine
--==============================================--
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('PLAYER_LOGOUT')
f:SetScript('OnEvent', function(self, event, addon)
	if (event == 'ADDON_LOADED' and addon == 'AddOn') then --print('Event: ', 'ADDON_LOADED') -- self:UnregisterEvent(event)
	  -- TruthDB = TruthDB or {}
		-- TruthDB = nil
		TruthDB["Eventstamp"]["ADDON_LOADED"] = date()
		TruthDB["Datestamp"]["Login"] = date()
		TruthDB["Timestamp"]["Login"] = time()
		TruthDB["Counter"]["Login"] = TruthDB["Counter"]["Login"] + 1
	end

	if (event == 'PLAYER_ENTERING_WORLD') then --print('Event: ', 'PLAYER_ENTERING_WORLD')
		-- TruthDB = nil
		-- InitDB()
		TruthDB["Eventstamp"]["PLAYER_ENTERING_WORLD"] = date()
		TruthDB["Datestamp"]["ZoneIn"] = date()
		TruthDB["Timestamp"]["ZoneIn"] = time()
		TruthDB["Counter"]["ZoneIn"] = TruthDB["Counter"]["ZoneIn"] + 1

		-- print('Logout - ZoneIn: ', TruthDB["Timestamp"]["Logout"] - TruthDB["Timestamp"]["ZoneIn"])
		-- print('GetLastTime: ', GetLastTime(TruthDB["Timestamp"]["ZoneIn"]))
	end

	if (event == 'PLAYER_LOGOUT') then
		TruthDB["Datestamp"]["Logout"] = date()
		TruthDB["Timestamp"]["Logout"] = time()
		TruthDB["Counter"]["Logout"] = TruthDB["Counter"]["Logout"] + 1

	end
end)


--==============================================--
--	Slash
--==============================================--
_G['SLASH_TRUTH_DATE1'] = '/truthdate'
_G['SLASH_TRUTH_TIME1'] = '/truthtime'


SlashCmdList['TRUTH_DATE'] = function()	-- Date
	-- TruthDB = nil
	TruthDB["Datestamp"]["Slash"] = date()
  -- TruthDB["Timestamp"]["Slash"] = time()
	TruthDB["Counter"]["Slash"] = TruthDB["Counter"]["Slash"] + 1

	print('Slash: ', 'TRUTH_DATE')
end

SlashCmdList['TRUTH_TIME'] = function()		-- Time
	-- TruthDB = nil
  -- TruthDB["Datestamp"]["Slash"] = date()
	TruthDB["Timestamp"]["Slash"] = time()
	TruthDB["Counter"]["Slash"] = TruthDB["Counter"]["Slash"] + 1

	print('Slash: ', 'TRUTH_TIME')
end



--==============================================--
--	Reference
--==============================================--
-- FriendsFrame.lua

local ONE_MINUTE	= 60
local ONE_HOUR		= 60 * ONE_MINUTE
local ONE_DAY		= 24 * ONE_HOUR
local ONE_MONTH	= 30 * ONE_DAY
local ONE_YEAR		= 12 * ONE_MONTH

local function FriendsFrame_GetLastOnline(timeDifference, isAbsolute)
	if (not isAbsolute) then
		timeDifference = time() - timeDifference
	end

	local year, month, day, hour, minute

	if (timeDifference < ONE_MINUTE) then
		return LASTONLINE_SECS

	elseif (timeDifference >= ONE_MINUTE and timeDifference < ONE_HOUR) then
		return format(LASTONLINE_MINUTES, floor(timeDifference / ONE_MINUTE))

	elseif (timeDifference >= ONE_HOUR and timeDifference < ONE_DAY) then
		return format(LASTONLINE_HOURS, floor(timeDifference / ONE_HOUR))

	elseif (timeDifference >= ONE_DAY and timeDifference < ONE_MONTH) then
		return format(LASTONLINE_DAYS, floor(timeDifference / ONE_DAY))

	elseif (timeDifference >= ONE_MONTH and timeDifference < ONE_YEAR) then
		return format(LASTONLINE_MONTHS, floor(timeDifference / ONE_MONTH))

	else
		return format(LASTONLINE_YEARS, floor(timeDifference / ONE_YEAR))
	end
end

--==============================================--
--	Backup
--==============================================--
--[[
TruthDB = {
	["Eventstamp"] = {
		["ADDON_LOADED"] = true,
		["PLAYER_ENTERING_WORLD"] = true,
	},
	["Datestamp"] = {
		["Login"] = true,
		["ZoneIn"] = true,
		["Logout"] = true,
		["Slash"] = true,
	},
	["Timestamp"] = {
		["Login"] = true,
		["ZoneIn"] = true,
		["Logout"] = true,
		["Slash"] = true,
	},
	["Counter"] = {
		["Login"] = 0,
		["ZoneIn"] = 0,
		["Logout"] = 0,
		["Slash"] = 0,
	},
}
--]]
