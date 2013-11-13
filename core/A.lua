-- credit: AsphyxiaUI (Sinaris, Azilroka) | @ AsphyxiaUI\Handler\Handler.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('A', ...) end
local min, max, tonumber, match  = math.min, math.max, tonumber, string.match


--==============================================--
--	Addon
--==============================================--
A["Name"] 			= ...
A["Version"] 			= GetAddOnMetadata(..., "Version")
A["Title"] 			= GetAddOnMetadata(..., "Title")
A["ClientLocale"] 		= GetLocale()
A["Print"] 			= function(...) print("|cffFF6347" .. A["Name"] .. "|r:", ...) end


--==============================================--
--	Graphic
--==============================================--
A["ScreenResolution"]	= GetCVar("gxResolution")
A["ScreenHeight"] 		= tonumber(match(A["ScreenResolution"], "%d+x(%d+)"))
A["ScreenWidth"] 		= tonumber(match(A["ScreenResolution"], "(%d+)x+%d"))
A["UIScale"] 			= min(2, max(0.64, 768 / match(A["ScreenResolution"], "%d+x(%d+)")))						-- T.uiscale = math.min(2, math.max(.64, 768 / match(GetCVar('gxResolution'), '%d+x(%d+)')))
A["px"]				= 768 / strmatch(GetCVar('gxResolution'), '%d+x(%d+)') / A["UIScale"]


--==============================================--
--	Player
--==============================================--
A["MyName"] 			= UnitName("player")
A["MyLevel"] 			= UnitLevel("player")
A["MyClass"] 			= select(2, UnitClass("player"))
A["MyRace"] 			= select(2, UnitRace("player"))
A["MyFaction"]			= UnitFactionGroup("player")
A["MyRealm"] 			= GetRealmName()
A["MyColor"]			= (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[ A["MyClass"] ]


--==============================================--
--	Functions
--==============================================--
A["Dummy"] = function() return end

A["Colors"] = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[ A["MyClass"] ]

A["TexCoords"] = {0.08, 0.92, 0.08, 0.92}

A["HiddenFrame"] = CreateFrame("Frame", nil, UIParent)
A["HiddenFrame"]:Hide()

A["PetBattleHider"] = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
A["PetBattleHider"]:SetAllPoints()
RegisterStateDriver(A["PetBattleHider"], "visibility", "[petbattle] hide; show")


local match, tonumber = string.match, tonumber
local floor, min, max = math.floor, math.min, math.max


--==============================================--
--	Pixelsize
--==============================================--
local uiscale = min(2, max(0.64, 768 / match(GetCVar('gxResolution'), '%d+x(%d+)')))
local px = 768 / strmatch(GetCVar('gxResolution'), '%d+x(%d+)') / uiscale


local scale = function(x)
	return px * floor(x / px + 0.5)
end

local adjusted_uiscale
if (uiscale < 0.64) then						-- number cleanup
	adjusted_uiscale = uiscale
end


--==============================================--
--	Pixelsizes
--==============================================--
local P = {
	[1]  =  1 * px,
	[2]  =  2 * px,
	[3]  =  3 * px,
	[4]  =  4 * px,
	[5]  =  5 * px,
	[6]  =  6 * px,
	[7]  =  7 * px,
	[8]  =  8 * px,				-- tiny
	[9]  =  9 * px,

	[10] = 10 * px,				-- small
	[11] = 11 * px,

	[12] = 12 * px,				-- medium (normal)
	[13] = 13 * px,
	[14] = 14 * px,				--[[ header ]]
	[15] = 15 * px,
	[16] = 16 * px,				-- large
	[17] = 17 * px,
	[18] = 18 * px,
	[19] = 19 * px,
	[20] = 20 * px,				-- huge / huge1

	[22] = 22 * px,
	[24] = 24 * px,				-- superhuge
	[26] = 26 * px,
	[28] = 28 * px,
	[30] = 30 * px,

	[32] = 32 * px,				-- gigantic
  -- [34] = 34 * px,
  -- [36] = 36 * px,
  -- [38] = 38 * px,
  -- [40] = 40 * px,

  -- [42] = 42 * px,
  -- [44] = 44 * px,
  -- [46] = 46 * px,
  -- [48] = 48 * px,
  -- [50] = 50 * px,
}


--==============================================--
--	Unused
--==============================================--
--[[	if(A["MyName"] == "Truthmachine" or A["MyName"] == "Truthwynn") then A["IsAuthor"] = true end

	local Layouts = {}
	A["Layouts"] = Layouts
--]]

--==============================================--
--	Previous Version
--==============================================--
--[[	local A, C, T, L = unpack(select(2, ...))

	T.myrace			= select(2, UnitRace('player'))						-- local raceName, raceID = UnitRace('player')		--> raceID = Dwarf Draenei Gnome Human NightElf Worgen / BloodElf Goblin Orc Tauren Troll Scourge / Panderan
	T.myclass			= select(2, UnitClass('player'))
	local color		= RAID_CLASS_COLORS[T.myclass]						-- local classcolor	= RAID_CLASS_COLORS[T.myclass]
	T.mycolor 		= {color[1], color[2], color[3]}

	T.myname			= UnitName('player')
	T.myrealm			= GetRealmName()
	T.myfaction		= UnitFactionGroup('player')
	T.mylevel			= UnitLevel('player')

	T.uiscale			= math.min(2, math.max(.64, 768 / string.match(GetCVar('gxResolution'), '%d+x(%d+)')))
	T.dummy 			= function() return end
--]]
