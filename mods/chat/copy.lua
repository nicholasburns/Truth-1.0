local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Copy"]["Enable"]) then return end
local print = function(...) Addon.print('chat.copy', ...) end
local X = A["PixelSize"]
local select, unpack	= select, unpack
local gsub, tostring	= string.gsub, tostring
local table, concat = table, table.concat
local CreateFrame = CreateFrame
local GetText = GetText
local UIParent = UIParent
local ChatFontNormal = ChatFontNormal
local ChatFrame1EditBox = ChatFrame1EditBox


-- Properties
local lines 	= {}
local frame	= nil
local editbox	= nil
local isCopyFrameCreated = nil


--==============================================--
--	Create the CopyFrame
--==============================================--
local function CreateCopyFrame()
	frame = CreateFrame('Frame', 'TruthChatCopy', UIParent)
	frame:SetScale(1)
	frame:SetHeight(700 * X)
	frame:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 3, 10)
	frame:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'TOPRIGHT', -3, 10)
	frame:SetBackdrop({
		bgFile   = Addon.default.backdrop.texture,
		edgeFile = Addon.default.border.texture,
		edgeSize = X,
		insets   = {left = X, right = -X, top = -X, bottom = -X}})
	frame:SetBackdropColor(unpack(Addon.default.backdrop.color))
	frame:SetBackdropBorderColor(unpack(Addon.default.border.color))
	frame:Hide()
	frame:SetFrameStrata('DIALOG')

	-- Respond to Escape Button
	tinsert(UISpecialFrames, 'TruthChatCopy')

	local scroll = CreateFrame('ScrollFrame', '$parentScrollFrame', frame, 'UIPanelScrollFrameTemplate')
	scroll:SetPoint('TOPLEFT', frame, 8, -30)
	scroll:SetPoint('BOTTOMRIGHT', frame, -30, 8)

	editbox = CreateFrame('EditBox', '$parentEditBox', frame)
	editbox:SetMultiLine(true)
	editbox:SetMaxLetters(99999)
	editbox:EnableMouse(true)
	editbox:SetAutoFocus(false)
	editbox:SetFontObject(ChatFontNormal)
	editbox:SetSize(450, 270)
	editbox:SetScript('OnEscapePressed', function() frame:Hide() end)

	scroll:SetScrollChild(editbox)

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

	editbox:SetFont(C["Chat"]["Font"][1], C["Chat"]["Font"][2], C["Chat"]["Font"][3])
	editbox:SetText(text)
end



-- Copy Button
for i = 1, (C["Chat"]["Windows"]) do
	local f = _G["ChatFrame" .. i]

	local b = CreateFrame('Button', "$parentCopyButton", f)								-- local b = CreateFrame('Button', nil, f)
	b:SetSize(20, 20)
	b:SetPoint('TOPRIGHT', 0, 0)

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
--[[
for i = 1, (C["Chat"]["Windows"]) do													-- local editbox = _G['ChatFrame' .. i .. 'EditBox']
	_G['ChatFrame'.. i ..'EditBox']:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		local new, found = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)k:%s', '%2 %3: ")

		if (found > 0) then
			new = gsub(new, "|", "")
			self:SetText(new)
		end
	end)
end
--]]
