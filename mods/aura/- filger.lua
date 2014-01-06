--[[	Filger - Copyright (c) 2009, Nils Ruesch ]]--
local I, C, L = unpack(select(2, ...))
-- if (iFilgerConfig) then
	-- iFilger_Spells = iFilgerConfig['Filger_Spells']
	-- iFilger_Config = iFilgerConfig['Filger_Config']
-- end

local iFilger_Spells = iFilgerConfig and iFilgerConfig['Filger_Spells']
local iFilger_Config = iFilgerConfig and iFilgerConfig['Filger_Config']

local class = select(2, UnitClass('player'))
local classcolor = RAID_CLASS_COLORS[class]

local iFilger = {}
iFilger['frame_list'] = {}

local time, Update



--==============================================--
-- Parse Buff name & ID
--==============================================--
function iFilger:UnitBuff(unitID, inSpellID, spn, absID)
	if (absID) then

		for i = 1, 40, do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID = UnitBuff(unitID, i)

			if (not GetSpellInfo(spellID)) then return end

			if (not name) then break end

			if (inSpellID == spellID) then
				return name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID
			end

		end
	else
		return UnitBuff(unitID, spn)
	end

	return nil
end

--==============================================--
-- Parse Debuff name & ID
--==============================================--
function iFilger:UnitDebuff(unitID, inSpellID, spn, absID)
	if (absID) then

		for i = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID = UnitDebuff(unitID, i)

			if (not GetSpellInfo(spellID)) then return end

			if (not name) then break end

			if (inSpellID == spellID) then
				return name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID
			end

		end
	else
		return UnitDebuff(unitID, spn)
	end

	return nil
end

--==============================================--
-- Tooltip functions
--==============================================--
local TooltipAnchor

function iFilger:TooltipOnEnter()
	if (self.spellID > 20) then														--~	TODO: slot ID work around, but causes mouseover LUA error with trinket

		local str = 'spell:%s'
		local BadTotems = {[8076] = 8075, [8972] = 8071, [5677] = 5675}

		GameTooltip:ClearLines()

		if (iFilger_Config.TooltipMover) then
			GameTooltip:SetOwner(_G[TooltipAnchor], 'ANCHOR_TOPRIGHT', 0, 7)
		else
			GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 7)
		end

		if (BadTotems[self.spell]) then
			GameTooltip:SetHyperlink(format(str, BadTotems[self.spellID]))
		else
			GameTooltip:SetHyperlink(format(str, self.spellID))
		end

		GameTooltip:Show()
	end
end

function iFilger:TooltipOnLeave()
	GameTooltip:Hide()
end

--==============================================--
-- Flash functions
--==============================================--
local StartFlash = function(self, duration)
	if (not self.anim) then
		self.anim = self:CreateAnimationGroup('Flash')

		self.anim.fadein = self.anim:CreateAnimation('ALPHA', 'FadeIn')
		self.anim.fadein:SetChange(1)
		self.anim.fadein:SetOrder(2)

		self.anim.fadeout = self.anim:CreateAnimation('ALPHA', 'FadeOut')
		self.anim.fadeout:SetChange(-1)
		self.anim.fadeout:SetOrder(1)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local StopFlash = function(self)
	if (self.anim) then self.anim:Finish() end
end

function iFilger:Flash()
	local time = self.value.start + self.value.duration - GetTime()

	if (time < 0) then StopFlash(self) end

	if (time < iFilger_Config.FlashThreshold) then StartFlash(self, iFilger_Config.FlashDuration) end
end

--==============================================--
-- Update
--==============================================--
function iFilger:UpdateCDwithFlash()
	local time = self.value.start + self.value.duration - GetTime()

	if (self:GetParent().Mode == 'BAR') then
		self.statusbar:SetValue(time)

		if (time <= 60) then
			self.time:SetFormattedText('%.1f', (time))
		else
			self.time:SetFormattedText('%d:%.2d',(time / 60), (time % 60))
		end
	end

	if (time < 0) then
		local parent = self:GetParent()
		parent.actives[self.activeIndex] = nil

		self:SetScript('OnUpdate', nil)

		iFilger.DisplayActives(parent)
	end

	iFilger.Flash(self)
end

function iFilger:UpdateCDwithoutFlash()
	local time = self.value.start + self.value.duration - GetTime()

	if ((self:GetParent().Mode == 'BAR')) then
		self.statusbar:SetValue(time)

		if (time <= 60) then
			self.time:SetFormattedText('%.1f', (time))
		else
			self.time:SetFormattedText('%d:%.2d', (time / 60), (time % 60))
		end

	end

	if (time < 0) then
		local parent = self:GetParent()
		parent.actives[self.activeIndex] = nil

		self:SetScript('OnUpdate', nil)

		iFilger.DisplayActives(parent)
	end
end

--==============================================--
-- Display
--==============================================--
function iFilger:DisplayActives()
	if (not self.actives) then return end

	if (not self.auras) then
		self.auras = {}
	end

	local id = self.Id
	local previous = nil
	local index

	index = 1

	for _, _ in pairs(self.actives) do

		local aura = self.auras[index]

		if (not aura) then

			-- create aura
			aura = CreateFrame('Frame', 'iFilgerAnchor' .. id .. 'Frame' .. index, self)
			aura:SetSize(16, 16) 														--~	Default values
			aura:SetScale(1)
			aura:SetTemplate('DEFAULT')

			-- anchor
			if (index == 1) then
				aura:SetPoint(unpack(self.setPoint))
			else
				if (self.Direction == 'UP') then
					aura:SetPoint('BOTTOM', previous, 'TOP', 0, self.Interval)
				elseif (self.Direction == 'RIGHT' or self.Direction == 'HORIZONTAL') then
					aura:SetPoint('LEFT', previous, 'RIGHT', self.Interval, 0)
				elseif (self.Direction == 'LEFT') then
					aura:SetPoint('RIGHT', previous, 'LEFT', -self.Interval, 0)
				else
					aura:SetPoint('TOP', previous, 'BOTTOM', 0, -self.Interval)
				end
			end

			-- icon
			if  (aura.icon) then
				aura.icon = _G[aura.icon:GetName()]
			else
				aura.icon = aura:CreateTexture('$parentIcon', 'ARTWORK')
				aura.icon:SetPoint('TOPLEFT', 2, -2)
				aura.icon:SetPoint('BOTTOMRIGHT', -2, 2)
				aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end

			if  (self.Mode == 'ICON') then

				-- cooldown
				if  (aura.cooldown) then
					aura.cooldown = _G[aura.cooldown:GetName()]
				else
					aura.cooldown = CreateFrame('Cooldown', '$parentCD', aura, 'CooldownFrameTemplate')
					aura.cooldown:SetAllPoints(aura.icon)
					aura.cooldown:SetReverse()
				end

				-- count
				if  (aura.count) then
					aura.count = _G[aura.count:GetName()]
				else
					aura.count = aura:CreateFontString('$parentCount', 'OVERLAY')
					-- aura.count:SetFont(C['media'].pixelfont, 20, 'OUTLINE')
					aura.count:SetPoint('BOTTOMRIGHT', -1, 1)
					aura.count:SetJustifyH('CENTER')
				end
			end

			-- spellID
			aura.spellID = 0

			-- insert aura
			self.auras[index] = aura
		end

		-- save previous
		previous = aura

		-- next
		index = index + 1
	end

	-- Sort actives
	if (not self.sortedIndex) then
		self.sortedIndex = {}
	end

	-- Clear sorted						-- it would be easier to recreate self.sortedIndex or use a local array but this would not be GC-friendly
	for n in pairs(self.sortedIndex) do
		self.sortedIndex[n] = 999 -- dummy high value
	end

	local activeCount = 1
	for n in pairs(self.actives) do
		self.sortedIndex[activeCount] = n
		activeCount = activeCount + 1
	end
	table.sort(self.sortedIndex)


	-- Update texture, count, cd, size, opacity, spid
	local totalWidth = 0
	index = 1

	-- for activeIndex, value in pairs(self.actives) do
	for n in pairs(self.sortedIndex) do
		if (n >= activeCount) then break end -- sortedIndex may be greater than actives

		local activeIndex = self.sortedIndex[n]
		local value = self.actives[activeIndex] -- Get sorted active
		local aura = self.auras[index]

		aura.spellName = GetSpellInfo( value.spid )
		if ((self.Mode == 'BAR')) then
			aura.spellname:SetText(aura.spellName)
		end

		aura.icon:SetTexture(value.icon)
		if (value.count and value.count > 1) then
			aura.count:SetText(value.count)
			aura.count:Show()
		else
			aura.count:Hide()
		end


		-- Spell is ON Cooldown now
		if (value.duration and value.duration > 0) then

			if (self.Mode == 'ICON') then

				CooldownFrame_SetTimer(aura.cooldown, value.start, value.duration, 1)

				if (value.data.filter == 'CD' or value.data.filter == 'ICD') then
					aura.value = value
					aura.activeIndex = activeIndex

					if (iFilger_Config.FlashIcon) then
						aura:SetScript('OnUpdate', iFilger.UpdateCDwithFlash)
					else
						aura:SetScript('OnUpdate', iFilger.UpdateCDwithoutFlash)
					end
				else
					aura.value = value

					if (iFilger_Config.FlashIcon) then
						aura:SetScript('OnUpdate', iFilger.Flash)
					else
						aura:SetScript('OnUpdate', nil)
					end
				end

				aura.cooldown:Show()
			end

		-- Spell is OFF Cooldown now
		else
			if ((self.Mode == 'ICON')) then
				aura.cooldown:Hide()
			else
				aura.statusbar:SetMinMaxValues(0, 1)
				aura.statusbar:SetValue(1)
				aura.time:SetText('')
			end

			aura:SetScript('OnUpdate', nil)
		end

		aura.spellID = value.spid

		if (iFilger_Config.tooltip) then
			aura:EnableMouse(true)
			aura:SetScript('OnEnter', iFilger.TooltipOnEnter)
			aura:SetScript('OnLeave', iFilger.TooltipOnLeave)
		end

		aura:SetWidth(self.Size)
		aura:SetHeight(self.Size)
		aura:SetAlpha(self.Alpha or 1.0)

		totalWidth = totalWidth + self.Size + self.Interval

		-- show
		aura:Show()

		-- next
		index = index + 1
	end

	-- Update horizontal anchoring
	if (index > 1 and self.Direction == 'HORIZONTAL') then
		-- Compute total width
		totalWidth = totalWidth - self.Size - self.Interval -- remove last interval
		-- Get base position
		local relativePoint, relativeFrame, offsetX, offsetY = unpack(self.setPoint)
		-- Update x-offset: remove half the total width
		offsetX = offsetX - totalWidth / 2

		-- Set position
		local aura = self.auras[1]
		aura:SetPoint(relativePoint, relativeFrame, offsetX, offsetY)
	end

	-- Hide remaining
	for i = index, (#self.auras) do
		local aura = self.auras[i]
		aura:Hide()
	end
end


--==============================================--
-- Function OnEvent
--==============================================--
function iFilger:OnEvent(event, unit)

	if (event == 'SPELL_UPDATE_COOLDOWN') or (event == 'SPELL_UPDATE_USABLE')
	or (event == 'ACTIVE_TALENT_GROUP_CHANGED') or (event == 'PLAYER_TARGET_CHANGED')
	or (event == 'PLAYER_FOCUS_CHANGED') or (event == 'PLAYER_ENTERING_WORLD') or
	   (event == 'UNIT_AURA') and (unit == 'target' or unit == 'player' or unit == 'pet' or unit == 'focus') then

		local ptt = GetSpecialization()				-- ptt = Primary Talent Tree
		local needUpdate = false
		local id = self.Id

		if (iFilger['spells'][id]) then

			for i = 1, #iFilger['spells'][id] do

				local data = iFilger['spells'][id][i]
				local found = false
				local name, icon, count, duration, start, spid

				spid = 0


				-- BUFFS

				if (data.filter == 'BUFF' and (not data.spec or data.spec == ptt)) then

					local caster, spn, expirationTime

					spn, _, _ = GetSpellInfo(data.spellID)
					name, _, icon, count, _, duration, expirationTime, caster, _, _, spid = iFilger:UnitBuff(data.unitId, data.spellID, spn, data.absID)

					if (icon and data.icon) then
						icon = data.icon
					end

					if (name and (data.caster == 'all' or data.caster == caster)) then
						start = expirationTime - duration
						found = true
					end

					if (name and found and data.timeleft and data.timeleft < (expirationTime - GetTime())) then
						local triggerwhen = (expirationTime - data.timeleft)

						if (not self.updatetimes) then
							self.updatetimes = {}
						end

						self.updatetimes[i] = {
							data 	= data,
							name 	= name,
							icon 	= icon,
							count 	= count,
							start 	= start,
							duration 	= duration,
							spid 	= spid,
							triggerwhen = triggerwhen,
						}

						found = false
					end


				-- DEBUFFS

				elseif (data.filter == 'DEBUFF') and (not data.spec or data.spec == ptt) then

					local caster, spn, expirationTime

					spn, _, _ = GetSpellInfo(data.spellID)
					name, _, icon, count, _, duration, expirationTime, caster, _, _, spid = iFilger:UnitDebuff(data.unitId, data.spellID, spn, data.absID)

					if (icon and data.icon) then
						icon = data.icon
					end

					if (name and (data.caster == 'all' or data.caster == caster)) then
						start = expirationTime - duration
						found = true
					end

					if (name and found and data.timeleft and data.timeleft < (expirationTime - GetTime())) then
						local triggerwhen = (expirationTime - data.timeleft)

						if (not self.updatetimes) then
							self.updatetimes = {}
						end

						self.updatetimes[i] = {
							data = data,
							name = name,
							icon = icon,
							count = count,
							start = start,
							duration = duration,
							spid = spid,
							triggerwhen = triggerwhen
						}

						found = false
					end


				-- CD

				elseif (data.filter == 'CD' and (not data.spec or data.spec == ptt)) then
					if (data.spellID) then
						name, _, icon = GetSpellInfo(data.spellID)

						if (data.absID) then
							start, duration = GetSpellCooldown(data.spellID)
						else
							start, duration = GetSpellCooldown(name)
						end

						spid = data.spellID

					elseif (data.slotID) then
						spid = data.slotID
						local slotLink = GetInventoryItemLink('player', data.slotID)

						if (slotLink) then
							name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink)
							start, duration = GetInventoryItemCooldown('player', data.slotID)
						end
					end

					if (icon and data.icon) then
						icon = data.icon
					end

					if (name and (duration or 0) > 1.5) then
						found = true
					end

				elseif (data.filter == 'ACD' and (not data.incombat or InCombatLockdown()) and (not data.spec or data.spec == ptt)) then
					name, _, icon = GetSpellInfo(data.spellID)
					spid = data.spellID

					--[[+NB+]]
					local enabled

					if (data.absID) then
						start, duration, enabled = GetSpellCooldown(data.spellID)
					else
						start, duration, enabled = GetSpellCooldown(name)
					end

					found = true

					if (not enabled) then
						name = nil
						found = false
					elseif (enabled == 0 or (start > 0 and duration > 1.5)) then
						name = nil
						found = false
					end

					if (name and (duration or 0) > 1.5) then
						found = false
					end

					if (icon and data.icon) then
						icon = data.icon
					end

					duration = 0

				elseif (data.filter == 'ICD' and (not data.spec or data.spec == ptt)) then
					if (data.trigger == 'BUFF') then
						local spn
						spn, _, icon = GetSpellInfo(data.spellID)
						name, _, _, _, _, _, _, _, _, _, spid = iFilger:UnitBuff('player', data.spellID, spn, data.absID)

					elseif (data.trigger == 'DEBUFF') then
						local spn
						spn, _, icon = GetSpellInfo(data.spellID)
						name, _, _, _, _, _, _, _, _, _, spid = iFilger:UnitDebuff('player', data.spellID, spn, data.absID)
					end

					if (icon and data.icon) then
						icon = data.icon
					end

					if (name) then
						if (data.slotID) then
							local slotLink = GetInventoryItemLink('player', data.slotID)
							_, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink)
						end

						duration = data.duration
						start = GetTime()
						found = true
					end
				end

				if (found) then
					if (not self.actives) then self.actives = {} end
					if (not self.actives[i]) then
						self.actives[i] = {
							data = data,
							name = name,
							icon = icon,
							count = count,
							start = start,
							duration = duration,
							spid = spid
						}

						needUpdate = true

					else
						if (data.filter ~= 'ICD' and data.filter ~= 'ACD')
						and ((self.actives[i].count ~= count) or (self.actives[i].start ~= start) or (self.actives[i].duration ~= duration)) then
							self.actives[i].count = count
							self.actives[i].start = start
							self.actives[i].duration = duration
							needUpdate = true
						end
					end

				else
					if ((data.filter ~= 'ICD') and self.actives and self.actives[i]) then
						self.actives[i] = nil -- remove BUFF/DEBUFF/ACD (only when BUFF/DEBUFF modified, CD are removed in UpdateCD)
						needUpdate = true
					end
				end
			end
		end

		if (needUpdate and self.actives) then
			iFilger.DisplayActives(self)
		end
	end
end

--==============================================--
-- Spell list configuration
--==============================================--
function iFilger:UpdateSpellList(zone)
	if (not iFilger['spells']) then iFilger['spells'] = {} end

	local loaded = ''
	local loading = false

	for index in pairs(iFilger['spells']) do
		iFilger['spells'][index] = nil
	end

	local myClass = select(2, UnitClass('player'))

	local tabs = {  												-- List of headers and number of tabs inside each ones
		[1] = myClass,												--	'MAGE','DEATHKNIGHT','PRIEST''WARLOCK','DRUID','HUNTER','ROGUE','PALADIN','SHAMAN','WARRIOR','HUNTER/DRUID/ROGUE',
		[2] = 'ALL',
		[3] = 'PVP',
		[4] = 'PVE',
		[5] = 'TANKS',
		[6] = 'HUNTER/DRUID/ROGUE',
	}

	if (myClass ~= 'HUNTER' and myClass ~= 'DRUID' and myClass ~= 'ROGUE') then	-- remove the part we don't want
		tabs[6] = nil
	end

	local cat

	for i = 1, (#tabs) do

		cat = tabs[i]

		if ((cat == 'PVE' or cat == 'TANKS' and (zone == 'pve' or zone == 'config')) or (cat == 'PVP' and (zone == 'pvp' or zone == 'config')) or (cat ~= 'PVP' and cat ~= 'PVE')) then

			if (iFilger_Spells[cat]) then

				for i = 1, (#iFilger_Spells[cat]) do

					if (iFilger_Spells[cat][i].Enable) then				-- merge similar spell-list (compare using Name and merge / flag set) otherwise add another spell-list

						loading = true

						local merge = false
						local spellListAll = iFilger_Spells[cat][i]
						local enable = spellListAll
						local spellListClass = nil

						for j = 1, #iFilger['spells'] do
							spellListClass = iFilger['spells'][j]

							local mergeAll = spellListAll.Merge or false
							local mergeClass = spellListClass.Merge or false

							if (spellListClass.Name == spellListAll.Mergewith) and ( mergeAll or mergeClass) then
								merge = true
								break
							end
						end

						if (( not merge or spellListClass == nil )) then
							-- Add another spell list
							table.insert(iFilger['spells'], iFilger_Spells[cat][i])
						else
							for j = 1, #spellListAll do
								table.insert( spellListClass, spellListAll[j] )
							end
						end
					end
				end

				if (loading) then
					loaded  = loaded .. ' ' .. cat
					loading = false
				end

			end
		end
	end

	I.Print('modules loaded :' .. loaded)
end

--==============================================--
-- Cleaning spell list. Credits to SinaC
--==============================================--
function iFilger:CleanSpellList ()
--~  Remove invalid spell and empty tables

	local data
	local idx = {}

	for i = 1, (#iFilger['spells']) do

		local spn
		local jdx = {}

		data = iFilger['spells'][i]


		for j = 1, (#data) do

			if ((data[j].spellID)) then
				spn = GetSpellInfo(data[j].spellID)
			else
				local slotLink = GetInventoryItemLink('player', data[j].slotID)
				if ((slotLink)) then
					spn = GetItemInfo(slotLink)
				end
			end

			if ((not spn and not data[j].slotID)) then -- Warning only for spell, not for trinket
				I.Print('WARNING - BAD spell/slot ID -> '.. (data[j].spellID or data[j].slotID or 'UNKNOWN') ..' !')
				table.insert(jdx, j)
			end
		end

		for _, v in ipairs(jdx) do
			table.remove(data, v)
		end

		if (#data == 0) then
		--~	I.Print('WARNING - EMPTY section -> '..data.Name..' !')
			table.insert(idx, i)
		end
	end

	for _, v in ipairs(idx) do
		table.remove(iFilger['spells'], v)
	end
end

--==============================================--
-- Create frame spell list
--==============================================--
function iFilger:UpdatesFramesList ()

	if ((iFilger['spells'])) then

		-- create frame for each spell-list

		for i = 1, (#iFilger['spells']) do

			local data = iFilger['spells'][i]

			local f = CreateFrame('Frame', 'iFilgerFrame' .. i .. '_' .. data.Name, UIParent)

		  -- I.Print('FRAME CREATED:'..data.Name)

			f.Id = i
			f.Name = data.Name
			f.Direction = data.Direction or 'UP'
			f.IconSide = data.IconSide or 'LEFT'
			f.Interval = data.Interval or 3
			f.Mode = data.Mode or 'ICON'
			f.Size = data.Size or 20
			f.Alpha = data.Alpha or 1.0
			f.BarWidth = data.BarWidth or 200
			f.setPoint = data.setPoint or 'CENTER'
			f:SetWidth(data.Size or 20)
			f:SetHeight(data.Size or 20)
			f:SetPoint(unpack(data.setPoint) or 'CENTER')
			f:SetAlpha(data.Alpha or 1.0)
			f.updatetimes = {}
			f.timeSinceLastUpdate = 0

			f:SetScript('OnUpdate', function(self, elapsed)
				self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed

				local time = GetTime()
				local i,t, found

				if (self.timeSinceLastUpdate > 0.05 and #self.updatetimes ~= 0) then

					for i, value in pairs(self.updatetimes) do

						if (time > value.triggerwhen) then

							if (not self.actives) then
								self.actives = {}
							end

							if (not self.actives[i]) then
								self.actives[i] = {
									data = value.data,
									name = value.name,
									icon = value.icon,
									count = value.count,
									start = value.start,
									duration = value.duration,
									spid = value.spid,
								}

								-- SETGLOBAL
								-- needUpdate = true
							else
								if (self.actives[i].count ~= value.count)
								or (self.actives[i].start ~= value.start)
								or (self.actives[i].duration ~= value.duration) then
									self.actives[i].count = value.count
									self.actives[i].start = value.start
									self.actives[i].duration = value.duration
								end
							end

							self.updatetimes[i] = nil
						end

						iFilger.DisplayActives(self)
					end

					self.timeSinceLastUpdate = 0
				end
			end)

			-- check if bar + right or left => ugly !

			if  (data.Mode ~= 'ICON') and (f.Direction ~= 'DOWN') and (f.Direction ~= 'UP') then
				f.Direction = 'UP'
			end

			f:RegisterEvent('SPELL_UPDATE_COOLDOWN')
			f:RegisterEvent('SPELL_UPDATE_USABLE')
			f:RegisterEvent('PLAYER_FOCUS_CHANGED')
			f:RegisterEvent('PLAYER_TARGET_CHANGED')
			f:RegisterEvent('UNIT_AURA')
			f:RegisterEvent('PLAYER_ENTERING_WORLD')
			f:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')

			f:SetScript('OnEvent', iFilger.OnEvent)

			iFilger['frame_list'][i] = f
		end
	end
end

--==============================================--
-- checkzone for clever zone check
--==============================================--
function iFilger:checkzone()
	if (iFilger_Config.cleverzone) then

		local inInstance, instanceType = IsInInstance()

		if (inInstance and (instanceType == 'raid' or instanceType == 'party')) then
			iFilger:UpdateSpellList('pve')
		else
			iFilger:UpdateSpellList('pvp')
		end
	else
		iFilger:UpdateSpellList('config')
	end

	iFilger:CleanSpellList()
	iFilger:UpdatesFramesList()
end

iFilger:checkzone()

--==============================================--
-- configuration mode
--==============================================--
local function exec(self, enable)
	if (enable) then
		self:Show()
	else
		self:Hide()
	end
end

local enable = true
local origa1, origf, origa2, origx, origy

local function moving()
--~	Prevent movement during combat

	if (InCombatLockdown()) then
		print(ERR_NOT_IN_COMBAT)
		return
	end

	for i = 1, (#iFilger['spells']) do

		local f = iFilger['frame_list'][i]
		local data = iFilger['spells'][i]

		f.actives = {}
		iFilger.DisplayActives(f)

		if (enable) then
			for j = 1, math.min(4, #iFilger['spells'][i]) do

				local data = iFilger['spells'][i][j]
				local name, icon

				if (data.spellID) then
					name, _, icon = GetSpellInfo(data.spellID)

				elseif (data.slotID) then
					local slotLink = GetInventoryItemLink('player', data.slotID)

					if (slotLink) then
						name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink)
					end
				end

				f.actives[j] = {
					data = data,
					name = name,
					icon = icon,
					count = 9,
					start = 0,
					duration = 0,
					spid = data.spellID or data.slotID
				}
			end
		end

		iFilger.DisplayActives(f)
	end


	for i = 1, (#I.MoverFrames) do

		if (I.MoverFrames[i]) then

			if (enable) then
				I.MoverFrames[i]:EnableMouse(true)
				I.MoverFrames[i]:RegisterForDrag('LeftButton', 'RightButton')
				I.MoverFrames[i]:SetScript('OnDragStart', function(self)
					origa1, origf, origa2, origx, origy = I.MoverFrames[i]:GetPoint()
					self.moving = true

					self:SetUserPlaced(true)
					self:StartMoving()
				end)

				I.MoverFrames[i]:SetScript('OnDragStop', function(self)
					self.moving = false
					self:StopMovingOrSizing()
				end)

				exec(I.MoverFrames[i], enable)

				if (I.MoverFrames[i].text) then
					I.MoverFrames[i].text:Show()
				end
			else
				I.MoverFrames[i]:EnableMouse(false)

				if (I.MoverFrames[i].moving == true) then
					I.MoverFrames[i]:StopMovingOrSizing()
					I.MoverFrames[i]:ClearAllPoints()
					I.MoverFrames[i]:SetPoint(origa1, origf, origa2, origx, origy)
				end

				exec(I.MoverFrames[i], enable)

				if (I.MoverFrames[i].text) then I.MoverFrames[i].text:Hide() end

				I.MoverFrames[i].moving = false
			end
		end
	end

	if (enable) then
		enable = false
	else
		enable = true
	end
end




local prot = CreateFrame('Frame')
prot:RegisterEvent('PLAYER_REGEN_DISABLED')
prot:SetScript('OnEvent', function(self, event)
	if (enable) then return end
	print(ERR_NOT_IN_COMBAT)
	enable = false
	moving()
end)


SlashCmdList["IFILGER_MOVE"] = moving

SLASH_IFILGER_MOVE1 = '/mifilger'
SLASH_IFILGER_MOVE2 = '/moveifilger'



-- Reset movable stuff into original position
SlashCmdList["IFILGER_RESET"] = function()
	for i = 1, (#I.MoverFrames) do
		if (I.MoverFrames[i]) then
			I.MoverFrames[i]:SetUserPlaced(false)
		end
	end

	ReloadUI()
end
SLASH_IFILGER_RESET1 = '/rifilger'
SLASH_IFILGER_RESET2 = '/resetifilger'
