-- Credit: Armory Link (ShestakUI)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Armory"]["Enable"]) then return end
local print = function(...) Addon.print('armory', ...) end


local byte, char, ipairs				= byte, char, ipairs
local format, gsub, lower, sub		= string.format, string.gsub, string.lower, string.sub
local tinsert						= table.insert
local StaticPopupDialogs				= StaticPopupDialogs
local UnitPopupMenus				= UnitPopupMenus
local UnitPopupButtons				= UnitPopupButtons
local DEFAULT_CHAT_FRAME				= DEFAULT_CHAT_FRAME
local UIDROPDOWNMENU_INIT_MENU		= UIDROPDOWNMENU_INIT_MENU
local GetCVar						= GetCVar
local UnitPopup_OnClick				= UnitPopup_OnClick
local StaticPopup_Hide				= StaticPopup_Hide
local StaticPopup_Show				= StaticPopup_Show


-- Constants
local L_POPUP_ARMORY 				= 'Armory'
local realmName 					= lower(A["MyRealm"])
local realmLocal 					= sub(GetCVar('realmList'), 1, 2)
local link 						= 'en'


-- URL Encode
local function urlencode(obj)
	local currentIndex = 1
	local charArray = {}

	while (currentIndex <= #obj) do
		local char = byte(obj, currentIndex)
		charArray[currentIndex] = char
		currentIndex = currentIndex + 1
	end

	local converchar = ''
	for _, char in ipairs(charArray) do
		converchar = converchar .. format('%%%X', char)
	end

	return converchar
end

realmName = realmName:gsub('\'', '')
realmName = realmName:gsub(' ', '-')



-- Popup
StaticPopupDialogs.LINK_COPY_DIALOG = {
	text 						= L_POPUP_ARMORY,
	button1 						= OKAY,
	timeout 						= 0,
	whileDead 					= true,
	hasEditBox 					= true,
	editBoxWidth 					= 350,
	OnShow 						= function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed 			= function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed			= function(self) self:GetParent():Hide() end,
	preferredIndex 				= 5,
}



-- Dropdown menu link
hooksecurefunc('UnitPopup_OnClick', function(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
	local name = dropdownFrame.name

	if (name and self.value == 'ARMORYLINK') then
		local inputBox = StaticPopup_Show('LINK_COPY_DIALOG')

		if (realmLocal == 'us') then
			local linkurl = 'http://' .. realmLocal .. '.battle.net/wow/' .. link .. '/char/' .. realmName .. '/' .. name .. '/advanced'

			inputBox.editBox:SetText(linkurl)
			inputBox.editBox:HighlightText()

			return
		else
			DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFF00 Unsupported realm location. |r')

			StaticPopup_Hide('LINK_COPY_DIALOG')

			return
		end
	end
end)


UnitPopupButtons['ARMORYLINK'] = {
	text = L_POPUP_ARMORY,
	dist = 0,
	func = UnitPopup_OnClick
}


tinsert(UnitPopupMenus['FRIEND'], #UnitPopupMenus['FRIEND'] - 1, 'ARMORYLINK')
tinsert(UnitPopupMenus['PARTY'],  #UnitPopupMenus['PARTY']  - 1, 'ARMORYLINK')
tinsert(UnitPopupMenus['RAID'],   #UnitPopupMenus['RAID']   - 1, 'ARMORYLINK')
tinsert(UnitPopupMenus['PLAYER'], #UnitPopupMenus['PLAYER'] - 1, 'ARMORYLINK')