local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
Addon.file = 'debug'
Addon.debug = function(...)
	Addon.print(Addon.file, ...)
end



-- Constant
local SPACE_CHAR		= "_"
local SPACE_COLOR		= "|cff8888ee"
local NUMBER_COLOR		= "|cffeeeeee"
local BOOLEAN_COLOR		= "|cffeeeeee"
local FRAME_COLOR		= "|cff88ffff"
local TABLE_COLOR		= "|cff88ff88"
local OTHERTYPE_COLOR	= "|cff88ff88"
local FUNCTION_COLOR	= "|cffff66aa"
local NIL_COLOR		= "|cffff0000"



--==============================================--
--	Escape Strings
--==============================================--
local len = string.len
local rep = string.rep
local gsub = string.gsub

local function Space(str)
	local n = len(str)						--~	str = string of space characters
	return SPACE_COLOR .. rep(SPACE_CHAR, n) .. "|r"
end

local function Escape(str)
	local dnext = gsub(str,	"\"", "\\\"")
	dnext = gsub(dnext, "|", "||")
	dnext = gsub(dnext, "\n", "\\n")
	dnext = gsub(dnext, "	+", Space)
	dnext = gsub(dnext, "^ ", Space)
	return "\"" .. gsub(dnext, " $", Space) .. "\""
end

--==============================================--
--	String Data
--==============================================--
local type = type
local sub = string.sub
local tostring = tostring
local rawget = rawget

Addon.FormatString = function(data, functionLookup)
	local dt = type(data)

	if (dt == "string") then
		local dl = len(data)

		if (dl > 80) then
			return Escape(sub(data, 1, 80)) .. "...", true
		else
			return Escape(data)
		end

	elseif (dt == "number") then
		return NUMBER_COLOR .. tostring(data) .. "|r"

	elseif (dt == "boolean") then
		return BOOLEAN_COLOR .. tostring(data) .. "|r"

	elseif (dt == "function") then
		local s = (functionLookup and functionLookup[data]) or tostring(data)

		return FUNCTION_COLOR .. s .. "|r"

	elseif (dt == "table") then
		local ud = rawget(data, 0)

		if (type(ud) == "userdata") then
			local got = data.GetObjectType
			local obj = got and got(data)

			if (obj) then
				local gn = data.GetName

				if (gn) then gn = gn(data) end

				if (type(gn) == "string") then

					if (_G[gn] ~= data) then
						gn = tostring(data) .. "(" .. Escape(gn) .. ")"
					else
						gn = Escape(gn)
					end
				else
					gn = tostring(data)
				end

				return FRAME_COLOR .. obj .. "|r:" .. gn, true
			end
		end

		return TABLE_COLOR .. "<" .. dt .. ":" .. tostring(data) .. ">|r", true

	elseif (dt ~= "nil") then
		return OTHERTYPE_COLOR .. "<" .. dt .. ":" .. tostring(data) .. ">|r"
	else
		return NIL_COLOR .. "nil|r"
	end
end


















--==============================================--
--	Print Msgs
--==============================================--
--[[
 Convert decimal classcolor into hex

 Here's a small function that will convert player classcolor from decimal
 into hex and prints it in the chat with format "playername, level XX class"
  ]]
local format = string.format

local function DecimalToHex(r,g,b)
    return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

--+
local playerclass, PLAYERCLASS = UnitClass("player")

local playername	= UnitName("player")
local playerlevel	= UnitLevel("player")
local classcolor	= RAID_CLASS_COLORS[PLAYERCLASS]

local r, g, b 		= classcolor.r, classcolor.g, classcolor.b
local classcolorhex	= DecimalToHex(r, g, b)

--+
-- print(classcolorhex .. playername .. ", level " .. playerlevel .. " " .. playerclass .. "|r")






--==============================================--
--	Credit
--==============================================--
--[[ _Dev
	Author: Iriel
	File: DevToolsFormat.lua
	Functions:
		Space(spcs)
		Escape(str)
		UTIL.StringSummary(data, functionLookup)
--]]
--==============================================--
