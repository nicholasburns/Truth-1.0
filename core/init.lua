local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('init', ...) end





--==============================================--
--	Print addons to chat
--==============================================--
do
	local p = CreateFrame('Frame')
	p:RegisterEvent('ADDON_LOADED')
	p:SetScript('OnEvent', function(self, event, addon)										-- DEFAULT_CHAT_FRAME:AddMessage(ao)
		print('ADDON_LOADED', addon)
	end)
end

--==============================================--
--	Slashes
--==============================================--
do
	if (not IsAddOnLoaded('_Dev')) then return end

	SLASH_TRUTH_DUMP1 = '/d'
	SlashCmdList['TRUTH_DUMP'] = SlashCmdList['DUMP']

	SLASH_TRUTH_OUTLINE1 = '/out'
	SlashCmdList['TRUTH_OUTLINE'] = SlashCmdList['_DEV_OUTLINE']
end

--==============================================--
--	Events
--==============================================--
--[[	do
		local EventMap = {}

		Addon.EventFrame = CreateFrame('Frame', AddOn ..'EventFrame', UIParent)
		Addon.EventFrame:RegisterEvent('VARIABLES_LOADED')
		Addon.EventFrame:SetScript('OnEvent', function(self, event, ...)
			if (event == 'VARIABLES_LOADED') then self:UnregisterEvent(event)
				addon:OnInitialize()
			end
		end)

		function addon:OnInitialize() end
	end
--]]
