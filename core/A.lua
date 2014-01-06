-- credit: AsphyxiaUI (Sinaris, Azilroka) | @ AsphyxiaUI\Handler\Handler.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('A', ...) end

local min, max, tonumber, match = math.min, math.max, tonumber, string.match
local floor, min, max, tonumber = math.floor, math.min, math.max, tonumber


-- Addon.Lib = {}		-- Init Namespace

--==============================================--
--	Addon
--==============================================--
A["Name"] 		= ...
A["Version"] 		= GetAddOnMetadata(..., "Version")
A["Title"] 		= GetAddOnMetadata(..., "Title")
A["ClientLocale"] 	= GetLocale()

-- Name			= "Truth"
-- Version		=  2
-- Title			= "[|cffFFFFFF Truth |r]"
-- ClientLocale	= "enUS"

--==============================================--
--	Graphic
--==============================================--
A["ScreenResolution"] = GetCVar("gxResolution")
A["ScreenWidth"] 	= tonumber(match(A["ScreenResolution"], "(%d+)x+%d"))
A["ScreenHeight"] 	= tonumber(match(A["ScreenResolution"], "%d+x(%d+)"))
A["UIScale"] 		= min(2, max(0.64, 768 / match(A["ScreenResolution"], "%d+x(%d+)")))

-- ScreenResolution	= "2560x1440"
-- ScreenWidth 	=  2560
-- ScreenHeight 	=  1440
-- UIScale 		=  0.64

--==============================================--
--	Player
--==============================================--
A["MyName"] 		= UnitName("player")
A["MyLevel"] 		= UnitLevel("player")
A["MyClass"] 		= select(2, UnitClass("player"))
A["MyRace"] 		= select(2, UnitRace("player"))
A["MyFaction"]		= UnitFactionGroup("player")
A["MyRealm"] 		= GetRealmName()
A["MyServer"]		= format("%s %s", A["MyRealm"], A["MyFaction"])				-- "Mal'Ganis Horde"
A["MyColor"]		= (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[ A["MyClass"] ]
A["MyColors"] = {
	A["MyColor"].r,
	A["MyColor"].g,
	A["MyColor"].b,
	A["MyColor"].r * .15,
	A["MyColor"].g * .15,
	A["MyColor"].b * .15,
}

-- MyName 		= "Truthmachine"
-- MyLevel 		=  90
-- MyClass 		= "ROGUE"
-- MyRace 		= "Orc"
-- MyFaction 		= "Horde"
-- MyRealm 		= "Mal'Ganis"
-- MyServer		= "Mal'Ganis Horde"
-- MyColor 		= <table>

T.PlayerIsRogue = function()
	return select(2, UnitClass("player")) == "ROGUE"
end
T.PlayerIsDruid = function()
	return select(2, UnitClass("player")) == "DRUID"
end

--==============================================--
--	Functions
--==============================================--
A["Dummy"] = function() return end


A["HiddenFrame"] = CreateFrame("Frame", nil, UIParent)
A["HiddenFrame"]:Hide()

A["PetBattleHider"] = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
A["PetBattleHider"]:SetAllPoints()
RegisterStateDriver(A["PetBattleHider"], "visibility", "[petbattle] hide; show")



--==============================================--
--	TexCoords
--==============================================--
--[[ SetTexCoord

		Sets corner coordinates for scaling or cropping the texture image. See example for details.

	Signature:
		Texture:SetTexCoord(left, right, top, bottom)
					or
		Texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)


	left 	- Left (or minX) edge of the scaled/cropped image, as a fraction of the image's width from the left (number)
	right 	- Right (or maxX) edge of the scaled/cropped image, as a fraction of the image's width from the left (number)
	top		- Top (or minY) edge of the scaled/cropped image, as a fraction of the image's height from the top (number)
	bottom 	- Bottom (or maxY) edge of the scaled/cropped image, as a fraction of the image's height from the top (number)

	ULx 		- Upper left corner X position,  as a fraction of the image's width from the left (number)
	ULy 		- Upper left corner Y position,  as a fraction of the image's height from the top (number)
	LLx 		- Lower left corner X position,  as a fraction of the image's width from the left (number)
	LLy 		- Lower left corner Y position,  as a fraction of the image's height from the top (number)
	URx 		- Upper right corner X position, as a fraction of the image's width from the left (number)
	URy 		- Upper right corner Y position, as a fraction of the image's height from the top (number)
	LRx 		- Lower right corner X position, as a fraction of the image's width from the left (number)
	LRy 		- Lower right corner Y position, as a fraction of the image's height from the top (number)
--]]


A["TexCoords"] = {0.1, 0.9, 0.1, 0.9}			-- Asphyxia Values: {0.08, 0.92, 0.08, 0.92}

--==============================================--
--	Pixel Module
--==============================================--
local X = 768 / match(GetCVar('gxResolution'), '%d+x(%d+)') / A["UIScale"]  --> 0.83333333333333

local P = {
	[1]  =  1 * X, -->0.83333333333333
	[2]  =  2 * X, -->1.6666666666667
	[3]  =  3 * X, -->2.5
	[4]  =  4 * X, -->3.3333333333333
	[5]  =  5 * X, -->4.1666666666667
	[6]  =  6 * X, -->5
	[7]  =  7 * X, -->5.8333333333333
	[8]  =  8 * X, -->6.6666666666667           -- tiny
	[9]  =  9 * X, -->7.5

	[10] = 10 * X, -->8.3333333333333           -- small
	[11] = 11 * X, -->9.1666666666667

	[12] = 12 * X, -->10                        -- medium (normal)
	[13] = 13 * X, -->10.833333333333
	[14] = 14 * X, -->11.666666666667           --[[ header ]]
	[15] = 15 * X, -->
	[16] = 16 * X, -->13.333333333333           -- large
	[17] = 17 * X, -->14.166666666667
	[18] = 18 * X, -->15
	[19] = 19 * X, -->15.833333333333
	[20] = 20 * X, -->16.666666666667           -- huge / huge1

	[22] = 22 * X, -->18.333333333333
	[24] = 24 * X, -->20                        -- superhuge
	[26] = 26 * X, -->21.666666666667
	[28] = 28 * X, -->23.333333333333
	[30] = 30 * X, -->25

	[32] = 32 * X, -->26.666666666667           -- gigantic
	[48] = 48 * X, -->40
}

A["PixelSize"] = 768 / match(GetCVar('gxResolution'), '%d+x(%d+)') / A["UIScale"]
A["PixelSizer"] = P
-- A["Scale"] = scale


--==============================================--
--	Blizzard Addons
--==============================================--
local function OnEvent(self, event, ...)
	if (event == "ADDON_LOADED") then
		local addonName = ...
		if (addonName and addonName ~= "Blizzard_AchievementUI") then return end
	end
end


--==============================================--
--	Previous Version
--==============================================--
--[[	A["Print"] = function(...) print("|cffFF6347" .. A["Name"] .. "|r:", ...) end
--]]

--[[	local A, C, T, L = unpack(select(2, ...))

--~ local raceName, raceID = UnitRace('player')
--~ raceID = Dwarf Draenei Gnome Human NightElf Worgen / BloodElf Goblin Orc Tauren Troll Scourge / Panderan

	T.myrace			= select(2, UnitRace('player'))
	T.myclass			= select(2, UnitClass('player'))
	local color		= RAID_CLASS_COLORS[T.myclass]
	T.mycolor 		= {color[1], color[2], color[3]}

	T.myname			= UnitName('player')
	T.myrealm			= GetRealmName()
	T.myfaction		= UnitFactionGroup('player')
	T.mylevel			= UnitLevel('player')

	T.uiscale			= math.min(2, math.max(.64, 768 / string.match(GetCVar('gxResolution'), '%d+x(%d+)')))
	T.dummy 			= function() return end
--]]

