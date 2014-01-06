local type = type
local CreateFrame = CreateFrame
local GetSpellCooldown = GetSpellCooldown
--==============================================--
--	Dependency Header
--==============================================--
-- local AddOn, Addon = ...
-- local A, C, T, L = unpack(select(2, ...))
-- if ((not C['Unit']['IconLib']['Enable'])) then return end
-- local print = function(...) Addon.print('IconLib', ...) end
--==============================================--
--	Stand-Alone Header
--==============================================--
local AddOn, Addon = ...


-- Library
Addon.Icon = {}


-- Constants
local size = 40
local pad = 5



--==============================================--
--	API
--==============================================--
local UpdateCooldown = function(self)
	local start, duration, enable

	local spell = self.data and self.data.spell

	if (spell) then
		start, duration, enable = GetSpellCooldown(spell)
	end

	if (start and start > 0 and duration > 0 and enable > 0) then
		self.cooldown:SetCooldown(start, duration)
		self.cooldown:Show()
	else
		self.cooldown:Hide()
	end
end

local SetSpell = function(self, data)
	self.data = data
	self.icon:SetTexture(data and data.icon)

	UpdateCooldown(self)
end

local SetIcon = function(self, icon)
	if (icon) then
		self.icon:SetTexture(icon)
	else
		local data = self.data
		self.icon:SetTexture(data and data.icon)
	end
end

local SetActive = function(self, active)
	if (active) then
		SetIcon(self, type(active) == 'string' and active or [=[Interface\Icons\Spell_Nature_WispSplode]=])
	else
		SetIcon(self)
	end
end

local SetDesaturated = function(self, desaturated)
	self.desaturated = desaturated
	if (desaturated) then
		self.icon:SetVertexColor(0.4, 0.4, 0.4)
	else
		self.icon:SetVertexColor(1, 1, 1)
	end
end

local SetText = function(self, count, r, g, b)
	self.count:SetText(count)
	if (r) then
		self.count:SetTextColor(r, g, b, 1)
	end
end


--==============================================--
--	Icon Constructor
--==============================================--
Addon.Icon.New = function(parent)

	local f = CreateFrame('Frame', nil, parent)
	f:SetSize(size - pad, size - pad)
	f:Template('DEFAULT')

	f.icon = f:CreateTexture('$parentIcon', 'BORDER')
	f.icon:SetPoint('TOPLEFT', 1, -1)
	f.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	f.cooldown = CreateFrame('Cooldown', '$parentCooldown', f, 'CooldownFrameTemplate')
	f.cooldown:SetAllPoints(f.icon)

	f.count = f:CreateFontString('$parentCount', 'OVERLAY', 'TextStatusBarText')				--~  'ARTWORK', 'TextStatusBarText')
	f.count:ClearAllPoints()
	f.count:SetPoint('BOTTOM', f, 'BOTTOMRIGHT', 0, -3)									--~  f.count:SetJustifyH('CENTER')

	f:RegisterEvent('SPELL_UPDATE_COOLDOWN')
	f:SetScript('OnEvent', UpdateCooldown)

	f.SetSpell = SetSpell
	f.SetIcon = SetIcon
	f.SetActive = SetActive
	f.SetDesaturated = SetDesaturated
	f.SetText = SetText

	return f

end






--==============================================--
--	Credit to LiteBuff (Addon) by Abin
--	LiteBuff/Templates/IconFrame.lua
--==============================================--

