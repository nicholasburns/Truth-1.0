local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('funcs', ...) end
local P = A["PixelSizer"]
local X = A["PixelSize"]

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
	local button = CreateFrame('Button', '$parent'..text..'Button', parent, 'UIPanelButtonTemplate')
	button:SetText(text)

	return button
end

T.ResizeButton = function(frame)
	local resize = CreateFrame('Button', '$parentResizeButton', frame)
	resize:SetPoint('BOTTOMRIGHT', frame, -5, 5)
	resize:SetSize(16, 16)
	resize:SetNormalTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]=])
	resize:SetPushedTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]=])
	resize:SetHighlightTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]=])
	resize:SetScript('OnMouseDown', function(self) frame:StartSizing() end)
	resize:SetScript('OnMouseUp',   function(self) frame:StopMovingOrSizing() end)
-- f.resize = CreateFrame('Button', '$parentResizeButton', frame)
-- f.resize:SetPoint('BOTTOMRIGHT', frame, -5, 5)
-- f.resize:SetSize(16, 16)
-- f.resize:SetNormalTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]=])
-- f.resize:SetPushedTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]=])
-- f.resize:SetHighlightTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]=])
-- f.resize:SetScript('OnMouseDown', function(self) f:StartSizing() end)
-- f.resize:SetScript('OnMouseUp',   function(self) f:StopMovingOrSizing() end)
end

T.CloseButton = function(frame)
	local close = CreateFrame('Button', '$parentCloseButton', f, 'UIPanelCloseButton')
	close:SetPoint('TOPRIGHT', 4, 0)
	close:SetScript('OnClick', function() f:Hide() end)
-- f.close = CreateFrame('Button', '$parentCloseButton', f, 'UIPanelCloseButton')
-- f.close:SetPoint('TOPRIGHT', 4, 0)
-- f.close:SetScript('OnClick', function() f:Hide() end)
end


--==============================================--
--	Player Information
--==============================================--
T.PlayerHasBuff = function(buffname)
--~  Checks current buffs for a buff that matches "buffname"

	for i = 1, 40 do
		local name = UnitBuff("player", i)
		if (name == nil) then return false end
		if (name == buffname) then return true end
	end

	return false
end

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

T.PlayerInCombat = function()
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
