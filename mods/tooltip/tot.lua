local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["ToT"]["Enable"]) then return end
local print = function(...) Addon.print('tot', ...) end



--================================================================================================--
--[[ TotTooltip (by Fixeh)
	-------------------------------------------------------------------------
	Adds target of target to your Tooltip in green

	** Displays < YOU > when something is targeting you
	** Takes 1 KB of memory
--]]
--================================================================================================--
local GameTooltip = GameTooltip


local function showUnit()
	local name, unit = GameTooltip:GetUnit()

	if (unit == nil) then return end

	if (UnitIsUnit('player', unit .. 'target')) then
		GameTooltip:AddLine('< YOU >', 0.5, 1)							-- GameTooltip:AddLine("text" [, r [, g [, b [, wrap]]]])

	elseif (UnitExists(unit .. 'target')) then
		GameTooltip:AddLine(UnitName(unit .. 'target'), 0.5, 1)			-- GameTooltip:AddLine("text" [, r [, g [, b [, wrap]]]])

	end
end

GameTooltip:HookScript('OnTooltipSetUnit', showUnit)


--================================================================================================--
--[[ TotTooltip (by Fixeh)
	-------------------------------------------------------------------------
	Adds target of target to your Tooltip in green

	** Displays < YOU > when something is targeting you
	** Takes 1 KB of memory
--]]
--================================================================================================--
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["ToT"]["GreenTip"]) then return end

--[[ local GTT = GameTooltip

	local function main()
		local name, unit = GTT:GetUnit()

		if (unit == nil) then return end

		if (UnitIsUnit('player', unit .. 'target')) then
			GTT:AddLine('< YOU >', 0.5, 1)
		elseif (UnitExists(unit .. 'target')) then
			GTT:AddLine(UnitName(unit .. 'target'), 0.5, 1)
		end
	end

	GTT:HookScript('OnTooltipSetUnit', main)
--]]
--================================================================================================--

--	LookingAtMe

--================================================================================================--
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["ToT"]["LookingAtMe"]) then return end

local format = string.format


LookinAtMe = {}

function LookinAtMe:AddTargetLine(pTT)
	local _, uID = pTT:GetUnit()
	if (not uID) then return end

	local tID = uID .. 'target'
	if (not UnitExists(tID)) then return end

	local msg
	local targetname 				= UnitName(tID)
	local targetlevel 				= UnitLevel(tID)
	local className, cID 			= UnitClass(tID)
	local color 					= RAID_CLASS_COLORS[cID] or NORMAL_FONT_COLOR
	local r, g, b					= color.r, color.g, color.b
	local ccf						= format('|cff%02x%02x%02x', color.r * 255 + 0.5, color.g * 255 + 0.5, color.b * 255 + 0.5)

	if (targetlevel > 0) then
		if (className and className ~= targetname) then
			msg = ', ' .. ccf .. 'Level ' .. targetlevel .. ' ' .. tostring(className)
		else
			msg = ', ' .. ccf .. 'Level ' .. targetlevel
		end
	else
		msg = 'Level ??'
	end

	-- GameTooltip:AddLine('text' [, r [, g [, b [, wrap] ] ] ])
	pTT:AddLine('Target: ' .. targetname .. msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)

	pTT:Show()							-- Tooltip is not resized after :AddLine().. so use :Show() afterwards
end

function LookinAtMe:Initialize()
	GameTooltip:HookScript('OnTooltipSetUnit', function (tooltip)
		if (tooltip:IsUnit('mouseover')) then
			LookinAtMe:AddTargetLine(tooltip)
		end
	end)
end

LookinAtMe:Initialize()
--]]

