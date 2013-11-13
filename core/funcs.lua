local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('funcs', ...) end
local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']

local tinsert = table.insert
local assert, select, unpack = assert, select, unpack
local math, ceil, floor = math, math.ceil, math.floor
local string, format, gsub, match, reverse, upper = string, string.format, string.gsub, string.match, string.reverse, string.upper


local UnitClass = UnitClass
local IsInRaid  = IsInRaid
local IsInGroup = IsInGroup
local UnitIsGroupLeader    = UnitIsGroupLeader
local IsEveryoneAssistant  = IsEveryoneAssistant
local UnitIsGroupAssistant = UnitIsGroupAssistant

--==============================================--
--	Colon Syntax
--==============================================--
--[[ 	t = {}

	The following function definitions are equivalent:

		function t:foo(bar) end

		function t.foo(self, bar) end

	The following two function calls are equivalent:

		t:foo('baz')

		t.foo(t, 'baz')
--]]

--==============================================--
--	Properties
--==============================================--
local template
local texture = Addon.default.backdrop.texture

local bR, bG, bB, bA = unpack(Addon.default.backdrop.color)
local eR, eG, eB, eA = unpack(Addon.default.border.color)

--==============================================--
--	API
--==============================================--
local function Colorize(t)
	if (t == template) then return end

	if (t == 'CLASSCOLOR') then
		local Class = select(2, UnitClass('player'))
		local color = Addon.color.class[Class]

		bR, bG, bB, bA = unpack(Addon.default.backdrop.color)
		eR, eG, eB = color[1], color[2], color[3]
	else
		bR, bG, bB = unpack(Addon.default.backdrop.color)
		eR, eG, eB = unpack(Addon.default.border.color)
	end

	template = t
end

T.Overlay = function(f)

--[[	C['media'] = {
		['blank']			= [=[~\Media\White]=],		-- Texture for borders
		['hlite']			= [=[~\Media\Highlight]=],	-- Texture for debuffs highlight
		['tex']			= [=[~\Media\Texture]=],		-- Texture for status bars
		['border_color']	= {0.37, 0.3, 0.3, 1},		-- Color for borders
		['backdrop_color']	= {0, 0, 0, 1},			-- Color for borders backdrop
		['overlay_color']	= {0, 0, 0, 0.7},			-- Color for action bars overlay
	}]]

	if (f.overlay) then return end

	local overlay = f:CreateTexture('$parentOverlay', 'BORDER', f)
	overlay:SetPoint('TOPLEFT', P[2], -P[2])
	overlay:SetPoint('BOTTOMRIGHT', -P[2], P[2])
	overlay:SetTexture(Addon.default.overlay.texture)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)

	f.overlay = overlay
end

T.Border = function(f, i, o)
	local p = P[1]
	local i = P[1]	-- inset

	if (i) then
		if (f.iborder) then return end

		local border = CreateFrame('Frame', '$parentInnerBorder', f)
		border:SetPoint('TOPLEFT', p, -p)
		border:SetPoint('BOTTOMRIGHT', -p, p)
		border:SetBackdrop({
			edgeFile = Addon.default.border.texture,
			edgeSize = P[1],
			insets = {left = i, right = i, top = i, bottom = i}})
		border:SetBackdropBorderColor(unpack(Addon.default.backdrop.color))

		f.iborder = border
	end

	if (o) then
		if (f.oborder) then return end

		local border = CreateFrame('Frame', '$parentOuterBorder', f)
		border:SetPoint('TOPLEFT', -p, p)
		border:SetPoint('BOTTOMRIGHT', p, -p)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = Addon.default.border.texture,
			edgeSize = P[1],
			insets = {left = i, right = i, top = i, bottom = i}})
		border:SetBackdropBorderColor(unpack(Addon.default.backdrop.color))

		f.oborder = border
	end
end

T.Template = function(f, t, alt)
	Colorize(t)

	texture = alt and Addon.default.backdrop.textureAlt or Addon.default.backdrop.texture

	local i = P[1]
	f:SetBackdrop({
		bgFile 	= texture,
		edgeFile 	= Addon.default.border.texture,
		edgeSize	= P[1],
		insets	= {left = -i, right = -i, top = -i, bottom = -i},
	})

	if (t == 'TRANSPARENT') then
		bA = 0.8
		T.Border(f, true, true)

	elseif (t == 'OVERLAY') then
		bA = 1
		T.Overlay(f)
	else
		bA = Addon.default.overlay.color[4]
	end

	f:SetBackdropColor(bR, bG, bB, bA)
	f:SetBackdropBorderColor(eR, eG, eB, eA)
end

T.SkinFrame = function(f, t)
	Colorize(t)

	local i = P[1]
	f:SetBackdrop({																-- f:SetBackdrop(Addon.template.backdrop)
		bgFile 	= Addon.default.backdrop.texture,
		edgeFile 	= Addon.default.border.texture,
		edgeSize	= P[1],
		insets	= {left = -i, right = -i, top = -i, bottom = -i},
	})

	if (t == 'TRANSPARENT') then
		bA = Addon.default.overlay.color[4]
		T.Border(f, true, true)

	elseif (t == 'OVERLAY') then
		bA = 1
		T.Overlay(f)
	else
		bA = Addon.default.overlay.color[4]
	end

	f:SetBackdropColor(bR, bG, bB, bA)
	f:SetBackdropBorderColor(eR, eG, eB, eA)
end

T.SkinTooltip = function(f, t)
	local backdropA = 0.9

	if (t == 'TRANSPARENT') then
		backdropA = 0.5
	end

	bA = backdropA

	local i = P[1]
	f:SetBackdrop({
		bgFile 	= Addon.default.backdrop.texture,
		edgeFile 	= Addon.default.border.texture,
		edgeSize	= P[1],
		insets	= {left = -i, right = -i, top = -i, bottom = -i}})
	f:SetBackdropColor(unpack(Addon.default.backdrop.color))
	f:SetBackdropBorderColor(unpack(Addon.default.border.color))
end

T.Backdrop = function(f, t, alt)
	if (f.backdrop) then return end

	local p = P[2]

	if (not t) then t = 'DEFAULT' end

	local b = CreateFrame('Frame', '$parentBackdrop', f)
	b:SetPoint('TOPLEFT', -p, p)
	b:SetPoint('BOTTOMRIGHT', p, -p)

	T.Template(f, t, alt)					-- T.SkinFrame(f, t, alt)

	if (f:GetFrameLevel() - 1 >= 0) then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end

	f.backdrop = b
end

T.Shadow = function(f, t)
	if (f.shadow) then return end

	local p = P[3]
	local shadow = CreateFrame('Frame', '$parentShadow', f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint('TOPLEFT', -p, p)
	shadow:SetPoint('BOTTOMLEFT', -p, -p)
	shadow:SetPoint('TOPRIGHT', p, p)
	shadow:SetPoint('BOTTOMRIGHT', p, -p)

	local i = P[5]
	shadow:SetBackdrop({
		edgeFile = Addon.media.border.glow,
		edgeSize = P[3],
		insets   = {left = i, right = i, top = i, bottom = i}})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, .8)

	f.shadow = shadow
end

--==============================================--
--	Chat
--==============================================--
T.GetAnnounceChannel = function(warning)
	if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
		return 'INSTANCE_CHAT'

	elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then
		if (warning and (UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') or IsEveryoneAssistant())) then
			return 'RAID_WARNING'
		else
			return 'RAID'
		end

	elseif (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
		return 'PARTY'
	end

	return 'SAY'
end

--==============================================--
--	Frame
--==============================================--
T.MakeMovable = function(f, strata)
	if (strata) then
		f:SetFrameStrata(strata)
	end

	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetUserPlaced(true)
	f:SetClampedToScreen(true)
	f:SetScript('OnMouseUp', function(self) self:StopMovingOrSizing() end)
	f:SetScript('OnMouseDown', function(self) self:StartMoving() end)
end

T.CloseOnEsc = function(f)
  -- Use the ESC key to close the frame by adding its name to the UISpecialFrames table:

	tinsert(UISpecialFrames, f:GetName())

  -- [Note]: The frame must have a name.
  -- http://wowpedia.org/Make_frames_closable_with_the_Escape_key
end

T.Kill = function(obj)
	if (not obj) then return end

	if (obj.UnregisterAllEvents) then
		obj:UnregisterAllEvents()
		obj:SetParent(A["HiddenFrame"])
	else
		obj.Show = A["Dummy"]
	end

	obj:Hide()
end

T.Strip = function(obj, kill)
	for i = 1, obj:GetNumRegions() do
		local region = select(i, obj:GetRegions())

		if (region:GetObjectType() == 'Texture') then
			if (kill) then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end

--==============================================--
--	Object
--==============================================--
T.Button = function(parent, text)
  -- Button Factory

	local buttonName = '$parent' .. text .. 'Button'
	local button = CreateFrame('Button', buttonName, parent, 'UIPanelButtonTemplate')			-- local button = CreateFrame('Button', '$parent' .. text .. 'Button', parent, 'UIPanelButtonTemplate')
	button:SetText(text)

	return button
end

--==============================================--
--	Math
--==============================================--
--[[ T.Comma = function(num)
  -- credit:	AsphyxiaUI/Handler/Math.lua
  -- @[use]:	fs:SetText(format('%s: %s', 'TOTAL_RAID_DAMAGE', T.Comma(value)))

	local Left, Number, Right = match(num, '^([^%d]*%d)(%d*)(.-)$')

	return Left .. reverse(gsub(reverse(Number), '(%d%d%d)', '%1,')) .. Right
end

T.Round = function(number, decimals)
  -- Remove decimal from a number

	if (not decimals) then decimals = 0 end

	return (('%%.%df'):format(decimals)):format(number)  -- return format(format('%%.%df', decimals), number) --> AsphyxiaUI/Handler/Math.lua
end

T.RGBToHex = function(r, g, b)
  -- Converts a color from an RGB format to Hexidecimal format

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

T.ShortValue = function(v)
  -- Inputs (120,000) and returns 120k

	if (v <= 999) then
		return v
	end

	if (v >= 1000000) then
		return format('%.1fm', v / 1000000)

	elseif (v >= 1000) then
		return format('%.1fk', v / 1000)
	end
end
--]]

--==============================================--
--	Time
--==============================================--
--[[ T.FormatTime = function(s)
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
--]]

T.FormatTime_Tukui = function(s)
  -- Display seconds as mins / hours / days (credit: Tukui)

	local day = 86400
	local hour = 3600
	local minute = 60

	if     (s >= day)    	then return format('%dd', ceil(s / day))
	elseif (s >= hour)   	then return format('%dh', ceil(s / hour))
	elseif (s >= minute) 	then return format('%dm', ceil(s / minute))
	elseif (s >= minute/12)	then return floor(s) end

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

T.FormatTime = function(s)
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

--[[ T.GetFormattedTime = function(s)				-- cooldown.lua

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
--]]


--==============================================--
--	Text
--==============================================--
--[[ local NumberFormats = {
	['CURRENT'] 			= "%s",
	['CURRENT_MAX']		= "%s - %s",
	['CURRENT_PERCENT']		= "%s - %s%%",
	['CURRENT_MAX_PERCENT']	= "%s - %s | %s%%",
	['DEFICIT'] 			= "-%s",
	['PERCENT'] 			= "%s%%",
}

T.GetFormattedText = function(nf, min, max)
	assert(NumberFormats[nf], 'Invalid number format (nf): ' .. nf)
	assert(min, 'You need to provide a current value. ' ..
			  'Usage:  T.GetFormattedText(nf, min, max)')
	assert(max, 'You need to provide a maximum value. '..
			  'Usage:  T.GetFormattedText(nf, min, max)')

	if (max == 0) then max = 1 end

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
--]]

--==============================================--
--	Player Information
--==============================================--
T.CheckRole = function()
	local role = ''
	local tree = GetSpecialization()

	if (tree) then
		role = select(6, GetSpecializationInfo(tree))
	end

	return role
end

T.InCombat = function()
	return InCombatLockdown() or UnitAffectingCombat('player') or UnitAffectingCombat('pet')
end



--==============================================--
--	Backup
--==============================================--
--[[	T.GetClassColor = function(class)
	  -- All-in-1 ClassColor Function (credit: Prat3.0\services\classcolor.lua)
		class = class:upper()

		if (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) then
			return CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
		end

		if (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]) then
			return RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
		end

		return 0.63, 0.63, 0.63
	end
--]]

--[[ T.Template Snip

	if (alt) then
		texture = Addon.default.backdrop.textureAlt
	else
		texture = Addon.default.backdrop.texture
	end
--]]
