local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))





--==============================================--
--	5.4.0
--	Taint: IsDisabledByParentalControls
--	http://us.battle.net/wow/en/forum/topic/10388639018?page=3
--==============================================--
--[[
do
	hooksecurefunc('StaticPopup_Show', function(which)
		if (which == 'ADDON_ACTION_FORBIDDEN') then
			StaticPopup_Hide(which)
		end
	end)
end
--]]

--==============================================--
--	5.3.0
--	Release Spirit @ ReloadUI
--	Credit: Inomena/diaf.lua
--==============================================--
--[[
do
	hooksecurefunc('StaticPopup_Show',	function(which)
		if ((which == 'DEATH') and (not UnitIsDead('player'))) then
			StaticPopup_Hide(which)
		end
	end)
end
--]]


