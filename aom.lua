local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["AOM"]["Enable"]) then return end								-- if (not C.aom.enable) then return end
local print = function(...) Addon.print('AOM', ...) end
if (IsAddOnLoaded('AOM')) then
	print('AOM detected (as standalone)', 'Truth version of AOM aborted') return
end

local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']
local X  = _G[AddOn]['pixel']['px']


local _G = _G
local sort, tinsert, strmatch, tonumber = table.sort, table.insert, string.match, tonumber

--==============================================--
--	Addon Frame
--==============================================--
local aom = CreateFrame('Frame', 'AOM', UIParent)
aom:Size(400, 800)
aom:SetPoint('CENTER')
aom:SetFrameStrata('FULLSCREEN_DIALOG')

-- Title
local title = aom:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
title:SetPoint('TOPLEFT', 10, -10)
title:SetPoint('TOPRIGHT', -28, -30)
title:SetJustifyH('CENTER')
title:SetText('ADDON MANAGER <AOM>')

-- Scroll Area
local scroll = CreateFrame('ScrollFrame', '$parentScrollFrame', aom, 'UIPanelScrollFrameTemplate')
scroll:SetPoint('TOPLEFT', aom, 10, -30)
scroll:SetPoint('BOTTOMRIGHT', aom, -28, 40)

-- Scroll Child
local scrollchild = CreateFrame('Frame', '$parentChild', scroll)
scroll:SetScrollChild(scrollchild)

-- Resize Button
local resize = CreateFrame('Button', '$parentResizeButton', aom)
resize:SetPoint('BOTTOMRIGHT', aom, -5, 5) 		--('BOTTOMRIGHT', aom, 0, 0)
resize:Size(16, 16)
resize:SetNormalTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]=])
resize:SetPushedTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]=])
resize:SetHighlightTexture([=[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]=])
resize:SetScript('OnMouseDown', function(self) aom:StartSizing() end)
resize:SetScript('OnMouseUp',   function(self) aom:StopMovingOrSizing() end)

-- Reload Button
local reload = Button('Reload', aom)
reload:Size(150, 22)
reload:SetPoint('BOTTOM', 0, 10)
reload:SetScript('OnClick', function() ReloadUI() end)

-- Close Button
local close = CreateFrame('Button', '$parentCloseButton', aom, 'UIPanelCloseButton')
close:SetPoint('TOPRIGHT', 4, 0)
close:SetScript('OnClick', function() aom:Hide() end)

-- Escape Key
tinsert(UISpecialFrames, 'AOM')
aom:Hide()
aom:SetScript('OnHide', function(self) ShowUIPanel(GameMenuFrame) end)

-- Movable
aom:SetMovable(true)
aom:EnableMouse(true)
aom:SetUserPlaced(true)
aom:SetClampedToScreen(true)
aom:SetScript('OnMouseUp',   function(self) self:StopMovingOrSizing() end)
aom:SetScript('OnMouseDown', function(self) self:StartMoving() end)

-- Resizable
aom:SetResizable(true)
aom:SetMinResize(200, 400)
aom:SetMaxResize(A["ScreenWidth"], A["ScreenHeight"]) 										-- (A["ScreenWidth"] * 0.8, A["ScreenHeight"] * 0.8)

-- Skin
aom:Skin()																		-- Skin(aom)


--==============================================--
--	Addons List
--==============================================--
do
	-- ScrollFrame
	scroll:Skin()																	-- Skin(scroll)
	scroll:SetBackdropColor(unpack(Addon.default.backdrop.colorAlt))

	-- ScrollChild
	local self = scrollchild
	self:SetPoint('TOPLEFT')
	self:Size(scroll:GetWidth(), scroll:GetHeight())										-- self:SetSize(scroll:GetWidth() * X, scroll:GetHeight() * X)

	-- AddonList
	self.addons = {}
	for i = 1, (GetNumAddOns()) do
		self.addons[i] = select(1, GetAddOnInfo(i))
	end
	sort(self.addons)

	-- Addon List Builder
	local prevCheckButton
	for i, v in pairs(self.addons) do

		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)

		if (name) then

			-- CheckButton
			local f = _G[v .. 'CheckButton'] or CreateFrame('CheckButton', v .. 'CheckButton', self, 'OptionsCheckButtonTemplate')
			f:EnableMouse(true)
			f:SetChecked(enabled)

		   --[[	+--------------+
				|   f.string   |
				+--------------+------------------------+
				|	TipTac						|
				|	Tooltip Enhancement Addon		|
				|	Dependencies: Truth				|
				+---------------------------------------+
		   --]]

			-- Tooltip Elements
			local AddonTitle, AddonNotes, AddonDeps

			AddonTitle = title and (title .. '|r')
			AddonNotes = notes and ('|n|cffFFFFFF'.. notes ..'|r') or '|n|n|cffFF4400[Notes do not exist for this Addon.]|r|n'
			AddonDeps  = ''

			if (GetAddOnDependencies(v)) then
				for i = 1, select('#', GetAddOnDependencies(v)) do
					if (i == 1) then
						AddonDeps = '|n|n|cffFF4400Dependencies: ' .. select(i, GetAddOnDependencies(v))
					else
						AddonDeps =  AddonDeps .. ', ' .. select(i, GetAddOnDependencies(v))
					end

				end
			end

			f.string = AddonTitle .. AddonNotes .. AddonDeps .. '|r'

			-- Style
			if (i == 1) then
				f:SetPoint('TOPLEFT', self, 10, -10)
			else
				f:SetPoint('TOP', prevCheckButton, 'BOTTOM', 0, 2)
			end

			f:SetBackdrop({bgFile = Addon.default.backdrop.textureAlt}) 					-- f:SetBackdrop({bgFile = [=[Interface\Buttons\WHITE8x8]=]})
			f:SetBackdropColor(unpack(Addon.default.backdrop.colorAlt)) 					-- f:SetBackdropColor(.2, .2, .2, 1)
			f:SetScript('OnEnter', function(self)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, ANCHOR_TOPRIGHT)
				GameTooltip:AddLine(self.string)										--(self.title)
				GameTooltip:Show()
			end)
			f:SetScript('OnLeave', function(self)
				GameTooltip:Hide()
			end)
			f:SetScript('OnClick', function()
				local _, _, _, enabled = GetAddOnInfo(name)

				if (enabled) then
					PlaySound('gsLoginChangeRealmCancel', 'Master')
					DisableAddOn(name)
				else
					PlaySound('igMainMenuOptionCheckBoxOn', 'Master')
					EnableAddOn(name)
				end
			end)

			-- SetText
			_G[v .. 'CheckButtonText']:SetText(title)

			prevCheckButton = f
		end
	end
end


--==============================================--
--	GameMenu Button
--==============================================--
local show = CreateFrame('Button', 'AOM-GameMenuButton', GameMenuFrame, 'GameMenuButtonTemplate')
show:SetText(ADDONS)

show:SetSize(show:GetWidth() + 50, show:GetHeight() + 10)
show:SetPoint('BOTTOM', GameMenuFrame, 'TOP', 0, 15)

show:SetScript('OnClick', function()
	PlaySound('igMainMenuOptionCheckBoxOn', 'Master')
	HideUIPanel(GameMenuFrame)

	aom:Show()
end)

--==============================================--
--	Slashes
--==============================================--
SlashCmdList["AOM"] = function()
	aom:Show()
end
_G["SLASH_AOM1"] = '/aom'




--==============================================--
--	Backup
--==============================================--
--[[ show:SetScript('OnClick', function()
	  -- willplay [flag]:  returns true if the sound will be played nil otherwise
		local willplay = PlaySound('igMainMenuOption', 'Master')
	  -- Error Message: only displays if the sound will not be played (mostly for sound typos)
		if (not willplay) then
			print('<aom> AOMGameMenuButton: Sound returned nil')
		end
		HideUIPanel(GameMenuFrame)
		aom:Show()
	end)
--]]

--[[ local function Skin(f)
		f:SetBackdrop({
			bgFile   = Addon.default.backdrop.texture,
			edgeFile = Addon.default.border.texture,
			edgeSize = X,
			insets   = {left = X, right = -X, top = -X, bottom = X}})
		f:SetBackdropColor(unpack(Addon.default.backdrop.color))
		f:SetBackdropBorderColor(unpack(Addon.default.border.color))
	end
--]]
