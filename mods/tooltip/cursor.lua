--[[ Tooltip at Cursor (credit: CursorCompanion by Jaliborc) ]]
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["Cursor"]["Enable"]) then return end
local print = function(...) Addon.print('cursor', ...) end







--====================================--
--	Cursor Anchor
--====================================--
TargetFrameHealthBar:HookScript('OnEnter', function() GameTooltip:Hide() end)
TargetFrameManaBar:HookScript('OnEnter',   function() GameTooltip:Hide() end)

function GameTooltip_SetDefaultAnchor(tooltip, parent)
	tooltip:SetOwner(parent, "ANCHOR_CURSOR")
end



--==============================================--
--	Cursor Anchor
--==============================================--
--[[
do
	local GameTooltip = GameTooltip
	local TargetFrameManaBar = TargetFrameManaBar
	local TargetFrameHealthBar = TargetFrameHealthBar
	local GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor


	-- StatusBars
	TargetFrameHealthBar:HookScript('OnEnter', function() GameTooltip:Hide() end)
	TargetFrameManaBar:HookScript('OnEnter', function() GameTooltip:Hide() end)


	-- Anchor
	function GameTooltip_SetDefaultAnchor(tooltip, parent)
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	end
end
--]]

--================================================================================================--

--	Backup

--================================================================================================--
--[[	TargetFrameHealthBar:HookScript('OnEnter', function() GameTooltip:Hide() end)
	TargetFrameManaBar:HookScript('OnEnter',   function() GameTooltip:Hide() end)

	function GameTooltip_SetDefaultAnchor(tooltip, parent)
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	end
--]]
