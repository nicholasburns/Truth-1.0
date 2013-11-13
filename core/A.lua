-- credit: AsphyxiaUI (Sinaris, Azilroka) | @ AsphyxiaUI\Handler\Handler.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('A', ...) end

local min, max, tonumber, match = math.min, math.max, tonumber, string.match
local floor, min, max, tonumber = math.floor, math.min, math.max, tonumber


--[[

A = {
	Name = "Truth"
--	Version does not exist = not in my TOC
	Title = "[|cffFFFFFF Truth |r]"
	ClientLocale = "enUS"
	Print = <function>

	MyName = "Truthmachine"
	MyLevel = 90
	MyClass = "ROGUE"
	MyRace = "Orc"
	MyFaction = "Horde"
	MyRealm = "Mal'Ganis"
	MyColor = <table>

	ScreenResolution = "2560x1440"
	ScreenWidth = 2560
	ScreenHeight = 1440
	UIScale = 0.64
	px = 0.83333333333333


	Dummy = <function>
	TexCoords = {}
	Colors = {}
	HiddenFrame = {}
	PetBattleHider = {}
}

--]]

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
A["ScreenWidth"] 		= tonumber(match(A["ScreenResolution"], "(%d+)x+%d"))
A["ScreenHeight"] 		= tonumber(match(A["ScreenResolution"], "%d+x(%d+)"))
A["UIScale"] 			= min(2, max(0.64, 768 / match(A["ScreenResolution"], "%d+x(%d+)")))						-- T.uiscale = math.min(2, math.max(.64, 768 / match(GetCVar('gxResolution'), '%d+x(%d+)')))
A["px"]				= 768 / match(GetCVar('gxResolution'), '%d+x(%d+)') / A["UIScale"]


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
A["TexCoords"] = {0.08, 0.92, 0.08, 0.92}

A["Colors"] = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[ A["MyClass"] ]

A["HiddenFrame"] = CreateFrame("Frame", nil, UIParent)
A["HiddenFrame"]:Hide()

A["PetBattleHider"] = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
A["PetBattleHider"]:SetAllPoints()
RegisterStateDriver(A["PetBattleHider"], "visibility", "[petbattle] hide; show")


--==============================================--
--	Pixel Module
--==============================================--
local px = A["px"]

local scale = function(x)
	return px * floor(x / px + 0.5)
end

local P = {
	[1]  =  1 * px, -->0.83333333333333
	[2]  =  2 * px, -->1.6666666666667
	[3]  =  3 * px, -->2.5
	[4]  =  4 * px, -->3.3333333333333
	[5]  =  5 * px, -->4.1666666666667
	[6]  =  6 * px, -->5
	[7]  =  7 * px, -->5.8333333333333
	[8]  =  8 * px, -->6.6666666666667           -- tiny
	[9]  =  9 * px, -->7.5

	[10] = 10 * px, -->8.3333333333333           -- small
	[11] = 11 * px, -->9.1666666666667

	[12] = 12 * px, -->10                        -- medium (normal)
	[13] = 13 * px, -->10.833333333333
	[14] = 14 * px, -->11.666666666667           --[[ header ]]
	[15] = 15 * px, -->
	[16] = 16 * px, -->13.333333333333           -- large
	[17] = 17 * px, -->14.166666666667
	[18] = 18 * px, -->15
	[19] = 19 * px, -->15.833333333333
	[20] = 20 * px, -->16.666666666667           -- huge / huge1

	[22] = 22 * px, -->18.333333333333
	[24] = 24 * px, -->20                        -- superhuge
	[26] = 26 * px, -->21.666666666667
	[28] = 28 * px, -->23.333333333333
	[30] = 30 * px, -->25

	[32] = 32 * px, -->26.666666666667           -- gigantic
	[48] = 48 * px, -->40
}

A["P"] = P
A["Scale"] = scale

--[[  local Ps = {
	[1]  = scale(1),  -->0.83333333333333
	[2]  = scale(2),  -->1.6666666666667
	[4]  = scale(4),  -->3.3333333333333
	[5]  = scale(5),  -->4.1666666666667
	[8]  = scale(8),  -->6.6666666666667           -- tiny
	[10] = scale(10), -->8.3333333333333           -- small
	[11] = scale(11), -->9.1666666666667
	[16] = scale(16), -->13.333333333333           -- large
	[17] = scale(17), -->14.166666666667
	[20] = scale(20), -->16.666666666667           -- huge / huge1
	[22] = scale(22), -->18.333333333333
}

_G.X = Ps

_G.X {
    [1] = 0.83333333333333;
    [2] = 1.6666666666667;
    [4] = 4.1666666666667;
    [8] = 8.3333333333333;
    [16] = 15.833333333333;
    [17] = 16.666666666667;
    [5] = 5;
    [10] = 10;
    [20] = 20;
    [11] = 10.833333333333;
    [22] = 21.666666666667;
};
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
