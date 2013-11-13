local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('print', ...) end

--[[ Format Notes


	"%.2f"		means:  format this var as a number with two decimal places
				usage:  text = string.format(“%.2f, %.2f”, x, y);

--]]



--[[ Patterns

	Search for a date in the format:  dd/mm/yyyy
	using the pattern:  "%d%d/%d%d/%d%d%d%d":

		s = "Deadline is 30/05/1999, firm"
		date = "%d%d/%d%d/%d%d%d%d"
		print(string.sub(s, string.find(s, date))) --> 30/05/1999

	The following table lists all character classes:

	----------------------------------------
			  Character Classes
	----------------------------------------
	  .  all characters
	 %a  letters
	 %c  control characters
	 %d  digits
	 %g  printable characters except spaces
	 %l  lower-case letters
	 %p  punctuation characters
	 %s  space characters
	 %u  upper-case letters
	 %w  alphanumeric characters
	 %x  hexadecimal digits
	----------------------------------------

--]]

--==============================================--
--	Print
--==============================================--
local print

local MY_GRN_COLOR_CODE = '|cff99CC99'
local MY_BLU_COLOR_CODE = '|cffA4C3DD'
local MY_SKY_COLOR_CODE = '|cffE4F3FF'

do
	local gsub = string.gsub
	local upper = string.upper
	local format = string.format

	local AddOn = format("%s%s", MY_GRN_COLOR_CODE, AddOn)

	print = function(file, key, value, ...)
		file  = format("%s%s", BATTLENET_FONT_COLOR_CODE, file:gsub("^%l", upper))
		key   = format("%s%s", MY_BLU_COLOR_CODE, tostring(key))
		value = format("%s%s", MY_SKY_COLOR_CODE, tostring(value))

		DEFAULT_CHAT_FRAME:AddMessage(format("%s %s:  %s  %s", AddOn, file, key, value))
	end
end

Addon.print = print

--==============================================--
--	Split
--==============================================--
local strlower = strlower

local function Split(str)
	if (str:find("%s")) then
		return strsplit(" ", str)
	else
		return str
	end
end

A.SlashHandler = function(cmd)
	local arg1, arg2 = strlower(Split(cmd))

	if (arg1 == "dt" or arg1 == "datatext") then
		local DataText = A["DataTexts"]

		if (arg2) then
			if (arg2 == "reset") then
				DataText:Reset()
			elseif(arg2 == "resetgold") then
				DataText:ResetGold()
			end
		else
			DataText:ToggleDataPositions()
		end
	else
		CreateConfiguration()
	end
end

SLASH_ACPSLASHHANDLER1 = "/acp"
SlashCmdList["ACPSLASHHANDLER"] = A.SlashHandler


--==============================================--
--	Blizzard Constants
--==============================================--
--[[
	NORMAL_FONT_COLOR_CODE		= '|cffFFD200'
	HIGHLIGHT_FONT_COLOR_CODE	= '|cffFFFFFF'
	RED_FONT_COLOR_CODE			= '|cffFF2020'
	GREEN_FONT_COLOR_CODE		= '|cff20FF20'
	GRAY_FONT_COLOR_CODE		= '|cff808080'
	YELLOW_FONT_COLOR_CODE		= '|cffFFFF00'
	LIGHTYELLOW_FONT_COLOR_CODE	= '|cffFFFF9A'
	ORANGE_FONT_COLOR_CODE		= '|cffFF7F3F'
	ACHIEVEMENT_COLOR_CODE		= '|cffFFFF00'
	BATTLENET_FONT_COLOR_CODE	= '|cff82C5FF'
--]]

--==============================================--
--	Trim
--	Removes string whitespace (leading & trailing)
-->	lua-users.org/lists/lua-l/2009-12/msg00877.html
--==============================================--
local trim
do
	local match = string.match

	local function trim(str)
		return str:match('^%s*(.*%S)%s*$' or '')
	end
end

Addon.trim = trim

--==============================================--
--	Print Array
--==============================================--
local arrayer
do
	local concat = table.concat

	local function arrayer(a)
		print('{' .. table.concat(a, ', ') .. '}')
	end
end

Addon.arrayer = arrayer

--==============================================--
-- Format Example Code
--==============================================--
local SetFontString = function(parent, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontFile, fontSize, fontFlag)

	parent.text = fs
	parent.text:SetText(format("%s: %s", "Data Name", Value))
end

--==============================================--
--	Backup
--==============================================--
--[[	D | credit: QTip (addon)

	local D
	do
		local print = print
		local upper = string.upper
		local printHeader = '|cFF33FF99%s|r: '

		D = function(tag, msg, ...)
			local tag = '|cffCC3333 Truth|r:' .. '|cffDB7070' .. upper(tag) .. '|r '
			local msg = '|cffFFFFFF' .. msg .. '|r '
			local dot = ''

			if (...) then dot = '|cffFFFF80' .. ... .. '|r' end

			DEFAULT_CHAT_FRAME:AddMessage(tag .. msg .. dot)
		end
	end

	D(('%s%s%s: %s%s %s%s'):format(L.COLOR_ACE3, L.N_TITLE, L.COLOR_STOP, L.COLOR_GREY, L.N_L_QTIP, L.NOT_QTIP, L.COLOR_STOP))

	Addon.print = D
--]]