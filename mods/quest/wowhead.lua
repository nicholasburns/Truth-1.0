local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Quest"]["Wowhead"]["Enable"]) then return end


--================================================================================================--

--	Wowhead Quest Links

--================================================================================================--
local L_WATCH_WOWHEAD_LINK = 'Wowhead link'

local linkQuest = 'http://www.wowhead.com/quest=%d'
local linkAchievement = 'http://www.wowhead.com/achievement=%d'


StaticPopupDialogs['WATCHFRAME_URL'] = {
	text = L_WATCH_WOWHEAD_LINK,
	button1 = OKAY,

	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 350,

	OnShow = function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed  = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,

  -- preferredIndex = 5,
	preferredIndex = STATICPOPUPS_NUMDIALOGS,
}


local tblDropDown = {}
hooksecurefunc('WatchFrameDropDown_Initialize', function(self)

	if (self.type == 'QUEST') then

		tblDropDown = {
			text = L_WATCH_WOWHEAD_LINK,
			notCheckable = true,
			arg1 = self.index,
			func = function(_, watchId)
				local logId = GetQuestIndexForWatch(watchId)
				local _, _, _, _, _, _, _, _, questId = GetQuestLogTitle(logId)
				local inputBox = StaticPopup_Show('WATCHFRAME_URL')

				inputBox.editBox:SetText(linkQuest:format(questId))
				inputBox.editBox:HighlightText()
			end
		}

		UIDropDownMenu_AddButton(tblDropDown, UIDROPDOWN_MENU_LEVEL)

	elseif (self.type == 'ACHIEVEMENT') then

		tblDropDown = {
			text = L_WATCH_WOWHEAD_LINK,
			notCheckable = true,
			arg1 = self.index,
			func = function(_, id)
				local inputBox = StaticPopup_Show('WATCHFRAME_URL')

				inputBox.editBox:SetText(linkAchievement:format(id))
				inputBox.editBox:HighlightText()
			end
		}

		UIDropDownMenu_AddButton(tblDropDown, UIDROPDOWN_MENU_LEVEL)
	end
end)
UIDropDownMenu_Initialize(WatchFrameDropDown, WatchFrameDropDown_Initialize, 'MENU')


--==============================================--
--	Events
--==============================================--
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, event, addon)
	if (addon == 'Blizzard_AchievementUI') then

		hooksecurefunc('AchievementButton_OnClick', function(self)
			if (self.id and IsControlKeyDown()) then

				local inputBox = StaticPopup_Show('WATCHFRAME_URL')
				inputBox.editBox:SetText(linkAchievement:format(self.id))
				inputBox.editBox:HighlightText()

			end
		end)
	end

	self:UnregisterEvent('ADDON_LOADED')
	self.ADDON_LOADED = nil
end)