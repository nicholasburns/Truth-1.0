local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Addon"]["SV"]["Enable"]) then return end
local print = function(...) Addon.print('sv', ...) end
--[[ function Addon.InitDB()
	   local char = UnitName("player")
	   local server = GetRealmName() .. " " .. UnitFactionGroup("player")

	   TruDB = TruDB or {}
	   TruDB[server] = TruDB[server] or {}
	   TruDB[server][char] = TruDB[server][char] or {}

	   Addon.realmdb = TruDB[server]
	   Addon.chardb = Addon.realmdb[char]
	end
--]]
local pairs, setmetatable, select, unpack, ceil = pairs, setmetatable, select, unpack, math.ceil
local IsLoggedIn = IsLoggedIn

Addon.dbName = "TruDB"
Addon.dbPCName = "TruDBPC"
Addon.DBName = "TruthDB"
Addon.DBPCName = "TruthDBPC"


Addon.DefaultDB = {
	["Eventstamp"] = {
		["ADDON_LOADED"] = true,
		["PLAYER_ENTERING_WORLD"] = true,
		["PLAYER_LOGOUT"] = true,
	},
	["Counter"] = {
		["Login"] = 0,
		["ZoneIn"] = 0,
		["Logout"] = 0,
		["Slash"] = 0,
	},
}




local TruEvent = CreateFrame("Frame", "TruEvent")

--==============================================--
-- Register Events
--==============================================--
function Addon.RegisterEvent(event, func)
	if (func) then
		Addon[event] = func
	end
	TruEvent:RegisterEvent(event)
end

function Addon.UnregisterEvent(event)
	TruEvent:UnregisterEvent(event)
end

function Addon.UnregisterAllEvents()
	TruEvent:UnregisterAllEvents()
end

-- Handles special OnLogin code for when the PLAYER_LOGIN event is fired.
-- If our addon is loaded after that event is fired,) then we call it immediately
-- after the OnLoad handler is processed.
local function ProcessOnLogin()
	if (Addon.OnLogin) then
		Addon.OnLogin()
		Addon.OnLogin = nil
	end

	ProcessOnLogin = nil

	if (not Addon.PLAYER_LOGIN) then
		TruEvent:UnregisterEvent("PLAYER_LOGIN")
	end
end

-- Handle special OnLoad code when our addon has loaded, if present
-- Also initializes the savedvar for us, if Addon.DBName or Addon.DBPCName is set
-- If Addon.ADDON_LOADED is defined, the ADDON_LOADED event is not unregistered
local function ProcessOnLoad(addon)
	if (addon ~= AddOn) then return end

	if (Addon.DBName) then
		local Defaults = Addon.DefaultDB or {}

		_G[Addon.DBName] = setmetatable(_G[Addon.DBName] or {}, {__index = Defaults})

		Addon.db = _G[Addon.DBName]
	end

	if (Addon.DBPCName) then
		local Defaults = Addon.DefaultDBPC or {}

		_G[Addon.DBPCName] = setmetatable(_G[Addon.DBPCName] or {}, {__index = Defaults})

		Addon.dbpc = _G[Addon.DBPCName]
	end

	if (Addon.OnLoad) then
		Addon.OnLoad()
		Addon.OnLoad = nil
	end

	ProcessOnLoad = nil

	if (not Addon.ADDON_LOADED) then
		TruEvent:UnregisterEvent("ADDON_LOADED")
	end

	if (Addon.DefaultDB or Addon.DefaultDBPC) then
		Addon.RegisterEvent("PLAYER_LOGOUT")
	end

	if (IsLoggedIn()) then
		ProcessOnLogin()
	else
		TruEvent:RegisterEvent("PLAYER_LOGIN")
	end
end

-- Wipes defaults @ logout
local function ProcessLogout()
	if (Addon.DefaultDB) then
		for i, v in pairs(Addon.DefaultDB) do
			if (Addon.db[i] == v) then
				Addon.db[i] = nil
			end
		end
	end
	if (Addon.DefaultDBPC) then
		for i, v in pairs(Addon.DefaultDBPC) do
			if (Addon.dbpc[i] == v) then
				Addon.dbpc[i] = nil
			end
		end
	end
end


TruEvent:RegisterEvent("ADDON_LOADED")
TruEvent:SetScript("OnEvent", function(self, event, addon, ...)
	if (ProcessOnLoad and event == "ADDON_LOADED") then
		ProcessOnLoad(addon)
	end

	if (ProcessOnLogin and event == "PLAYER_LOGIN") then
		ProcessOnLogin()
	end

	if (event == "PLAYER_LOGOUT") then
		ProcessLogout()
	end

	if (Addon[event]) then
		Addon[event](event, addon, ...)
	end

end)




