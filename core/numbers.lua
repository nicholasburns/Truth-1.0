local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Numbers"]["Enable"]) then return end
local print = function(...) Addon.print('numbers', ...) end

local assert = assert
local format = string.format
local gsub = string.gsub
local match = string.match
local reverse = string.reverse


--==============================================--
--	FormatList
--==============================================--
local NumberFormats = {
	['CURRENT'] 			= "%s",
	['CURRENT_MAX']		= "%s - %s",
	['CURRENT_PERCENT']		= "%s - %s%%",
	['CURRENT_MAX_PERCENT']	= "%s - %s | %s%%",
	['DEFICIT'] 			= "-%s",
	['PERCENT'] 			= "%s%%",
}

--==============================================--
--	API
--==============================================--
T.Round = function(number, decimals)
  -- Remove decimal from a number

	if (not decimals) then decimals = 0 end

	return (('%%.%df'):format(decimals)):format(number)  -- return format(format('%%.%df', decimals), number) --> AsphyxiaUI/Handler/Math.lua
end

T.HexToRBG = function(cstring)				-- credit: AzOptionsFactory.lua
  -- Converts string colors to RGBA
	local a, r, g, b = cstring:match("^|c(..)(..)(..)(..)")
	return format("%d", "0x"..r)/255, format("%d", "0x"..g)/255, format("%d", "0x"..b)/255, format("%d", "0x"..a)/255
end

T.RGBToHex = function(r, g, b)
  -- Converts a color from an RGB format to Hexidecimal format

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end


T.Comma = function(n)
  -- Add comma to separate thousands
  -- credit:	AsphyxiaUI/Handler/Math.lua
  -- @[use]:	fs:SetText(format('%s: %s', 'TOTAL_RAID_DAMAGE', T.Comma(value)))
	local left, num, right = match(n, "^([^%d]*%d)(%d*)(.-)$")
	return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end
--[[ credit: lua-users.org/wiki/FormattingNumbers
	print(Commas(9))					=>  9
	print(Commas(999))                 	=>  999
	print(Commas(1000))                	=>  1,000
	print(Commas('1333444.10'))        	=>  1,333,444.10
	print(Commas('US$1333400'))        	=>  US$1,333,400
	print(Commas('-$22333444.56'))     	=>  -$22,333,444.56
	print(Commas('($22333444.56)'))    	=>  ($22,333,444.56)
	print(Commas('NEG $22333444.563')) 	=>  NEG $22,333,444.563
--]]

T.ShortValue = function(v)
	if (v >= 1e9) then
		return ("%.1fb"):format(v / 1e9):gsub("%.?0+([kmb])$", "%1")
	elseif (v >= 1e6) then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([kmb])$", "%1")
	elseif (v >= 1e3 or v <= -1e3) then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([kmb])$", "%1")
	else
		return v
	end
end

T.ShortValueNegative = function(v)
	if (v <= 999) then
		return v
	end

	if (v >= 1000000) then
		local value = format("%.1fm", v / 1000000)
		return value
	elseif (v >= 1000) then
		local value = format("%.1fk", v / 1000)
		return value
	end
end


T.FormatNumber = function(nf, min, max)
	assert(NumberFormats[nf], 'Invalid number format (nf): ' .. nf)
	assert(min, 'Current value required.  Usage:  T.FormatNumber(nf, min, max)')
	assert(max, 'Maximum value required.  Usage:  T.FormatNumber(nf, min, max)')

	if (max == 0) then
		max = 1
	end

	local useNF = NumberFormats[nf]

	if (nf == 'DEFICIT') then
		local deficit = max - min
		if (deficit <= 0) then
			return ''
		else
			return format(useNF, T.ShortValue(deficit))
		end

	elseif (nf == 'PERCENT') then
		local s = format(useNF, format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")

		return s

	elseif (nf == 'CURRENT' or ((nf == 'CURRENT_MAX' or nf == 'CURRENT_MAX_PERCENT' or nf == 'CURRENT_PERCENT') and min == max)) then

		return format(NumberFormats['CURRENT'],  T.ShortValue(min))

	elseif (nf == 'CURRENT_MAX') then

		return format(useNF, T.ShortValue(min), T.ShortValue(max))

	elseif (nf == 'CURRENT_PERCENT') then
		local s = format(useNF, T.ShortValue(min), format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")

		return s

	elseif (nf == 'CURRENT_MAX_PERCENT') then
		local s = format(useNF, T.ShortValue(min), T.ShortValue(max), format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")

		return s
	end
end
T.GetFormattedText = FormatNumber
