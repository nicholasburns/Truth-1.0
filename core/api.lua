local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('api', ...) end

local P = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']
local scale = _G[AddOn]['pixel']['scale']

local select, unpack, pairs, ipairs = select, unpack, pairs, ipairs
local math, ceil, floor, max, min = math, math.ceil, math.floor, math.max, math.min
local string, find, format = string, string.find, string.format
local table, tinsert = table, table.insert

local Kill = T.Kill
local Strip = T.Strip


--==============================================--
--	Properties
--==============================================--
local template
local texture = Addon.default.backdrop.texture

local bR, bG, bB, bA = unpack(Addon.default.backdrop.color)
local eR, eG, eB, eA = unpack(Addon.default.border.color)

--================================================================================================--
--							Pixel API
--================================================================================================--
local Scale = scale

local Size = function(f, w, h)
	f:SetSize(scale(w), scale(h or w))
end

local Width = function(f, w)
	f:SetWidth(scale(w))
end

local Height = function(f, h)
	f:SetHeight(scale(h))
end

local Point = function(o, a1, a2, a3, a4, a5)
	if (type(a1)=='number') then a1 = scale(a1) end
	if (type(a2)=='number') then a2 = scale(a2) end
	if (type(a3)=='number') then a3 = scale(a3) end
	if (type(a4)=='number') then a4 = scale(a4) end
	if (type(a5)=='number') then a5 = scale(a5) end

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint(a1, a2, a3, a4, a5)
end

local SetInside = function(o, anchor, x, y)
	anchor = anchor or o:GetParent()
	x, y = x or 2, y or 2

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint('TOPLEFT', anchor, x, -y)
	o:SetPoint('BOTTOMRIGHT', anchor, -x, y)
end

local SetOutside = function(o, anchor, x, y)
	anchor = anchor or o:GetParent()
	x, y = x or 2, y or 2

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint('TOPLEFT', anchor, -x, y)
	o:SetPoint('BOTTOMRIGHT', anchor, x, -y)
end

--================================================================================================--

--							  Frame API

--================================================================================================--
local Colorize = function(t)
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

local Overlay = function(f)

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

local Border = function(f, i, o)
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

local Template = function(f, t, alt)
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

local Backdrop = function(f, t, alt)
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

local Shadow = function(f, t)
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

local StyleButton = function(button)
	if (button.SetHighlightTexture and not button.hover) then
		local hover = button:CreateTexture('Frame', nil, self) --[[ GLOBAL self!! ]]--
		hover:SetTexture(1, 1, 1, 0.3)
		hover:SetPoint('TOPLEFT', 2, -2)
		hover:SetPoint('BOTTOMRIGHT', -2, 2)

		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if (button.SetPushedTexture and not button.pushed) then
		local pushed = button:CreateTexture('Frame', nil, self) --[[ GLOBAL self!! ]]--
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		pushed:SetPoint('TOPLEFT', 2, -2)
		pushed:SetPoint('BOTTOMRIGHT', -2, 2)

		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if (button.SetCheckedTexture and not button.checked) then
		local checked = button:CreateTexture('Frame', nil, self) --[[ GLOBAL self!! ]]--
		checked:SetTexture(0, 1, 0, 0.3)
		checked:SetPoint('TOPLEFT', 2, -2)
		checked:SetPoint('BOTTOMRIGHT', -2, 2)

		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName() .. 'Cooldown']

	if (cooldown) then
		cooldown:ClearAllPoints()
		cooldown:SetPoint('TOPLEFT', 2, -2)
		cooldown:SetPoint('BOTTOMRIGHT', -2, 2)
	end
end

local NewBackdrop = function(self)
	local color = RAID_CLASS_COLORS[ A["MyClass"] ]
	self:SetBackdropColor(color.r * .15, color.g * .15, color.b * .15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local OldBackdrop = function(self)
	local color = RAID_CLASS_COLORS[ A["MyClass"] ]
	self:Template()
end

-- T.Colorize 			= Colorize
-- T.Overlay			= Overlay
-- T.Border			= Border
-- T.Template			= Template
-- T.Backdrop 			= Backdrop
-- T.Shadow			= Shadow
-- T.StyleButton 		= StyleButton
-- T.AltBackdrop 		= AltBackdrop				-- T.SetModifiedBackdrop = SetModifiedBackdrop
-- T.FixBackdrop 		= FixBackdrop				-- T.SetOriginalBackdrop = SetOriginalBackdrop
local AltBackdrop 		= NewBackdrop
local FixBackdrop 		= OldBackdrop

--================================================================================================--

--	Skin API

--================================================================================================--
--[[
local function SkinButton(f, strip)
	local n = f:GetName()

	if (n) then
		if (_G[n .. 'Left']) then _G[n .. 'Left']:SetAlpha(0) end
		if (_G[n .. 'Middle']) then _G[n .. 'Middle']:SetAlpha(0) end
		if (_G[n .. 'Right']) then _G[n .. 'Right']:SetAlpha(0) end
	end

	if (f.Left) then f.Left:SetAlpha(0) end
	if (f.Right) then f.Right:SetAlpha(0) end
	if (f.Middle) then f.Middle:SetAlpha(0) end
	if (f.SetNormalTexture) then f:SetNormalTexture('') end
	if (f.SetHighlightTexture) then f:SetHighlightTexture('') end
	if (f.SetPushedTexture) then f:SetPushedTexture('') end
	if (f.SetDisabledTexture) then f:SetDisabledTexture('') end
	if (strip) then Strip(f) end

	Template(f, 'DEFAULT')

	f:HookScript('OnEnter', AltBackdrop)
	f:HookScript('OnLeave', FixBackdrop)
end

local function SkinCheckBox(f)
	Strip(f)
	CreateBackdrop(f, 'DEFAULT')

	SetPoint(f.backdrop, 'TOPLEFT', 4, -4)
	SetPoint(f.backdrop, 'BOTTOMRIGHT', -4, 4)

	if (f.SetCheckedTexture) then
		f:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check')
	end
	if (f.SetDisabledCheckedTexture) then
		f:SetDisabledCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
	end


	f:HookScript('OnDisable', function(self)
		if (not self.SetDisabledTexture) then return end

		if (self:GetChecked()) then
			self:SetDisabledTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		else
			self:SetDisabledTexture('')
		end
	end)

	f.SetNormalTexture = function() return end
	f.SetPushedTexture = function() return end
	f.SetHighlightTexture = function() return end
end

local function SkinCloseButton(f, point)
	if (point) then
		SetPoint(f, 'TOPRIGHT', point, 'TOPRIGHT', 2, 2)
	end

	f:SetNormalTexture('')
	f:SetPushedTexture('')
	f:SetHighlightTexture('')
	f:SetDisabledTexture('')

	f.t = f:CreateFontString(nil, 'OVERLAY')
	f.t:SetFont(Addon.default.font.pixel, 12, 'MONOCHROMEOUTLINE')
	f.t:SetPoint('CENTER', 0, 1)
	f.t:SetText('x')
end

local function SkinEditBox(f)
	if (_G[f:GetName() .. 'Left']) then Kill(_G[f:GetName() .. 'Left']) end
	if (_G[f:GetName() .. 'Middle']) then Kill(_G[f:GetName() .. 'Middle']) end
	if (_G[f:GetName() .. 'Right']) then Kill(_G[f:GetName() .. 'Right']) end
	if (_G[f:GetName() .. 'Mid']) then Kill(_G[f:GetName() .. 'Mid']) end

	CreateBackdrop(f, 'DEFAULT')

	if (f:GetName() and f:GetName():find('Silver') or f:GetName():find('Copper')) then
		SetPoint(f.backdrop, 'BOTTOMRIGHT', -12, -2)
	end
end

local function SkinIconButton(b, shrinkIcon)
	if (b.skinnedIconButton) then return end

	b:Strip()
	b:CreateBackdrop('DEFAULT', true)
	b:StyleButton()

	local icon = b.icon

	if (b:GetName() and _G[b:GetName() .. 'IconTexture']) then
		icon = _G[b:GetName() .. 'IconTexture']
	elseif (b:GetName() and _G[b:GetName() .. 'Icon']) then
		icon = _G[b:GetName() .. 'Icon']
	end

	if (icon) then
		icon:SetTexCoord(.08, .88, .08, .88)

		-- create a backdrop around the icon
		if (shrinkIcon) then
			b.backdrop:SetAllPoints()
			icon:SetInside(b)
		else
			b.backdrop:SetOutside(icon)
		end

		icon:SetParent(b.backdrop)
	end

	b.skinnedIconButton = true
end

local function SkinNextPrevButton(btn, horizonal)
	Template(btn, 'DEFAULT')
	Size(btn, btn:GetWidth() - 7, btn:GetHeight() - 7)

	if (horizonal) then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
	else
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)

		if (btn:GetPushedTexture()) then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end

		if (btn:GetDisabledTexture()) then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end

	btn:GetNormalTexture():ClearAllPoints()
	SetPoint(btn:GetNormalTexture(), 'TOPLEFT', 2, -2)
	SetPoint(btn:GetNormalTexture(), 'BOTTOMRIGHT', -2, 2)

	if (btn:GetDisabledTexture()) then
		btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
	end

	if (btn:GetPushedTexture()) then
		btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	end

	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

local function SkinDropDownBox(f, width)
	local button = _G[f:GetName() .. 'Button']

	if (not width) then
		width = 155
	end

	Strip(f)
	SetWidth(f, width)

	_G[f:GetName() .. 'Text']:ClearAllPoints()
	SetPoint(_G[f:GetName() .. 'Text'], 'RIGHT', button, 'LEFT', -2, 0)

	button:ClearAllPoints()
	button:SetPoint('RIGHT', f, -10, 3)

	button.SetPoint = T.dummy

	SkinNextPrevButton(button, true)
	CreateBackdrop(f, 'DEFAULT')

	f.backdrop:SetPoint('TOPLEFT', 20, -2)
	f.backdrop:SetPoint('BOTTOMRIGHT', button, 2, -2)
end

local function SkinRotateButton(btn)
	Template(btn, 'DEFAULT')

	Size(btn, btn:GetWidth() - 14, btn:GetHeight() - 14)

	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetNormalTexture():ClearAllPoints()

	btn:GetNormalTexture():SetPoint('TOPLEFT', 2, -2)
	btn:GetNormalTexture():SetPoint('BOTTOMRIGHT', -2, 2)

	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

local function SkinScrollBar(f)
	if (_G[f:GetName() .. 'BG']) then 		_G[f:GetName() .. 'BG']:SetTexture(nil) end
	if (_G[f:GetName() .. 'Track']) then 	_G[f:GetName() .. 'Track']:SetTexture(nil) end
	if (_G[f:GetName() .. 'Top']) then 	_G[f:GetName() .. 'Top']:SetTexture(nil) end
	if (_G[f:GetName() .. 'Bottom']) then 	_G[f:GetName() .. 'Bottom']:SetTexture(nil) end
	if (_G[f:GetName() .. 'Middle']) then 	_G[f:GetName() .. 'Middle']:SetTexture(nil) end

	if (_G[f:GetName() .. 'ScrollUpButton'] and _G[f:GetName() .. 'ScrollDownButton']) then

		Strip(_G[f:GetName() .. 'ScrollUpButton'])
		Template(_G[f:GetName() .. 'ScrollUpButton'], 'DEFAULT', true)

		if (not _G[f:GetName() .. 'ScrollUpButton'].texture) then
			_G[f:GetName() .. 'ScrollUpButton'].texture = _G[f:GetName() .. 'ScrollUpButton']:CreateTexture(nil, 'OVERLAY')
			SetPoint(_G[f:GetName() .. 'ScrollUpButton'].texture, 'TOPLEFT', 2, -2)
			SetPoint(_G[f:GetName() .. 'ScrollUpButton'].texture, 'BOTTOMRIGHT', -2, 2)
			_G[f:GetName() .. 'ScrollUpButton'].texture:SetTexture("Interface\\AddOns\\Truth\\media\\textures\\arrowup.tga")
			_G[f:GetName() .. 'ScrollUpButton'].texture:SetVertexColor(unpack(BORDER_COLOR))
		end

		Strip(_G[f:GetName() .. 'ScrollDownButton'])
		Template(_G[f:GetName() .. 'ScrollDownButton'], 'DEFAULT', true)

		if (not _G[f:GetName() .. 'ScrollDownButton'].texture) then
			_G[f:GetName() .. 'ScrollDownButton'].texture = _G[f:GetName() .. 'ScrollDownButton']:CreateTexture(nil, 'OVERLAY')
			_G[f:GetName() .. 'ScrollDownButton'].texture:SetPoint('TOPLEFT', 2, -2)
			_G[f:GetName() .. 'ScrollDownButton'].texture:SetPoint('BOTTOMRIGHT', -2, 2)
			_G[f:GetName() .. 'ScrollDownButton'].texture:SetTexture("Interface\\AddOns\\Truth\\media\\textures\\arrowdown.tga")
			_G[f:GetName() .. 'ScrollDownButton'].texture:SetVertexColor(unpack(BORDER_COLOR))
		end

		if (not f.trackbg) then
			f.trackbg = CreateFrame('Frame', nil, f)
			SetPoint(f.trackbg, 'TOPLEFT', _G[f:GetName() .. 'ScrollUpButton'], 'BOTTOMLEFT', 0, -1)
			SetPoint(f.trackbg, 'BOTTOMRIGHT', _G[f:GetName() .. 'ScrollDownButton'], 'TOPRIGHT', 0, 1)
			Template(f.trackbg, 'Transparent')
		end

		if (f:GetThumbTexture()) then
			if (not thumbTrim) then thumbTrim = 3 end
			f:GetThumbTexture():SetTexture(nil)

			if (not f.thumbbg) then
				f.thumbbg = CreateFrame('Frame', nil, f)
				f.thumbbg:SetPoint('TOPLEFT', f:GetThumbTexture(), 2, -thumbTrim)
				f.thumbbg:SetPoint('BOTTOMRIGHT', f:GetThumbTexture(), -2, thumbTrim)
				Template(f.thumbbg, 'DEFAULT', true)

				if (f.trackbg) then
					f.thumbbg:SetFrameLevel(f.trackbg:GetFrameLevel())
				end
			end
		end
	end
end

local function SkinSlideBar(f, height, movetext)
	f:Template('DEFAULT')
	f:SetBackdropColor(0, 0, 0, .8)

	if (not height) then
		height = f:GetHeight()
	end

	if (movetext) then
		if(_G[f:GetName() .. 'Low']) then _G[f:GetName() .. 'Low']:SetPoint('BOTTOM', 0, -18) end
		if(_G[f:GetName() .. 'High']) then _G[f:GetName() .. 'High']:SetPoint('BOTTOM', 0, -18) end
		if(_G[f:GetName() .. 'Text']) then _G[f:GetName() .. 'Text']:SetPoint('TOP', 0, 19) end
	end

	_G[f:GetName()]:SetThumbTexture(Addon.default.backdrop.texture)
	_G[f:GetName()]:GetThumbTexture():SetVertexColor(unpack(Addon.default.border.color))

	if(f:GetWidth() < f:GetHeight()) then
		f:SetWidth(height)

		_G[f:GetName()]:GetThumbTexture():Size(f:GetWidth(), f:GetWidth() + 4)
	else
		f:SetHeight(height)

		_G[f:GetName()]:GetThumbTexture():Size(height + 4, height)
	end
end

local function SkinTab(tab)
	-- local tabs = {'LeftDisabled','MiddleDisabled','RightDisabled','Left','Middle','Right'}
	if (not tab) then return end
	--[=[
		for _, obj in pairs(tabs) do
			local tex = _G[tab:GetName() .. obj]
			if (tex) then
				tex:SetTexture(nil)
			end
		end

		if (tab.GetHighlightTexture and tab:GetHighlightTexture()) then
			tab:GetHighlightTexture():SetTexture(nil)
		else
			Strip(tab)
		end
	--]=]

	tab.backdrop = CreateFrame('Frame', nil, tab)
	Template(tab.backdrop, 'DEFAULT')
	tab.backdrop:SetBackdrop({
		bgFile 	= texture,
		edgeFile 	= texture,
		edgeSize 	= px,
		insets 	= {left = -px, right = -px, top = -px, bottom = -px}})
	tab.backdrop:SetBackdropColor(bR, bG, bB, bA)
	tab.backdrop:SetBackdropBorderColor(eR, eG, eB)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:SetPoint('TOPLEFT', 10, -3)
	tab.backdrop:SetPoint('BOTTOMRIGHT', -10, 3)
end

T.SkinButton 						= SkinButton
T.SkinCheckBox 					= SkinCheckBox
T.SkinCloseButton 					= SkinCloseButton
T.SkinDropDownBox 					= SkinDropDownBox
T.SkinEditBox 						= SkinEditBox
T.SkinIconButton 					= SkinIconButton
T.SkinNextPrevButton 				= SkinNextPrevButton
T.SkinRotateButton 					= SkinRotateButton
T.SkinScrollBar 					= SkinScrollBar
T.SkinSlideBar 					= SkinSlideBar
T.SkinTab 						= SkinTab
--]]
--================================================================================================--

--							 Injection

--================================================================================================--
local function addapi(O)
	local mt = getmetatable(O).__index

	-- Utils
	if (not O.Kill) then 			mt.Kill 				= Kill end
	if (not O.Strip) then 			mt.Strip 				= Strip end

	-- Pixel API
	if (not O.Scale) then 			mt.Scale 				= Scale end
	if (not O.Size) then 			mt.Size 				= Size end
	if (not O.Width) then 			mt.Width 				= Width end
	if (not O.Height) then 			mt.Height 			= Height end
	if (not O.Point) then 			mt.Point 				= Point end
	if (not O.SetInside) then 		mt.SetInside 			= SetInside end
	if (not O.SetOutside) then 		mt.SetOutside 			= SetOutside end

	-- Frame API
	if (not O.Colorize) then 		mt.Colorize 			= Colorize end
	if (not O.Overlay) then 			mt.Overlay 			= Overlay end
	if (not O.Border) then 			mt.Border 			= Border end
	if (not O.Template) then 		mt.Template 			= Template end
	if (not O.Backdrop) then			mt.Backdrop 			= Backdrop end
	if (not O.Shadow) then 			mt.Shadow 			= Shadow end

	if (not O.NewBackdrop) then		mt.NewBackdrop 		= NewBackdrop end
	if (not O.OldBackdrop) then		mt.OldBackdrop 		= OldBackdrop end
	if (not O.AltBackdrop) then		mt.AltBackdrop 		= AltBackdrop end
	if (not O.FixBackdrop) then		mt.FixBackdrop 		= FixBackdrop end

	-- Accessory Functions
	if (not O.StyleButton) then 		mt.StyleButton 		= StyleButton end
	if (not O.FontString) then 		mt.FontString			= FontString end

	-- Skin API
	-- if (not O.SkinButton) then 		mt.SkinButton 			= SkinButton end
	-- if (not O.SkinCheckBox) then 		mt.SkinCheckBox 		= SkinCheckBox end
	-- if (not O.SkinCloseButton) then 	mt.SkinCloseButton 		= SkinCloseButton end
	-- if (not O.SkinDropDownBox) then 	mt.SkinDropDownBox 		= SkinDropDownBox end
	-- if (not O.SkinEditBox) then 		mt.SkinEditBox 		= SkinEditBox end
	-- if (not O.SkinIconButton) then 	mt.SkinIconButton 		= SkinIconButton end
	-- if (not O.SkinNextPrevButton) then	mt.SkinNextPrevButton 	= SkinNextPrevButton end
	-- if (not O.SkinRotateButton) then 	mt.SkinRotateButton 	= SkinRotateButton end
	-- if (not O.SkinScrollBar) then 	mt.SkinScrollBar 		= SkinScrollBar end
	-- if (not O.SkinSlideBar) then 		mt.SkinSlideBar 		= SkinSlideBar end
	-- if (not O.SkinTab) then 			mt.SkinTab 			= SkinTab end
end

local handled = {['Frame'] = true}
local obj = CreateFrame('Frame')

addapi(obj)
addapi(obj:CreateTexture())
addapi(obj:CreateFontString())

obj = EnumerateFrames()

while (obj) do
	if (not handled[obj:GetObjectType()]) then
		addapi(obj)
		handled[obj:GetObjectType()] = true
	end
	obj = EnumerateFrames(obj)
end--]]

--==============================================--
--	Backup
--==============================================--
--[[ Constants

	local BACKDROP_TEXTURE 				= Addon.default.backdrop.texture
	local BACKDROP_COLOR 				= Addon.default.backdrop.color
	local bR, bG, bB, bA				= unpack(BACKDROP_COLOR)

	local BORDER_TEXTURE 				= Addon.default.border.texture
	local BORDER_COLOR	 				= Addon.default.border.color
	local eR, eG, eB, eA				= unpack(BORDER_COLOR)
--]]
