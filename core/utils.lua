local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('utils', ...) end






--==============================================--
--	Dump
--==============================================--
local select = select

Addon.dump = function(...)
	for i = 1, select('#', ...) do
		local arg = select(i, ...)			--~  Get i-th parameter

		-- <loop body>

		print(#(...))
		print(i, arg[i])

	  -- print('print', #(...))
	  -- print('print', i, arg[i])
	end
end


--==============================================--
--	Tables
--==============================================--
local rawget = rawget
local select = select
local sort = table.sort
local type = type
local tinsert = tinsert
local pairs, ipairs = pairs, ipairs
local tonumber, tostring = tonumber, tostring
local getmetatable = getmetatable



Addon.ArgsToTable = function(dst, ...)
	dst = dst or {}

	for i = 1, select('#', ...), 2 do
		dst[select(i, ...)] = select(i+1, ...)
	end

	return dst
end

Addon.TableSet = function(t, k, v, isCopy)
	if (rawget(t, k) ~= v) then
		if (t[k] == v) then 				--~ Exists
			v = self:TableCopy(v)
		end

		t[k] = v
	end

	return v
end

Addon.TableAddUnique = function(t, v)
	if (type(t) ~= 'table') then return end

	local found

	for _, v1 in pairs(t) do
		if (v == v1) then
			found = true
			break
		end
	end

	if (not found) then
		tinsert(t, v)
	end
end

Addon.TableGetTables = function(t)
	local m

	local a = {}

	while (type(t) == 'table' and #a < 10) do
		tinsert(a, t)

		m = getmetatable(t)
		t = (m and m ~= t) and m.__index or nil
	end

	return a
end

Addon.TableGetKeys = function(t)
	local a = self:TableGetTables(t)

	local list = {}

	for _, v in ipairs(a) do

		for k1, v1 in pairs(v) do
			if (type(v1) ~= 'function') then
				self:TableAddUnique(list, k1)
			end
		end
	end

	return list, a
end

Addon.TableGetValues = function(t, shouldSort)
	local a = self:TableGetTables(t)

	local keys = {}
	local list = {}
	local list2 = nil

	for _, v in ipairs(a) do
		list2 = {}

		for k1, v1 in pairs(v) do
			if (type(v1) ~= 'function' and (not keys[k1])) then
				keys[k1] = true

				tinsert(list2, v1)
			end
		end

		if (shouldSort) then
			sort(list2, shouldSort)
		end

		for i1, v1 in ipairs(list2) do
			tinsert(list, v1)
		end
	end

	return list
end

Addon.DebugTable = function(...)
 if (not self:Debug(...)) then return end

	for i = 1, select('#', ...) do
		local idx, a = self:TableGetKeys(select(i, ...))

		sort(idx, self.SortSafe)

		for _, v1 in pairs(idx) do
			local s = ''

			for _, v2 in pairs(a) do
				s = self:tostring(':', 200, s, rawget(v2, v1))
			end

			self:SysMsg(' ', v1, '=', s)
		end
	end
end

Addon.TableCopy = function(s)
	local lookup = {}

	local function _copy(s)
		if (type(s) ~= 'table') then
			return s
		elseif (lookup[s]) then
			return lookup[s]
		end

		local t = {}
		lookup[s] = t

		for i, v in pairs(s) do
				t[_copy(i)] = _copy(v)
			end

		return t
	end

	return _copy(s)
end

Addon.TableMerge = function(d, s, ref)
 	if (d ~= s and (not d or (s and ((type(d) == 'table') == (type(s) == 'table'))))) then

		if (type(s) ~= 'table' or (ref and not d)) then
			return s
		end

		if (not d) then
			d = {}
		end

		for i, v in pairs(s) do
			local isK = type(i) ~= 'number'

			s = self:TableMerge((isK and d[i] or nil), v, ref) 							-- if (s == v and type(s) == 'table') then self:Debug('mref', i, d, s) end

			if (isK) then
				d[i] = s
			else
				tinsert(d, s)
			end
		end
	end

	return d
end

Addon.SortSafe = function(a, b)
	if (tonumber(a) and tonumber(b)) then
		return tonumber(a) < tonumber(b)

	elseif (tostring(a) and tostring(b)) then
		return tostring(a) < tostring(b)

	end

	return false
end


--==============================================--
--	Time
--==============================================--
local time = time
local date = date
local GetGameTime = GetGameTime

-- Datatable
local _timetable = {}


Addon.GetTime = function(s, ts)				--~  Convert string, or now to timestamp
	local _, d

	if (s) then
		d = _timetable

		_, _, d.month, d.day, d.year, d.hour, d.min, d.sec = s:find('(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)')

		if (not d.year) then return end

		if (d.year:len() == 2) then
			d.year = '20' .. d.year
		end
	end

	s = time(d)

	return s and (s + (ts or 0)) or nil
end

Addon.GetDate = function(n, tz, fmt)			--~  Convert timestamp, [tzoffset], [format], or now to formatted string
	return date(fmt or '%m/%d/%y %H:%M:%S', (n or time()) + (tz and (tz * 3600) or 0))
end

Addon.GetGameTime = function()				--~  Get game server time (current time of day for servers timezone)
	local hour, minute = GetGameTime()
	return (hour * 3600) + (minute * 60)
end

Addon.GetSysTime = function()					--~  Get computers time (current time of day for computers timezone)
	local t = date('*t')
	return (t.hour * 3600) + (t.min * 60) + t.sec
end

Addon.GetTimeDiff = function(game, sys)
	game = game or self:GetGameTime() sys = sys or self:GetSysTime()

	local t = 0

	if (game >= sys) then
		sys = game - sys
		t = sys + (sys >= (12 * 3600) and (-24 * 3600) or 0)
	elseif (game < sys) then
		sys = sys - game
		if (sys >= (12 * 3600)) then
			t = (24 * 3600) - sys
		else
			t = sys * -1
		end
	end

	return t
end


--==============================================--
--	Color
--==============================================--
Addon.HexToScale = function(s, o1, o2)
	if (o1) then
		s = s:sub(o1, o2)
	end

	local n = tonumber(s, 16)
	local divs = ((2 ^ ((s:len()/2) * 8)) - 1)	--~  self:Debug('HexToScale', s, n, divs, n/divs)

	return (n) and (n / divs) or 1
end

Addon.ColorToRGB = function(s)
	local n = s and s:len() or 0

	if (n < 6) then
		return 1, 1, 1
	end

	return self:HexToScale(s, n-5, n-4), self:HexToScale(s, n-3, n-2), self:HexToScale(s, n-1, n)
end


--==============================================--
--	Tooltip
--==============================================--
local find = string.find
local GetText = GetText
local CreateFrame = CreateFrame
local GetRealZoneText = GetRealZoneText
local CreateFontString = CreateFontString
local WorldFrame = WorldFrame
local PVP = PVP

Addon.GetScanTooltip = function()
	local f = TruthScanTooltip

	if (f) then return f end

	f = CreateFrame('GameTooltip', 'TruthScanTooltip')			-- tooltip name cannot be nil
	f:SetOwner(WorldFrame, 'ANCHOR_NONE')
	f.left = {}
	f.right = {}

	for i = 1, 30 do
		f.left[i] = f:CreateFontString('$parentTextLeft .. i', nil, 'GameTooltipText')
		f.right[i] = f:CreateFontString('$parentTextRight .. i', nil, 'GameTooltipText')

		f:AddFontStrings(f.left[i], f.right[1])
	end

	return f
end

Addon.GetItemTooltip = function(link)
	local f = self:GetScanTooltip()
	local t = {}

	f:ClearLines()
	f:SetHyperlink(find(link, '^item:%d') and link or ('item:' .. link))

	for i = 1, f:NumLines() do
		tinsert(t, { left = f.left[i]:GetText(), right = f.right[i]:GetText() })
	end

	return t
end

Addon.UnitZone = function(unit)
	if (unit == 'player') then
		return GetRealZoneText()
	end

	local f = self:GetScanTooltip()

	f:ClearLines()
	f:SetUnit(unit)

	local s = f.left[f:NumLines()]:GetText()

	if (s == PVP or s:find('^Level')) then return end

	return s
end


--==============================================--
--	Debug
--==============================================--
local pcall = pcall

Addon.SafeCall = function(f, ...)
	local e, r1, r2, r3, r4 = pcall(f, ...)

	if (not e) then
		self:Debug('SafeCall exception', r1)
		return
	end

	return r1, r2, r3, r4
end




--==============================================--
--	Print Key Values
--==============================================--
Addon.printkeys = function(...)
	if (type(...) ~= "table") then return end

	for k in pairs(...) do
		print(k)
	end
end

--==============================================--
--	Remove leading & trailing whitespace
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
	local table = table
	local concat = table.concat

	local function arrayer(a)
		print('{' .. table.concat(a, ', ') .. '}')
	end
end
Addon.arrayer = arrayer

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

