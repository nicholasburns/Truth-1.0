local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('api', ...) end
local select, type, unpack, pairs, ipairs = select, type, unpack, pairs, ipairs
local math, ceil, floor, max, min = math, math.ceil, math.floor, math.max, math.min
local string, find, format = string, string.find, string.format
local table, tinsert = table, table.insert
local getmetatable = getmetatable
local CreateFrame = CreateFrame
local UnitClass = UnitClass

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
local X = A["PixelSize"]
local P = A["PixelSizer"]

local scale = function(x)
	return X * floor(x / X + 0.5)
end

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

local Kill = function(obj)
	if (not obj) then return end

	if (obj.UnregisterAllEvents) then
		obj:UnregisterAllEvents()
		obj:SetParent(A["HiddenFrame"])
	else
		obj.Show = A["Dummy"]
	end

	obj:Hide()
end

local Strip = function(obj, kill)
	for i = 1, (obj:GetNumRegions()) do
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

local MakeMovable = function(f, strata)
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

	local i = P[5]
	f:SetBackdrop({
		bgFile 	= texture,
		edgeFile 	= Addon.default.border.texture,
		edgeSize	= 1, -- P[1],
		-- insets	= {left = i, right = i, top = i, bottom = i}, -- insets	= {left = -i, right = -i, top = -i, bottom = -i},
	})

	if (t == 'TRANSPARENT') then
		bA = 0.8

		Border(f, true, true)

	elseif (t == 'OVERLAY') then
		bA = 1

		Overlay(f)

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

	Template(f, t, alt)						-- T.SkinFrame(f, t, alt)

	if (f:GetFrameLevel() - 1 >= 0) then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end

	f.backdrop = b
end

local Shadow = function(f)
	if (f.shadow) then return end

	local offset = 3	-- P[3]
	local inset  = P[5]


	local shadow = CreateFrame('Frame', '$parentShadow', f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint('TOPLEFT', -offset, offset)
	shadow:SetPoint('BOTTOMLEFT', -offset, -offset)
	shadow:SetPoint('TOPRIGHT', offset, offset)
	shadow:SetPoint('BOTTOMRIGHT', offset, -offset)
	shadow:SetBackdrop({
		edgeFile = Addon.media.border.glow,
		edgeSize = P[3],
		insets   = {left = inset, right = inset, top = inset, bottom = inset}})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, .5)			-- (0, 0, 0, .8)

	f.shadow = shadow
end

local StyleButton = function(b)
	if (b.SetHighlightTexture and not b.hover) then
		local hover = b:CreateTexture('Frame', '$parentHiliteTexture', b)
		hover:SetTexture(1, 1, 1, 0.3)
		hover:SetPoint('TOPLEFT', 2, -2)
		hover:SetPoint('BOTTOMRIGHT', -2, 2)
		b.hover = hover
		b:SetHighlightTexture(hover)
	end

	if (b.SetPushedTexture and not b.pushed) then
		local pushed = b:CreateTexture('Frame', '$parentPushedTexture', b)
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		pushed:SetPoint('TOPLEFT', 2, -2)
		pushed:SetPoint('BOTTOMRIGHT', -2, 2)
		b.pushed = pushed
		b:SetPushedTexture(pushed)
	end

	if (b.SetCheckedTexture and not b.checked) then
		local checked = b:CreateTexture('Frame', '$parentCheckedTexture', b)
		checked:SetTexture(0, 1, 0, 0.3)
		checked:SetPoint('TOPLEFT', 2, -2)
		checked:SetPoint('BOTTOMRIGHT', -2, 2)
		b.checked = checked
		b:SetCheckedTexture(checked)
	end

	local cooldown = b:GetName() and _G[b:GetName() .. 'Cooldown']

	if (cooldown) then
		cooldown:ClearAllPoints()
		cooldown:SetPoint('TOPLEFT', 2, -2)
		cooldown:SetPoint('BOTTOMRIGHT', -2, 2)
	end
end

local FontString = function(parent, name, file, size, flag)
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

local FadeIn = function(f)
	UIFrameFadeIn(f, 0.4, f:GetAlpha(), 1)
end

local FadeOut = function(f)
	UIFrameFadeOut(f, 0.8, f:GetAlpha(), 0)
end

local NewBackdrop = function(self)
	self:SetBackdropColor(A["MyColors"][4], A["MyColors"][5], A["MyColors"][6])
	self:SetBackdropBorderColor(A["MyColors"][1], A["MyColors"][2], A["MyColors"][3])
end

local OldBackdrop = function(self)
	self:Template()
end

local hovercolor = { unpack(A["MyColors"]) }

local Hover = function(self)
	self:SetBackdropColor(hovercolor[4], hovercolor[5], hovercolor[6])
	self:SetBackdropBorderColor(hovercolor[1], hovercolor[2], hovercolor[3])
end

--================================================================================================--
--	Skin API
--================================================================================================--
local function Skin(f)
	f:SetBackdrop({
		bgFile	= [=[Interface\Tooltips\UI-Tooltip-Background]=],
		edgeFile	= [=[Interface\BUTTONS\WHITE8X8]=],
		edgeSize	= 1,
		insets	= {left = 1, right = 1, top = 1, bottom = 1}})
  -- f:SetBackdropColor(.1, .1, .1, 1)
  -- f:SetBackdropBorderColor(.6, .6, .6, 1)
end

local function SkinButton(f, strip)
	local name = f:GetName()

	if (name) then
		if (_G[name .. "Left"])   then _G[name .. "Left"]:SetAlpha(0) end
		if (_G[name .. "Middle"]) then _G[name .. "Middle"]:SetAlpha(0) end
		if (_G[name .. "Right"])  then _G[name .. "Right"]:SetAlpha(0) end
	end

	if (f.Left) then f.Left:SetAlpha(0) end
	if (f.Right) then f.Right:SetAlpha(0) end
	if (f.Middle) then f.Middle:SetAlpha(0) end
	if (f.SetNormalTexture) then f:SetNormalTexture("") end
	if (f.SetHighlightTexture) then f:SetHighlightTexture("") end
	if (f.SetPushedTexture) then f:SetPushedTexture("") end
	if (f.SetDisabledTexture) then f:SetDisabledTexture("") end
	if (strip) then f:Strip() end

	f:Template()
	f:HookScript("OnEnter", Hover)			-- f:HookScript("OnEnter", function(self) Hover(self) end)	-- self:FadeIn() end)
	f:HookScript("OnLeave", Template)			-- f:HookScript("OnLeave", function(self) self:Template() end)	-- self:FadeOut() end)
end

local function SkinCheckBox(f)
	f:Strip()
	f:Backdrop()
	f:SetSize(18, 18)

	-- f.backdrop:SetPoint('TOPLEFT', 4, -4)
	-- f.backdrop:SetPoint('BOTTOMRIGHT', -4, 4)

	if (f.SetCheckedTexture) then
		f:SetCheckedTexture([=[Interface\Buttons\UI-CheckBox-Check]=])
	end

	if (f.SetDisabledCheckedTexture) then
		f:SetDisabledCheckedTexture([=[Interface\Buttons\UI-CheckBox-Check-Disabled]=])
	end

	f:HookScript('OnDisable', function(self)
		if (not self.SetDisabledTexture) then return end

		if (self:GetChecked()) then
			self:SetDisabledTexture([=[Interface\Buttons\UI-CheckBox-Check-Disabled]=])
		else
			self:SetDisabledTexture('')
		end
	end)

	f.SetNormalTexture = A["Dummy"]
	f.SetPushedTexture = A["Dummy"]
	f.SetHighlightTexture = A["Dummy"]
end

local function SkinCloseButton(f, point, text)
	if (point) then
		f:SetPoint("TOPRIGHT", point, "TOPRIGHT", -4, -4)
	else
		f:SetPoint("TOPRIGHT", -4, -4)
	end

	f:Strip()
	f:Template()							-- ("OVERLAY")
	f:SetSize(22, 22)						-- (18, 18)

	if (not f.text) then
		f.text = f:FontString(nil, Addon.default.pxfont[1], Addon.default.pxfont[2])
		f.text:SetPoint("CENTER", 1, 1)
		f.text:SetText(text or "X")
	end

	f:HookScript("OnEnter", Hover)
	f:HookScript("OnLeave", Template)
end

local function SkinEditBox(f)
	local name = f:GetName()

	if (_G[name .. 'Left'])   then Kill(_G[name .. 'Left']) end
	if (_G[name .. 'Middle']) then Kill(_G[name .. 'Middle']) end
	if (_G[name .. 'Right'])  then Kill(_G[name .. 'Right']) end
	if (_G[name .. 'Mid'])    then Kill(_G[name .. 'Mid']) end

	f:Backdrop()

	-- if (name and name:find('Silver') or name:find('Copper')) then
		-- f.backdrop:SetPoint('BOTTOMRIGHT', -12, -2)
	-- end
end

--

local function SkinPrevNextButton(b, horizontal)
	local normal, pushed, disabled
	local isPrevButton = b:GetName() and (string.find(b:GetName(), "Left") or string.find(b:GetName(), "Prev") or string.find(b:GetName(), "Decrement") or string.find(b:GetName(), "Back"))

	if (b:GetNormalTexture()) then
		normal = b:GetNormalTexture():GetTexture()
	end

	if (b:GetPushedTexture()) then
		pushed = b:GetPushedTexture():GetTexture()
	end

	if (b:GetDisabledTexture()) then
		disabled = b:GetDisabledTexture():GetTexture()
	end

	b:Strip()

	if (not normal and isPrevButton) then
		normal = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up"
	elseif (not normal) then
		normal = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"
	end

	if (not pushed and isPrevButton) then
		pushed = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down"
	elseif (not pushed) then
		pushed = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down"
	end

	if (not disabled and isPrevButton) then
		disabled = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled"
	elseif (not disabled) then
		disabled = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled"
	end

	b:SetNormalTexture(normal)
	b:SetPushedTexture(pushed)
	b:SetDisabledTexture(disabled)
	b:Template() -- ("OVERLAY")
	b:SetSize(18, 18)
	-- b:SetSize(b:GetWidth() - 7, b:GetHeight() - 7)
  -- b:SetSize(b:GetWidth() - 7, b:GetHeight() - 7)

	if (normal and pushed and disabled) then
		if (horizontal) then
			b:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			b:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			b:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")

			b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)

			if (b:GetPushedTexture()) then
				b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
			end

			if (b:GetDisabledTexture()) then
				b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
			end

		else
			b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)

			if (b:GetPushedTexture()) then
				b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
			end

			if (b:GetDisabledTexture()) then
				b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
			end
		end

		b:GetNormalTexture():ClearAllPoints()
		b:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		b:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)

		if (b:GetDisabledTexture()) then
			b:GetDisabledTexture():SetAllPoints(b:GetNormalTexture())
		end

		if (b:GetPushedTexture()) then
			b:GetPushedTexture():SetAllPoints(b:GetNormalTexture())
		end

		b:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
		b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
	end
end

local function SkinDropDownBox(f, width)												-- if (not width) then width = 155 end
	local name = f:GetName()
	local text = _G[name .. 'Text']
	local button = _G[name .. 'Button']
	local width = width or 155

	f:Strip()
	f:SetWidth(width)

	text:ClearAllPoints()
	text:SetPoint('RIGHT', button, 'LEFT', -10, 0)	-- -2, 0)

	button:ClearAllPoints()
	button:SetPoint('RIGHT', f, 0, 0)							-- -10, 3)
	button.SetPoint = A["Dummy"]
	button:SkinPrevNextButton(true)

	f:Backdrop()
	f.backdrop:SetPoint('TOPLEFT', 0, 0)						-- 20, -2)
	f.backdrop:SetPoint('BOTTOMRIGHT', button, 0, 0)				--  2, -2)
end

local function SkinRotateButton(b)
	b:Template()
	b:Size(b:GetWidth() - 14, b:GetHeight() - 14)

	b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	b:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	b:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	b:GetNormalTexture():ClearAllPoints()

	b:GetNormalTexture():SetPoint('TOPLEFT', 2, -2)
	b:GetNormalTexture():SetPoint('BOTTOMRIGHT', -2, 2)

	b:GetPushedTexture():SetAllPoints(b:GetNormalTexture())
	b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
end

local function SkinScrollBar(f)
	local name = f:GetName()
	local upbutton = _G[name .. 'ScrollUpButton']
	local downbutton = _G[name .. 'ScrollDownButton']


	if (_G[name .. 'BG'])     then _G[name .. 'BG']:SetTexture(nil) end
	if (_G[name .. 'Track'])  then _G[name .. 'Track']:SetTexture(nil) end
	if (_G[name .. 'Top'])    then _G[name .. 'Top']:SetTexture(nil) end
	if (_G[name .. 'Bottom']) then _G[name .. 'Bottom']:SetTexture(nil) end
	if (_G[name .. 'Middle']) then _G[name .. 'Middle']:SetTexture(nil) end

	if (upbutton and downbutton) then
		upbutton:Strip()
		upbutton:Template('DEFAULT', true)

		if (not upbutton.texture) then
			upbutton.texture = upbutton:CreateTexture(nil, 'OVERLAY')
			upbutton.texture:SetPoint('TOPLEFT', 2, -2)
			upbutton.texture:SetPoint('BOTTOMRIGHT', -2, 2)
			upbutton.texture:SetTexture("Interface\\AddOns\\Truth\\media\\textures\\arrowup.tga")
			upbutton.texture:SetVertexColor(unpack(Addon.default.border.color))
		end

		downbutton:Strip()
		downbutton:Template()

		if (not downbutton.texture) then
			downbutton.texture = downbutton:CreateTexture(nil, 'OVERLAY')
			downbutton.texture:SetPoint('TOPLEFT', 2, -2)
			downbutton.texture:SetPoint('BOTTOMRIGHT', -2, 2)
			downbutton.texture:SetTexture("Interface\\AddOns\\Truth\\media\\textures\\arrowdown.tga")
			downbutton.texture:SetVertexColor(unpack(Addon.default.border.color))
		end

		if (not f.trackbg) then
			f.trackbg = CreateFrame('Frame', nil, f)
			f.trackbg:SetPoint('TOPLEFT', upbutton, 'BOTTOMLEFT', 0, -1)
			f.trackbg:SetPoint('BOTTOMRIGHT', downbutton, 'TOPRIGHT', 0, 1)
			f.trackbg:Template('TRANSPARENT')
		end


		if (f:GetThumbTexture()) then
			f.thumbTrim = f.thumbTrim or 3
			-- if (not f.thumbTrim) then		-- local thumbTrim = thumbTrim or 3
				-- f.thumbTrim = 3
			-- end

			f:GetThumbTexture():SetTexture(nil)

			if (not f.thumbbg) then
				f.thumbbg = CreateFrame('Frame', nil, f)
				f.thumbbg:SetPoint('TOPLEFT', f:GetThumbTexture(), 2, -f.thumbTrim)
				f.thumbbg:SetPoint('BOTTOMRIGHT', f:GetThumbTexture(), -2, f.thumbTrim)
				f.thumbbg:Template('DEFAULT', true)

				if (f.trackbg) then
					f.thumbbg:SetFrameLevel(f.trackbg:GetFrameLevel())
				end
			end
		end
	end
end

local function SkinSlider(f)
	f:SetBackdrop(nil)

	local backdrop = CreateFrame("Frame", nil, f)
	backdrop:Template("OVERLAY")
	backdrop:SetPoint("TOPLEFT", 14, -2)
	backdrop:SetPoint("BOTTOMRIGHT", -15, 3)
	backdrop:SetFrameLevel(f:GetFrameLevel() - 1)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

local function SkinTab(tab, bg)
	if (not tab) then return end

	local Tabs = {
		"LeftDisabled",
		"MiddleDisabled",
		"RightDisabled",
		"Left",
		"Middle",
		"Right",
	}

	for _, obj in pairs(Tabs) do
		local texture = _G[tab:GetName() .. obj]
		if (texture) then
			texture:SetTexture(nil)
		end
	end

	if (tab.GetHighlightTexture and tab:GetHighlightTexture()) then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:Strip()
	end

	tab.backdrop = CreateFrame("Frame", "$parentBackdrop", tab)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Template()
	tab.backdrop:SetPoint("TOPLEFT", 10, -3)
	tab.backdrop:SetPoint("BOTTOMRIGHT", -10, 3)
end



--================================================================================================--
--							 Injection
--================================================================================================--
local function addapi(O)
	local mt = getmetatable(O).__index

	-- Utils
	if (not O.Kill) then mt.Kill = Kill end
	if (not O.Strip) then mt.Strip = Strip end

	-- Pixel API
	if (not O.scale) then mt.scale = scale end
	if (not O.Scale) then mt.Scale = Scale end
	if (not O.Size) then mt.Size = Size end
	if (not O.Width) then mt.Width = Width end
	if (not O.Height) then mt.Height = Height end
	if (not O.Point) then mt.Point = Point end
	if (not O.SetInside) then  mt.SetInside = SetInside end
	if (not O.SetOutside) then  mt.SetOutside = SetOutside end

	-- Frame API
	if (not O.Colorize) then mt.Colorize = Colorize end
	if (not O.Overlay) then mt.Overlay = Overlay end
	if (not O.Border) then mt.Border = Border end
	if (not O.Template) then mt.Template = Template end
	if (not O.Backdrop) then mt.Backdrop = Backdrop end
	if (not O.Shadow) then mt.Shadow = Shadow end

	if (not O.NewBackdrop) then mt.NewBackdrop = NewBackdrop end
	if (not O.OldBackdrop) then mt.OldBackdrop = OldBackdrop end

	if (not O.FadeIn) then mt.FadeIn = FadeIn end
	if (not O.FadeOut) then mt.FadeOut = FadeOut end

	-- Object API
	if (not O.MakeMovable) then mt.MakeMovable = MakeMovable end

	-- Accessory Functions
	if (not O.StyleButton) then mt.StyleButton = StyleButton end
	if (not O.FontString) then mt.FontString = FontString end

	-- Skin API
	if (not O.Skin) then mt.Skin = Skin end
	if (not O.SkinButton) then mt.SkinButton = SkinButton end
	if (not O.SkinCheckBox) then mt.SkinCheckBox = SkinCheckBox end
	if (not O.SkinCloseButton) then mt.SkinCloseButton = SkinCloseButton end
	if (not O.SkinDropDownBox) then mt.SkinDropDownBox = SkinDropDownBox end
	if (not O.SkinEditBox) then mt.SkinEditBox = SkinEditBox end
	--
	if (not O.SkinPrevNextButton) then mt.SkinPrevNextButton = SkinPrevNextButton end
	if (not O.SkinRotateButton) then mt.SkinRotateButton = SkinRotateButton end
	if (not O.SkinScrollBar) then mt.SkinScrollBar = SkinScrollBar end
	if (not O.SkinSlider) then mt.SkinSlider = SkinSlider end
	if (not O.SkinTab) then mt.SkinTab = SkinTab end
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
end

-- O.Skin
-- O.SkinButton
-- O.SkinCheckBox
-- O.SkinCloseButton
-- O.SkinDropDownBox
-- O.SkinEditBox
--
-- O.SkinPrevNextButton
-- O.SkinRotateButton
-- O.SkinScrollBar
-- O.SkinSlider
-- O.SkinTab


-- T.Colorize 				= Colorize
-- T.Overlay				= Overlay
-- T.Border				= Border
-- T.Template				= Template
-- T.Backdrop 				= Backdrop
-- T.Shadow				= Shadow
-- T.StyleButton 			= StyleButton

-- T.SetModifiedBackdrop 	= SetModifiedBackdrop
-- T.SetOriginalBackdrop 	= SetOriginalBackdrop

-- T.SkinButton 			= SkinButton
-- T.SkinCheckBox 			= SkinCheckBox
-- T.SkinCloseButton 		= SkinCloseButton
-- T.SkinDropDownBox 		= SkinDropDownBox
-- T.SkinEditBox 			= SkinEditBox
-- T.SkinPrevNextButton 		= SkinPrevNextButton
-- T.SkinRotateButton 		= SkinRotateButton
-- T.SkinScrollBar 			= SkinScrollBar
-- T.SkinSlider 			= SkinSlider
-- T.SkinTab 				= SkinTab



--==============================================--
--	Backup
--==============================================--
--[[ local function SkinSlider_WORKING_VERSION(f, height, movetext)
	local name = f:GetName()

	f:Template()
	f:SetBackdropColor(0, 0, 0, .8)

	if (not height) then
		height = f:GetHeight()
	end

	if (movetext) then
		if(_G[name .. 'Low'])  then _G[name .. 'Low']:SetPoint('BOTTOM', 0, -18) end
		if(_G[name .. 'High']) then _G[name .. 'High']:SetPoint('BOTTOM', 0, -18) end
		if(_G[name .. 'Text']) then _G[name .. 'Text']:SetPoint('TOP', 0, 19) end
	end

	f:SetThumbTexture(Addon.default.backdrop.texture)
	f:GetThumbTexture():SetVertexColor(unpack(Addon.default.border.color))
	-- _G[name]:SetThumbTexture(Addon.default.backdrop.texture)
	-- _G[name]:GetThumbTexture():SetVertexColor(unpack(Addon.default.border.color))

	if (f:GetWidth() < f:GetHeight()) then
		f:SetWidth(height)
		f:GetThumbTexture():Size(f:GetWidth(), f:GetWidth() + 4)
	  -- _G[name]:GetThumbTexture():Size(f:GetWidth(), f:GetWidth() + 4)
	else
		f:SetHeight(height)
		f:GetThumbTexture():Size(height + 4, height)
	  -- _G[name]:GetThumbTexture():Size(height + 4, height)
	end
end
--]]

--[[ local function SkinPrevNextButton_TUKUI(b, horizonal)
	b:Template()							-- ('DEFAULT')
	b:Size(b:GetWidth() - 7, b:GetHeight() - 7)

	if (horizonal) then
		b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
	else
		b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)

		if (b:GetPushedTexture()) then
			b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end

		if (b:GetDisabledTexture()) then
			b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end

	b:GetNormalTexture():ClearAllPoints()
	b:GetNormalTexture():SetPoint('TOPLEFT', 2, -2)
	b:GetNormalTexture():SetPoint('BOTTOMRIGHT', -2, 2)

	if (b:GetDisabledTexture()) then
		b:GetDisabledTexture():SetAllPoints(b:GetNormalTexture())
	end

	if (b:GetPushedTexture()) then
		b:GetPushedTexture():SetAllPoints(b:GetNormalTexture())
	end

	b:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
end
--]]

--[[ local function SkinCloseButton(f, point)
		if (point) then
			f:SetPoint('TOPRIGHT', point, 'TOPRIGHT', 2, 2)
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
--]]

