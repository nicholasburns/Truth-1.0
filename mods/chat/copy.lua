local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Copy"]["Enable"]) then return end
local print = function(...) Addon.print('copy', ...) end

local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']
local I  =  P[1]

local select, unpack	= select, unpack
local gsub, tostring	= string.gsub, tostring
local table, concat		= table, table.concat
local CreateFrame		= CreateFrame
local GetText			= GetText
local UIParent			= UIParent
local ChatFontNormal	= ChatFontNormal
local ChatFrame1EditBox	= ChatFrame1EditBox


-- Properties
local lines 	= {}
local frame	= nil
local editBox	= nil
local isCopyFrameCreated = nil


--==============================================--
--	Create the CopyFrame
--==============================================--
local function CreateCopyFrame()

	frame = CreateFrame('Frame', 'TruthChatCopy', UIParent)
	frame:SetScale(1)
	frame:SetHeight(500 * I)
	frame:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 3, 10)
	frame:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'TOPRIGHT', -3, 10)
	frame:SetBackdrop({
		bgFile   = Addon.default.backdrop.texture,
		edgeFile = Addon.default.border.texture,
		edgeSize = I,
		insets   = {left = I, right = -I, top = -I, bottom = -I}})
	frame:SetBackdropColor(unpack(Addon.default.backdrop.color))
	frame:SetBackdropBorderColor(unpack(Addon.default.border.color))
	frame:Hide()
	frame:SetFrameStrata('DIALOG')

	local scrollArea = CreateFrame('ScrollFrame', '$parentScrollFrame', frame, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint('TOPLEFT', frame, 8, -30)
	scrollArea:SetPoint('BOTTOMRIGHT', frame, -30, 8)

	editBox = CreateFrame('EditBox', '$parentEditBox', frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetSize(450, 270)
	editBox:SetScript('OnEscapePressed', function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame('Button', '$parentCloseButton', frame, 'UIPanelCloseButton')
	close:SetPoint('TOPRIGHT', frame, 'TOPRIGHT')

	isCopyFrameCreated = true
end


local function GetLines(...)
	local count = 1

	for i = select('#', ...), 1, -1 do
		local region = select(i, ...)

		if (region:GetObjectType() == 'FontString') then
			lines[count] = tostring(region:GetText())
			count = count + 1
		end
	end

	return count - 1
end


local function Copy(cf)
	local numLines = GetLines(cf:GetRegions())
	local text = concat(lines, '\n', 1, numLines)

	if (not isCopyFrameCreated) then
		CreateCopyFrame()
	end

	if (frame:IsShown()) then
		frame:Hide() return
	end
	frame:Show()

	editBox:SetFont(C["Chat"]["Font"][1], C["Chat"]["Font"][2], C["Chat"]["Font"][3])
	editBox:SetText(text)
end



for i = 1, (C["Chat"]["Windows"]) do
	local f = _G["ChatFrame" .. i]
	local b = CreateFrame('Button', nil, f)												-- CreateFrame('Button', format('TruthButtonCF%d', i), cf)

	b:SetSize(20, 20)
	b:SetPoint('TOPRIGHT', 0, 0)
  -- b:SetAlpha(0)
	b:SetNormalTexture(C["Chat"]["Copy"]["ButtonNormal"])
	b:GetNormalTexture():SetSize(20, 20)
	b:SetHighlightTexture(C["Chat"]["Copy"]["ButtonHighlight"])
	b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
	b:Show()
	b:SetScript('OnMouseUp', function(self)
		Copy(f)
	end)
end


-- Fix for RealID text copy/paste (real name bug)
for i = 1, (C["Chat"]["Windows"]) do													-- local editbox = _G['ChatFrame' .. i .. 'EditBox']
	_G['ChatFrame'.. i ..'EditBox']:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		local new, found = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)k:%s', '%2 %3: ")

		if (found > 0) then
			new = new:gsub("|", "")
			self:SetText(new)
		end
	end)
end
