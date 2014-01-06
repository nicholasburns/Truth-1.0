

if (not false) then return end


local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Debug"]["Dump"]["Enable"]) then return end
local print = function(...) Addon.print('dump', ...) end
local select, unpack	= select, unpack
local CreateFrame = CreateFrame
local UIParent = UIParent
local ChatFontNormal = ChatFontNormal
local ChatFrame1EditBox = ChatFrame1EditBox



-- Constant
local inset = 10
local pad = 10

-- Properties
local dumpframe = nil
local editbox   = nil

-- Datatable
local lines = {}



-- Window
local f = CreateFrame('Frame', 'TruthDumpFrame', ChatFrame1)
f:SetScale(1)
f:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 10, -100)
f:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'TOPRIGHT', -3, 10)
f:SetBackdrop(Addon.template.backdrop)
f:SetBackdropColor(unpack(Addon.default.backdrop.color))
f:SetBackdropBorderColor(unpack(Addon.default.border.color))
f:SetFrameStrata('BACKGROUND')
f:Hide()

-- Scroll
f.scroll = CreateFrame('ScrollFrame', '$parentScrollFrame', f, 'UIPanelScrollFrameTemplate')
f.scroll:SetPoint('TOPLEFT', f, 8, -30)
f.scroll:SetPoint('BOTTOMRIGHT', f, -30, 8)

-- EditBox
f.textArea = CreateFrame("EditBox", '$parentEditBox', f.scroll)
f.textArea:SetAutoFocus(false)
f.textArea:SetMultiLine(true)
f.textArea:SetFontObject(GameFontHighlightSmall)
f.textArea:SetMaxLetters(99999)
f.textArea:EnableMouse(true)
f.textArea:SetScript("OnEscapePressed", f.textArea.ClearFocus)
f.textArea:SetWidth(450)						-- XXX why the fuck doesn't SetPoint work on the editbox?

-- Scroll Child
f.scroll:SetScrollChild(f.textArea)
-- f.scroll:SetScrollChild(editbox)

-- Toggle
f.toggle = CreateFrame('Button', '$parentToggleButton', UIParent)-- , UIPanelButtonTemplate)									-- f.toggle = CreateFrame('Button', '$parentToggleButton', f, 'UIPanelCloseButton')
f.toggle:SetPoint('BOTTOMLEFT', f, 'BOTTOMRIGHT', 10, 0)
f.toggle:SetSize(30, 30)
f.toggle:SetNormalTexture(C["Debug"]["Dump"]["ButtonNormal"])													-- f.toggle:SetNormalTexture([=[Interface\BUTTONS\UI-GuildButton-PublicNote-Disabled]=])
f.toggle:SetHighlightTexture(C["Debug"]["Dump"]["ButtonHighlight"])												-- f.toggle:SetHighlightTexture([=[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]=])
f.toggle:GetHighlightTexture():SetAllPoints(f.toggle:GetNormalTexture())
f.toggle:Show()
f.toggle:SetScript('OnMouseUp', function(self)
	if (TruthDumpFrame:IsShown()) then
		TruthDumpFrame:Hide()

		self:Show()
	else
		TruthDumpFrame:Show()
	end
end)

-- f.toggle:HookScript("OnHide", function(self)
	-- self:Show()
	-- print('HookScript', 'OnHide')
-- end)




-- f.toggle = CreateFrame('Button', '$parentToggleButton', f)													-- f.toggle = CreateFrame('Button', '$parentToggleButton', f, 'UIPanelCloseButton')
-- f.toggle:SetPoint('BOTTOMLEFT', f, 'BOTTOMRIGHT', 10, 0)
-- f.toggle:SetSize(20, 20)
-- f.toggle:SetNormalTexture(C["Debug"]["Dump"]["ButtonNormal"])
-- f.toggle:GetNormalTexture():SetSize(20, 20)
-- f.toggle:SetHighlightTexture(C["Debug"]["Dump"]["ButtonHighlight"])
-- f.toggle:GetHighlightTexture():SetAllPoints(f.toggle:GetNormalTexture())
-- f.toggle:Show()
-- f.toggle:SetScript('OnMouseUp', function(self)
	-- if (TruthDumpFrame:IsShown()) then
		-- TruthDumpFrame:Hide()
		-- return
	-- end
	-- TruthDumpFrame:Show()
-- end)


-- local editbox = CreateFrame('EditBox', '$parentEditBox', f)
-- editbox:SetSize(f:GetWidth() - pad, f:GetHeight() - pad)
-- editbox:SetFontObject(ChatFontNormal)
-- editbox:SetFont(unpack(C["Debug"]["Dump"]["Font"]))

-- editbox:SetAutoFocus(false)
-- editbox:EnableMouse(true)
-- editbox:SetMultiLine(true)
-- editbox:SetMaxLetters(99999)


