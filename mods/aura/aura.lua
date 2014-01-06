--[[ CooldownFrame_SetTimer(self, start, duration, enable) ]]
local select = select
local UIParent = UIParent
local PlayerFrame = PlayerFrame
local CreateFrame = CreateFrame
local CreateTexture = CreateTexture
local CreateFontString = CreateFontString
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local GetSpellInfo = GetSpellInfo
local UnitBuff = UnitBuff
--


if (not false) then return end


--
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C['Aura']['Enable']) then return end
local print = function(...) Addon.print('aura', ...) end
local size = 40 local pad = 5

-- Spell Constants
local SPELL_ID  = 115189
local SPELL_NAME = GetSpellInfo(115189)




local f = CreateFrame("Frame", "TruAura", UIParent)
f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_AURA")


function f:PLAYER_ENTERING_WORLD (...)
	f:SetSize(size - pad, size - pad)
	f:SetPoint('CENTER', UIParent, 'CENTER', -100, -200)
	f:Template('DEFAULT')

	f.name = GetSpellInfo(115189)

	f.icon = f:CreateTexture('$parentIcon', 'BORDER')
	f.icon:SetAllPoints()
	f.icon:SetTexture(select(3, GetSpellInfo(115189)))
	f.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	-- f.icon:SetDesaturated(true)

	f.cooldown = CreateFrame('Cooldown', '$parentCooldown', f, 'CooldownFrameTemplate')
	f.cooldown:SetAllPoints()															-- f.cooldown:SetCooldown(GetTime(), 1.5)
	f.cooldown:SetReverse()

	f.count = f:CreateFontString('$parentCount', 'OVERLAY', 'TextStatusBarText')				--~	'ARTWORK', 'TextStatusBarText')
	f.count:ClearAllPoints()
	f.count:SetPoint('BOTTOM', f, 'BOTTOMRIGHT', 0, -3)									--~	f.count:SetJustifyH('CENTER')
	f.count:SetText(count)
end



function f:UNIT_AURA (unit)
--[[ if (unit ~= "player") then return end

	local frameName = self:GetName()
	local name, rank, icon, count, type, duration, expirationTime

	for i = 1, (MAX_PARTY_BUFFS) do
		name, rank, icon, count, type, duration, expirationTime = UnitBuff(unit, i)

		local buffName = frameName .. "Buff" .. i

		if (icon) then

			local buffIcon = _G[buffName .. "Icon"]
			buffIcon:SetTexture(icon)

			local coolDown = _G[buffName .. "Cooldown"]
			if (coolDown) then
				CooldownFrame_SetTimer(coolDown, expirationTime - duration, duration, 1)
			end

			_G[buffName]:Show()
		else
			_G[buffName]:Hide()
		end
	end
--]]end


function f:UNIT_AURA (unit)					--~  print("UNIT_AURA")
	if (unit ~= "player") then return end

	local name, _, icon, count, type, duration, expiration

	for i = 1, 40 do
		name, _, icon, count, type, duration, expiration = UnitBuff("player", i) --, "PLAYER")

		if (not name) then return end

		if (name == GetSpellInfo(115189)) then

			-- print(format("name: %s, icon: %s, count: %s, dur: %s, exp: %s", name, icon, count, duration, expiration))
			-- print("name", name)
			-- print("icon", icon)
			-- print("count", count)
			print("duration", duration)
			-- print("expiration", expiration)

			local start, duration, enable = GetSpellCooldown(115189)

			if (duration) then

				print("GetTime - exp:", GetTime() - expiration)
				print("duration:", duration)
				print("DUR:", DUR)

				f:SetCooldown(GetTime() - expiration, duration)

				-- f.cooldown:SetCooldown(GetTime() - expiration, duration)
				-- CooldownFrame_SetTimer(f.cooldown, GetTime() - expiration - 0.5, duration)
				--~  f.cooldown:SetCooldown(GetTime() - expiration - 0.5, duration)

			end
		end
	end
end


--[[	for i = 1, 40 do
		name, _, icon, count, type, duration, expiration = UnitBuff("player", i, "PLAYER")
		if (not name) then return end

		if (name == GetSpellInfo(SPELL_ID)) then
			f.icon:SetTexture(icon)			--~  Set our texture to the item found in bags

			if (count and (count > 0)) then	--~  Get the count if there is one
				f.count:SetText(count)
				f.count:Show()
			else
				f.count:SetText("")
				f.count:Hide()
			end


			-- f:SetScript('OnUpdate', function(self, elapsed)

				local start, duration, enable = GetSpellCooldown(SPELL_ID)

			--~  CooldownFrame_SetTimer(self, start, duration, enable, charges, maxCharges)
				CooldownFrame_SetTimer(f.cooldown, start, duration, true) --, charges, maxCharges)		-- f.cooldown:SetCooldown(GetTime() - expiration - 0.5, duration)
			-- end)

		end
	end
--]]



--[[	start, duration, enable = GetSpellCooldown(spellName or spellID)

Return:
	start 	- The value of GetTime() at the moment the cooldown began, or 0 if the spell is ready (number)
	duration 	- The length of the cooldown, or 0 if the spell is ready (number)
	enable 	- 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the spell is ready.) (number)
--]]


--==============================================--
--	SPELL_UPDATE_USABLE
--==============================================--
--[[
	------------------------------
	Time:		58024.549
	arg 13:		"Anticipation"
	arg 14:		1
	arg 15:		"BUFF"
	arg 16:		5
	------------------------------
	Time:		58023.787
	arg 14:		64
	arg 15:		"DEBUFF"
	------------------------------
	Time:		58024.587
	arg 13:		"Dispatch"
	arg 14:		1
	------------------------------
--]]

--==============================================--
--	UNIT_AURA
--==============================================--
--[[
	------------------------------
	Time:	58024.587
	arg 1:	"player"
	------------------------------
--]]









--==============================================--
--	Addon
--==============================================--

if (not false) then return end

-- function f:SPELL_UPDATE_USABLE ()
	-- print('SPELL_UPDATE_USABLE', 'dong')
-- end


-- Anchor
-- local anchor = CreateFrame('Frame', 'TruAuraAnchor', UIParent)
-- anchor:SetPoint('CENTER', UIParent, 'CENTER', -100, -200)
-- anchor:SetSize(size + pad, size + pad)

do
	local f = CreateFrame('Frame', 'TruAura', UIParent)
	f:SetSize(size - pad, size - pad)
	f:SetPoint('CENTER', UIParent, 'CENTER', -100, -200)
	f:Template('DEFAULT')

	f.name = GetSpellInfo(115189)

	f.icon = f:CreateTexture('$parentIcon', 'BORDER')
	f.icon:SetAllPoints()
	f.icon:SetTexture(select(3, GetSpellInfo(115189)))
	f.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	-- f.icon:SetDesaturated(true)

	f.cooldown = CreateFrame('Cooldown', '$parentCooldown', f, 'CooldownFrameTemplate')
	f.cooldown:SetAllPoints()															-- f.cooldown:SetCooldown(GetTime(), 1.5)
	f.cooldown:SetReverse()

	f.count = f:CreateFontString('$parentCount', 'OVERLAY', 'TextStatusBarText')				--~	'ARTWORK', 'TextStatusBarText')
	f.count:ClearAllPoints()
	f.count:SetPoint('BOTTOM', f, 'BOTTOMRIGHT', 0, -3)									--~	f.count:SetJustifyH('CENTER')
	f.count:SetText(count)


	f:RegisterEvent('SPELL_UPDATE_USABLE')		--~	THIS ONE!
	f:RegisterEvent('UNIT_AURA')
	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:SetScript('OnEvent',
		function(self, event, ...)

		if (event == 'PLAYER_ENTERING_WORLD') then
			f.icon:SetDesaturated(true)
		end

		-- if (event == 'UNIT_AURA') then
			-- if (UnitAura('player', GetSpellInfo(115189))) then 								-- 'Hand of Protection')) then
				-- print('UNIT_AURA', 'ocurred')

				-- PlaySoundFile(Addon.media.sound.error, 'Master')
				-- PlaySoundFile(Addon.media.sound.error)
			-- end
		-- end
--[[
  		if (event == 'UNIT_AURA') then
			local name, icon, count, duration, expiration, _

			for i = 1, 40 do
				name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
				if (not name) then return end

				if (name == GetSpellInfo(115189)) then

					if (duration and (duration > 0)) then
						CooldownFrame_SetTimer(ant.cooldown, GetTime() - expiration - 0.5, duration)		-- ant.cooldown:SetCooldown(GetTime() - expiration - 0.5, duration)
					end
				end
			end
		end
--]]

		end)

end



--==============================================--
--	AutoButton
--==============================================--
--[[

-- Create anchor
local anchor = CreateFrame('Frame', 'AutoButtonAnchor', UIParent)
anchor:SetPoint(unpack(C.position.auto_button))
anchor:SetSize(size + pad, size + pad)

-- Create button
local f = CreateFrame('Button', 'f', UIParent, 'SecureActionButtonTemplate')
f:SetSize(size - pad, size - pad)
f:SetPoint('CENTER', anchor, 'CENTER', 0, 0)
f:Template('DEFAULT')
f:StyleButton()
f:RegisterForClicks('AnyUp')
f:SetAttribute('type', 'item')


-- Texture for our button
f.t = f:CreateTexture(nil, 'OVERLAY')
f.t:SetPoint('TOPLEFT', f, 'TOPLEFT', 2, -2)
f.t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -2, 2)
f.t:SetTexCoord(0.1, 0.9, 0.1, 0.9)


-- Count text for our button
f.c = f:CreateFontString(nil, 'OVERLAY')
f.c:SetFont(C.media.pixel_font, C.media.pixel_font_size * 2, C.media.pixel_font_style)
f.c:SetTextColor(1, 1, 1, 1)
f.c:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 1, -2)
f.c:SetJustifyH('CENTER')


-- Cooldown
f.cd = CreateFrame('Cooldown', nil, f)
f.cd:SetPoint('TOPLEFT', f, 'TOPLEFT', 2, -2)
f.cd:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -2, 2)


local Scanner = CreateFrame('Frame')
Scanner:RegisterEvent('BAG_UPDATE')
Scanner:RegisterEvent('UNIT_INVENTORY_CHANGED')
Scanner:SetScript('OnEvent', function()

	-- Scan bags for Item matchs
	for b = 0, (NUM_BAG_SLOTS) do

		for s = 1, GetContainerNumSlots(b) do

			local itemID = GetContainerItemID(b, s)
			itemID = tonumber(itemID)

			for i, Items in pairs(Items) do

				if itemID == Items then

					local itemName = GetItemInfo(itemID)
					local count = GetItemCount(itemID)
					local itemIcon = GetItemIcon(itemID)

					-- Set our texture to the item found in bags
					f.t:SetTexture(itemIcon)

					-- Get the count if there is one
					if count and count > 1 then
						f.c:SetText(count)
					else
						f.c:SetText('')
					end

					f:SetScript('OnUpdate', function(self, elapsed)
						local cd_start, cd_finish, cd_enable = GetContainerItemCooldown(b, s)
						CooldownFrame_SetTimer(f.cd, cd_start, cd_finish, cd_enable)
					end)

					AutoButtonShow(itemName)
				end
			end
		end
	end

	-- Scan inventory for Equipment matches
	for w = 1, 19 do
		for e, EquipedItems in pairs(EquipedItems) do
			if GetInventoryItemID('player', w) == EquipedItems then
				local itemName = GetItemInfo(EquipedItems)
				local itemIcon = GetInventoryItemTexture('player', w)

				-- Set our texture to the item found in bags
				f.t:SetTexture(itemIcon)
				f.c:SetText('')

				f:SetScript('OnUpdate', function(self, elapsed)
					local cd_start, cd_finish, cd_enable = GetInventoryItemCooldown('player', w)
					CooldownFrame_SetTimer(f.cd, cd_start, cd_finish, cd_enable)
				end)

				AutoButtonShow(itemName)
			end
		end
	end
end)
--]]


--==============================================--
--	Original Code
--==============================================--
--[[
local a = CreateFrame('Frame')
a:RegisterEvent('PLAYER_ENTERING_WORLD')
a:RegisterEvent('UNIT_AURA')
a:SetScript('OnEvent', function(self, event, ...)
	if (event == 'PLAYER_ENTERING_WORLD') then

		ant = CreateFrame('Frame', 'Anticipation', TruthAuras)
		ant.name = GetSpellInfo(115189)
		ant:SetPoint('TOPLEFT', TruthAuras, pad, -pad)
		ant:SetPoint('BOTTOMRIGHT', TruthAuras, -pad, pad)
		ant:Template('DEFAULT')

		ant.icon = ant:CreateTexture('$parentIcon', 'BORDER')
		ant.icon:SetAllPoints()
		ant.icon:SetTexture(select(3, GetSpellInfo(115189)))
		ant.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		ant.icon:SetDesaturated(true)

		ant.cooldown = CreateFrame('Cooldown', '$parentCD', ant, 'CooldownFrameTemplate')
		ant.cooldown:SetPoint('TOP', ant, 'BOTTOM', 0, -10)								-- ant.cooldown:SetAllPoints(ant)
		ant.cooldown:SetReverse()

		if (ant.count) then
			ant.count = _G[ant.count:GetName()]
		else
			ant.count = ant:CreateFontString('$parentCount', 'OVERLAY')
			ant.count:SetFont(Addon.default.pxfont[1], 20, 'OUTLINE')
			ant.count:SetPoint('BOTTOMRIGHT', -1, 1)
			ant.count:SetJustifyH('CENTER')
		end

	end

	if (event == 'UNIT_AURA') then
		local name, icon, count, duration, expiration, _

		for i = 1, 40 do
			name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
			if (not name) then return end

			if (name == GetSpellInfo(115189)) then

				if (duration and (duration > 0)) then
					CooldownFrame_SetTimer(ant.cooldown, GetTime() - expiration - 0.5, duration)		-- ant.cooldown:SetCooldown(GetTime() - expiration - 0.5, duration)
					ant.icon:SetDesaturated(false)
				else
					ant.icon:SetDesaturated(true)
				end

				if (count) then
				-- if (count and (count > 0)) then
					ant.count:SetText(count)
				else
					ant.count:SetText('0')
				end

			end
		end
	end
end)

--==============================================--
--	SND
--==============================================--
local snd
--
local s = CreateFrame('Frame')
s:RegisterEvent('PLAYER_ENTERING_WORLD')
s:RegisterEvent('UNIT_AURA')
s:SetScript('OnEvent', function(self, event, ...)

	if (event == 'PLAYER_ENTERING_WORLD') then

		snd = CreateFrame('Frame', 'SND', TruthAuras)
		snd.name = GetSpellInfo(5171)
		snd:SetPoint('RIGHT', TruthAuras, 'LEFT', -5, 0)		-- snd:SetPoint('LEFT', TruthAuras, 'RIGHT', 5, 0)
		snd:SetSize(size - pad, size - pad)
		snd:Template('DEFAULT')

		snd.icon = snd:CreateTexture('$parentIcon', 'BORDER')
		snd.icon:SetAllPoints()
		snd.icon:SetTexture(select(3, GetSpellInfo(5171)))
		snd.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		snd.icon:SetDesaturated(true)

		snd.cooldown = CreateFrame('Cooldown', '$parentCD', snd, 'CooldownFrameTemplate')
		snd.cooldown:SetPoint('TOP', snd, 'BOTTOM', 0, -10)
		-- snd.cooldown:SetAllPoints(snd)
		snd.cooldown:SetReverse()

		snd.count = snd:CreateFontString('$parentCount', 'OVERLAY')
		snd.count:SetFont(Addon.default.pxfont[1], 20, 'OUTLINE')
		snd.count:SetPoint('BOTTOMRIGHT', -1, 1)
		snd.count:SetJustifyH('CENTER')

	end

	if (event == 'UNIT_AURA') then
		local name, icon, count, duration, expiration, _

		for i = 1, 40 do
			name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
			if (not name) then return end

			if (name == GetSpellInfo(5171)) then

				if (duration > 0) then
					CooldownFrame_SetTimer(snd.cooldown, GetTime() - expiration - 0.5, duration)
					-- snd.cooldown:SetCooldown(exp - dur - 0.5, dur)
					snd.icon:SetDesaturated(false)
				else
					snd.icon:SetDesaturated(true)
				end

			end
		end
	end

end)
--]]



