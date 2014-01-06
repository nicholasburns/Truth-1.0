local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Aura"]["Status"]["Enable"]) then return end
local print = function(...) Addon.print('status', ...) end
local PlayerFrame = PlayerFrame
local TargetFrame = TargetFrame
local CreateFrame = CreateFrame
local CreateTexture = CreateTexture
local GetSpellInfo = GetSpellInfo
local UnitAffectingCombat = UnitAffectingCombat
local UnitBuff = UnitBuff
local UnitIsEnemy = UnitIsEnemy
local hooksecurefunc = hooksecurefunc
local MAX_TARGET_BUFFS = MAX_TARGET_BUFFS

--[[ Blizzard Constants
	-----------------------
	MAX_COMBO_POINTS   = 5					-- TargetFrame.lua
	MAX_TARGET_DEBUFFS = 16
	MAX_TARGET_BUFFS   = 32
	MAX_BOSS_FRAMES    = 5
--]]

local AnticipationBuffName = GetSpellInfo(115189)



--==============================================--
--	Events
--==============================================--
local f = CreateFrame('Frame')
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if (event == "PLAYER_ENTERING_WORLD") then

		--====================================--
		--	Target
		--====================================--
		local target = CreateFrame('Frame', 'TargetCombatIcon')
		target:SetParent(TargetFrame)
		target:SetPoint('RIGHT', TargetFrame, 2, 5)
		target:SetSize(30, 30)

		target.icon = target:CreateTexture(nil, 'BORDER')
		target.icon:SetAllPoints()
		target.icon:SetTexture(C["Aura"]["Status"]["IconTexture"])
		target:Hide()



		local function OnUpdate(self)
			if (UnitAffectingCombat('target')) then
				self:Show()
			else
				self:Hide()
			end
		end

		local t = CreateFrame('Frame')
		t:SetScript('OnUpdate', function(self) OnUpdate(target) end)


		--====================================--
		--	Highlight Dispellable / Spellsteal
		--====================================--
--[[		hooksecurefunc('TargetFrame_UpdateAuras', function(self)
			for i = 1, (MAX_TARGET_BUFFS) do	-- MAX_TARGET_BUFFS = 32  (@TargetFrame.lua)
				local name, _, icon, count, debuffType, duration, expiration = UnitBuff(self.unit, i)		-- _, _, icon, _, dT = UnitBuff(self.unit, i)

				if (icon and (not self.maxBuffs or i <= self.maxBuffs)) then
					local stealableFrame = _G[self:GetName() .. 'Buff' .. i .. 'Stealable']

					if (UnitIsEnemy(PlayerFrame.unit, self.unit) and (debuffType == 'Magic')) then
						stealableFrame:Show()
					else
						stealableFrame:Hide()
					end
				end
			end
		end)
--]]
	end
end)


--==============================================--
--	Backup
--==============================================--
--[==[
local f = CreateFrame('Frame')
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
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
--]==]
