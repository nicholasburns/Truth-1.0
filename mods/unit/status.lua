local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Unit"]["Status"]["Enable"]) then return end
local print = function(...) Addon.print('status', ...) end



local CombatTracker = CreateFrame('Frame')
CombatTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
CombatTracker:SetScript("OnEvent", function(self, event)
	if (event == "PLAYER_ENTERING_WORLD") then

		---------------------------------------
		--	TargetFrame
		---------------------------------------
		local target = CreateFrame('Frame', 'TargetCombatIcon')
		target:SetParent(TargetFrame)
		target:SetPoint('RIGHT', TargetFrame, 2, 5)
		target:SetSize(30, 30)

		target.icon = target:CreateTexture(nil, 'BORDER')
		target.icon:SetAllPoints()
		target.icon:SetTexture([=[Interface\Icons\ABILITY_DUALWIELD]=])

		target:Hide()

		local function TargetCombatIcon_OnUpdate(self)
			if (UnitAffectingCombat('target')) then self:Show() else self:Hide() end
		end

		local t = CreateFrame('Frame')
		t:SetScript('OnUpdate', function(self) TargetCombatIcon_OnUpdate(target) end)

		---------------------------------------
		--	FocusFrame
		---------------------------------------
		local focus = CreateFrame('Frame', 'FocusCombatIcon')
		focus:SetParent(FocusFrame)
		focus:SetPoint('LEFT', FocusFrame, -30, 5)
		focus:SetSize(30,30)

		focus.icon = focus:CreateTexture(nil, 'BORDER')
		focus.icon:SetAllPoints(focus)
		focus.icon:SetTexture([=[Interface\Icons\ABILITY_DUALWIELD]=])

		focus:Hide()

		local function FocusCombatIcon_OnUpdate(self)
			if (UnitAffectingCombat('focus')) then self:Show() else self:Hide() end
		end

		local f = CreateFrame('Frame')
		f:SetScript('OnUpdate', function(self) FocusCombatIcon_OnUpdate(focus) end)

		---------------------------------------
		--	TargetFrame_UpdateAuras
		---------------------------------------
	--[[		mM = ''

		hooksecurefunc('TargetFrame_UpdateAuras', function(self)
			selfname = self:GetName()
			isEnemy = UnitIsEnemy(PlayerFrame.unit, self.unit)

			for i = 1, MAX_TARGET_BUFFS do
				_, _, icon, _, duration = UnitBuff(self.unit, i)

				frameName = selfname ..'Buff'.. i

				if (icon and (not self.maxBuffs or i <= self.maxBuffs)) then
					frameStealable = _G[frameName .. 'Stealable']

					if (isEnemy and duration == mM) then
						frameStealable:Show()
					else
						frameStealable:Hide()
					end
				end
			end
		end)
	--]]
	end
end)

