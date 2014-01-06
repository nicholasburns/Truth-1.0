-- Credit: Gibberish (p3lim)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Tab"]["Enable"]) then return end
local print = function(...) Addon.print('chat.tabs', ...) end
local P = A["PixelSizer"]
local X = A["PixelSize"]






local function UpdateColors(self)
	if (self:IsMouseOver()) then
		self:GetFontString():SetTextColor(0, 2/3, 1)
	elseif (self.alerting) then
		self:GetFontString():SetTextColor(1, 0, 0)
	elseif (self:GetID() == SELECTED_CHAT_FRAME:GetID()) then
		self:GetFontString():SetTextColor(1, 1, 1)
	else
		self:GetFontString():SetTextColor(1/2, 1/2, 1/2)
	end
end

local function Parse(self)
	UpdateColors(_G[self:GetName() .. "Tab"])
end

--==============================================--
--	Events
--==============================================--
local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')		-- f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function()

	for index = 1, (C["Chat"]["Windows"]) do
		local tab = _G["ChatFrame".. index .."Tab"]

		tab:GetFontString():SetFont(unpack(C["Chat"]["Tab"]["Font"]))
		tab:GetFontString():SetShadowOffset(C["Chat"]["Tab"]["Font"][4] or 1, C["Chat"]["Tab"]["Font"][4] or -1)
	  -- tab:GetFontString():SetFont(C.chat.tab.font.file, C.chat.tab.font.size, C.chat.tab.font.flag)
	  -- tab:GetFontString():SetShadowOffset(C.chat.tab.font.shad or 1, C.chat.tab.font.shad or -1)

		tab.leftTexture:SetTexture(nil)
		tab.middleTexture:SetTexture(nil)
		tab.rightTexture:SetTexture(nil)

		tab.leftHighlightTexture:SetTexture(nil)
		tab.middleHighlightTexture:SetTexture(nil)
		tab.rightHighlightTexture:SetTexture(nil)

		tab.leftSelectedTexture:SetTexture(nil)
		tab.middleSelectedTexture:SetTexture(nil)
		tab.rightSelectedTexture:SetTexture(nil)

		tab.glow:SetTexture(nil)
		tab:SetAlpha(0)

		tab:HookScript('OnEnter', UpdateColors)
		tab:HookScript('OnLeave', UpdateColors)

		UpdateColors(tab)
	end

	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0.8
	CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.8

	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1
  -- CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1

  -- CHAT_FRAME_FADE_TIME = 0
  -- CHAT_FRAME_FADE_OUT_TIME = 0

	hooksecurefunc('FCFTab_UpdateColors', UpdateColors)
	hooksecurefunc('FCF_StartAlertFlash', Parse)
	hooksecurefunc('FCF_FadeOutChatFrame', Parse)
end)
