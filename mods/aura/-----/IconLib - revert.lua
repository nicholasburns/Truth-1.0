-- credit: LiteBuff by Abin @ LiteBuff/Templates/IconFrame.lua



local _, addon = ...
local L = addon.L
local templates = addon.templates

local type = type
local CreateFrame = CreateFrame
local GetSpellCooldown = GetSpellCooldown




local function IconFrame_UpdateCooldown(self)
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


local function IconFrame_SetSpell(self, data)
	self.data = data
	self.icon:SetTexture(data and data.icon)

	IconFrame_UpdateCooldown(self)
end


local function IconFrame_SetIcon(self, icon)
	if (icon) then
		self.icon:SetTexture(icon)
	else
		local data = self.data
		self.icon:SetTexture(data and data.icon)
	end
end


local function IconFrame_SetActive(self, active)
	if (active) then
		IconFrame_SetIcon(self, type(active) == "string" and active or [=[Interface\Icons\Spell_Nature_WispSplode]=])
	else
		IconFrame_SetIcon(self)
	end
end


local function IconFrame_SetDesaturated(self, desaturated)
	self.desaturated = desaturated

	if (desaturated) then
		self.icon:SetVertexColor(0.4, 0.4, 0.4)
	else
		self.icon:SetVertexColor(1, 1, 1)
	end
end


local function IconFrame_SetText(self, text, r, g, b)
	self.text:SetText(text)

	if (r) then
		self.text:SetTextColor(r, g, b, 1)
	end
end


--==============================================--
--	CreateIconFrame
--	---------------
--	Icon frame with cooldown to display spells
--==============================================--
function templates.CreateIconFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(22, 22)

	frame.icon = frame:CreateTexture(nil, "BORDER")
	frame.icon:SetPoint("TOPLEFT", 1, -1)
	frame.icon:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	frame.text = frame:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
	frame.text:ClearAllPoints()
	frame.text:SetPoint("BOTTOM", frame, "BOTTOMRIGHT", 0, -3)

	frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.cooldown:SetAllPoints(frame.icon)

	frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	frame:SetScript("OnEvent", IconFrame_UpdateCooldown)

	frame.SetSpell = IconFrame_SetSpell
	frame.SetIcon = IconFrame_SetIcon
	frame.SetActive = IconFrame_SetActive
	frame.SetDesaturated = IconFrame_SetDesaturated
	frame.SetText = IconFrame_SetText

	return frame
end