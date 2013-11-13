local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('text', ...) end
if (not C["Addon"]["Text"]["Enable"]) then return end

local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']




--==============================================--
--	Time
--==============================================--
T.FormatTime = function(s)
  -- credit: Shestak
  -- usage:  local time = FormatTime(self.timeLeft)

	local day = 86400
	local hour = 3600
	local minute = 60

	if     (s >= day)		then return format('%dd', floor(s / day + 0.5)), s % day
	elseif (s >= hour)		then return format('%dh', floor(s / hour + 0.5)), s % hour
	elseif (s >= minute)	then return format('%dm', floor(s / minute + 0.5)), s % minute
	elseif (s >= minute/12)	then return  floor(s + 0.5), (s * 100 - floor(s * 100)) / 100
	end

	return format('%.1f', s), (s * 100 - floor(s * 100)) / 100
end

T.FormatTime_Tukui = function(s)
  -- Display seconds as mins / hours / days (credit: Tukui)

	local day = 86400
	local hour = 3600
	local minute = 60

	if     (s >= day)    	then return format('%dd', ceil(s / day))
	elseif (s >= hour)   	then return format('%dh', ceil(s / hour))
	elseif (s >= minute) 	then return format('%dm', ceil(s / minute))
	elseif (s >= minute/12)	then return floor(s)
	end

	return format('%.1f', s)
end

T.FormatTime_Asphyxia = function(s)
  -- credit:	AsphyxiaUI/Handler/Math.lua
  -- @[use]:	local Time = T.FormatTime(Seconds)

	local Day, Hour, Minute = 86400, 3600, 60

	if (s >= Day) then
		return format("%dd", ceil(s / Day))
	elseif (s >= Hour) then
		return format("%dh", ceil(s / Hour))
	elseif (s >= Minute) then
		return format("%dm", ceil(s / Minute))
	elseif (s >= Minute / 12) then
		return floor(s)
	end

	return format("%.1f", s)
end

T.FormatTime3 = function(s)
  -- credit:	Shestak\Modules\ActionBars\Cooldowns.lua

	local day, hour, minute = 86400, 3600, 60

	if (s >= day) then
		return format("%dd", floor(s / day + 0.5)), s % day
	elseif (s >= hour) then
		return format("%dh", floor(s / hour + 0.5)), s % hour
	elseif (s >= minute) then
		return format("%dm", floor(s / minute + 0.5)), s % minute
	end

	return floor(s + 0.5), s - floor(s)
end

--==============================================--
--	Shorten String
--==============================================--
T.ShortenString = function(string, numChars, dots)
	assert(string, 'A String (to shorten) is required. Usage: T:ShortenString(string, numChars, includeDots)')
	assert(numChars, 'A length (to shorten the string to) is required. Usage: E:ShortenString(string, numChars, includeDots)')

	local bytes = string:len()

	if (bytes <= numChars) then
		return string
	else
		local len = 0
		local pos = 1

		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)

			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end

			if (len == numChars) then break end
		end

		if (len == numChars and pos <= bytes) then
			return string:sub(1, pos - 1) .. (dots and '...' or '')
		else
			return string
		end
	end
end

T.Capitalize = function(str)
  -- Change the first character of a word to upper case

	return str:gsub('^%l', string.upper)
end

--==============================================--
--	Font
--==============================================--
T.FontString = function(parent, name, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(file, size, flag)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1, -1)
	fs:SetJustifyH('LEFT')
	if (not name) then
		parent.text = fs
	else
		parent[name] = fs
	end
	return fs
end

T.SetFontString = function(parent, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	local isValid = fs:SetFont(file, size, flag)
	if (fs and not isValid) then
		print('funcs @ T.SetFontString', 'Invalid font file', file)
		print('funcs', 'Parent', parent:GetName())										-- print('funcs', 'Invalid Font', fs:GetName())
	end
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

local SetFontString = function(parent, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(file, size, flag)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	parent.text = fs																-- parent.text:SetText(format("%s: %s", "Data Name", Value))
	return fs
end

