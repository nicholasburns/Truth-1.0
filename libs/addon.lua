local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Addon"]["Enable"]) then return end
local print = function(...) Addon.print('addon', ...) end




local a = CreateFrame("Frame", "TruAddon")
a:RegisterEvent("ADDON_LOADED")
a:SetScript("OnEvent", function(self, event, addon)
	if (addon == "Blizzard_CombatLog") then


		--> SetupChat(self)

		self:UnregisterEvent(event)
	end
end)




























































--[[
-- credit: AsphyxiaUI (Sinaris, Azilroka)
-- AsphyxiaUI\Handler\Handler.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))

local select = select
local tonumber = tonumber
local match = string.match

--==============================================--
--	AsphyxiaUI
--==============================================--
A["Name"] = ...
A["Version"] = GetAddOnMetadata( ..., "Version" )
A["Title"] = GetAddOnMetadata( ..., "Title" )
A["ClientLocale"] = GetLocale()
A["Print"] = function( ... ) print( "|cffFF6347" .. A["Name"] .. "|r:", ... ) end

--==============================================--
--	Graphic
--==============================================--
A["ScreenReso"] = GetCVar( "gxResolution" )
A["ScreenHeight"] = tonumber( match( A["ScreenReso"], "%d+x(%d+)" ) )
A["ScreenWidth"] = tonumber( match( A["ScreenReso"], "(%d+)x+%d" ) )

--==============================================--
--	Player
--==============================================--
A["MyName"] 	= UnitName( "player" )
A["MyLevel"] 	= UnitLevel( "player" )
A["MyClass"] 	= select( 2, UnitClass( "player" ) )
A["MyRace"] 	= select( 2, UnitRace( "player" ) )
A["MyFaction"]	= UnitFactionGroup( "player" )
A["MyRealm"] 	= GetRealmName()

--==============================================--
--	Most Used
--==============================================--
A["Dummy"] = function() return end
A["TexCoords"] = { 0.08, 0.92, 0.08, 0.92 }
A["Colors"] = ( CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS )[ A["MyClass"] ]
A["HiddenFrame"] = CreateFrame( "Frame", nil, UIParent )
A["HiddenFrame"]:Hide()
A["PetBattleHider"] = CreateFrame( "Frame", nil, UIParent, "SecureHandlerStateTemplate" )
A["PetBattleHider"]:SetAllPoints()
RegisterStateDriver( A["PetBattleHider"], "visibility", "[petbattle] hide; show" )

--==============================================--
--	Only for personal use
--==============================================--
if( A["MyName"] == "Sinaris" or A["MyName"] == "Antariel" or A["MyName"] == "Sinaris" ) then
	A["IsAuthor"] = true
end

local Layouts = {}
A["Layouts"] = Layouts

--==============================================--
--	Constants
--==============================================--
local A, C, T, L = unpack(select(2, ...))

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
