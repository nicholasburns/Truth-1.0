local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Peputation"]) then return end
local print = function(...) Addon.print('events', ...) end

local select, unpack, ceil = select, unpack, math.ceil






-- Addon
local TruEvent = CreateFrame("Frame", "TruEvent")


-- Register Events
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


-- Handle special OnLoad code when our addon has loaded, if (present
-- Also initializes the savedvar for us, if (Addon.dbname or Addon.dbpcname is set
-- If Addon.ADDON_LOADED is defined, the ADDON_LOADED event is not unregistered
local function ProcessOnLoad(arg1)
	if (arg1 ~= AddOn) then return end

	if (Addon.dbname) then
		local defaults = Addon.dbdefaults or {}

		_G[Addon.dbname] = setmetatable(_G[Addon.dbname] or {}, {__index = defaults})

		Addon.db = _G[Addon.dbname]
	end

	if (Addon.dbpcname) then
		local defaults = Addon.dbpcdefaults or {}

		_G[Addon.dbpcname] = setmetatable(_G[Addon.dbpcname] or {}, {__index = defaults})

		Addon.dbpc = _G[Addon.dbpcname]
	end

	if (Addon.OnLoad) then
		Addon.OnLoad()
		Addon.OnLoad = nil
	end

	ProcessOnLoad = nil

	if (not Addon.ADDON_LOADED) then
		TruEvent:UnregisterEvent("ADDON_LOADED")
	end

	if (Addon.dbdefaults or Addon.dbpcdefaults) then
		Addon.RegisterEvent("PLAYER_LOGOUT")
	end

	if (IsLoggedIn()) then
		ProcessOnLogin()
	else
		TruEvent:RegisterEvent("PLAYER_LOGIN")
	end
end


-- Removes the default values from the db and dbpc as we're logging out
local function ProcessLogout()
if (Addon.dbdefaults) then
	for i,v in pairs(Addon.dbdefaults) do
		if (Addon.db[i] == v) then Addon.db[i] = nil end
	end
end

if (Addon.dbpcdefaults) then
	for i,v in pairs(Addon.dbpcdefaults) do
		if (Addon.dbpc[i] == v) then Addon.dbpc[i] = nil end
	end
end
end


TruEvent:RegisterEvent("ADDON_LOADED")
TruEvent:SetScript("OnEvent", function(self, event, arg1, ...)

	if (ProcessOnLoad and event == "ADDON_LOADED") then
		ProcessOnLoad(arg1)
	end

	if (ProcessOnLogin and event == "PLAYER_LOGIN") then
		ProcessOnLogin()
	end

	if (event == "PLAYER_LOGOUT") then
		ProcessLogout()
	end

	if (Addon[event]) then
		Addon[event](event, arg1, ...)
	end

end)