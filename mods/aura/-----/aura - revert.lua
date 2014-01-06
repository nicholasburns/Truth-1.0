local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Aura"]["Aura"]["Enable"]) then return end
local print = function(...) Addon.print('aura', ...) end
local select = select
local UIParent = UIParent
local PlayerFrame = PlayerFrame
local CreateFrame = CreateFrame
local CreateTexture = CreateTexture
local CreateFontString = CreateFontString
local GetSpellInfo = GetSpellInfo
local UnitBuff = UnitBuff

--==============================================--
--	Addon
--==============================================--
local TruAuras = CreateFrame('Frame', "TruAuras", UIParent)
TruAuras:SetPoint('TOPRIGHT', UIParent, 'CENTER', -100, -50)
TruAuras:SetSize(40, 40)
TruAuras:Template('DEFAULT')
-- TruAuras:RegisterEvent('PLAYER_ENTERING_WORLD')	-- TruAuras:RegisterEvent('UNIT_AURA')	-- T.MakeMovable(TruAuras, 'HIGH')
-- TruAura:SetScript('OnEvent', OnEvent)

--==============================================--
--	Filger Config / Spells.lua
--==============================================--
local filger = {
	["ROGUE"] = {

		-- Player Buffs
		[1] = {
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = 37,
			Position = {'CENTER'},

			-- Slice and Dice
			{spellID = 5171, unitID = "player", caster = "player", filter = "BUFF"},
			-- Recuperate
			{spellID = 73651, unitID = "player", caster = "player", filter = "BUFF"},
			-- Adrenaline Rush
			{spellID = 13750, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadow Blades
			{spellID = 121471, unitID = "player", caster = "player", filter = "BUFF"},
			-- Evasion
			{spellID = 5277, unitID = "player", caster = "player", filter = "BUFF"},
			-- Envenom
			{spellID = 32645, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadow Dance
			{spellID = 51713, unitID = "player", caster = "player", filter = "BUFF"},
			-- Master of Subtlety
			{spellID = 31665, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cloak of Shadows
			{spellID = 31224, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vanish
			{spellID = 1856, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combat Readiness
			{spellID = 74001, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combat Insight
			{spellID = 74002, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cheating Death
			{spellID = 45182, unitID = "player", caster = "player", filter = "BUFF"},
			-- Blade Flurry
			{spellID = 13877, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sprint
			{spellID = 2983, unitID = "player", caster = "player", filter = "BUFF"},
			-- Feint
			{spellID = 1966, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadow Walk
			{spellID = 114842, unitID = "player", caster = "player", filter = "BUFF"},
			-- Subterfuge
			{spellID = 115192, unitID = "player", caster = "player", filter = "BUFF"},
		},

		-- Player Procs
		[2] = {
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = 37,
			Position = {'CENTER'},

			-- Buffs
			{spellID = 115189, unitID = "player", caster = "player", filter = "BUFF"}, -- Anticipation

			-- Trinket
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"}, -- Bad Juju (Agility, Proc)
		},
	},
}

--

local TruAura = {}

local spells = {
	115189,	-- Anticipation
}

local actives = {}


--==============================================--
--	Utility
--==============================================--
local DesaturateIcon = function(f, bool)
	f.icon:SetDesaturated(bool) -- f.icon:SetDesaturated(true)
end

--==============================================--
--	Function
--==============================================--
function TruAura:OnLoad(self)
	local aura = CreateFrame('Frame', 'TruAnt', TruAuras) -- TruAnt = CreateFrame('Frame', "TruAnt")
	aura.name = GetSpellInfo(115189)
	aura:SetPoint('TOPLEFT', TruAuras, 5, -5)
	aura:SetPoint('BOTTOMRIGHT', TruAuras, -5, 5)
	aura:Template('DEFAULT')

	aura.icon = aura:CreateTexture('$parentIcon', 'BORDER')
	aura.icon:SetAllPoints()
	aura.icon:SetTexture(select(3, GetSpellInfo(115189)))
	aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	aura.icon:SetDesaturated(true)			-- DesaturateIcon(aura, true)						-- aura.icon:SetDesaturated(true)

	aura.cooldown = CreateFrame('Cooldown', '$parentCD', aura, 'CooldownFrameTemplate')
	aura.cooldown:SetAllPoints(aura)
	aura.cooldown:SetReverse()

	if (aura.count) then
		aura.count = _G[aura.count:GetName()]
	else
		aura.count = aura:CreateFontString('$parentCount', 'OVERLAY')
		aura.count:SetFont(Addon.default.pxfont[1], 20, 'OUTLINE')
		aura.count:SetPoint('BOTTOMRIGHT', -1, 1)
		aura.count:SetJustifyH('CENTER')
	end

	aura:RegisterEvent('UNIT_AURA')
end

local NewAura = function()
	for i = 1, (#spells) do

		local data = spells[i]
		local f = CreateFrame('Frame', 'TruAura' .. i .. '_' .. data.name, TruAuras)

	  -- print('FRAME CREATED:', data.Name)

		f.id = i
		f.name = data.Name
		f.size = data.size or 20
		f.alpha = data.alpha or 1.0
		f.point = data.point or 'CENTER'

		f:SetWidth(data.size or 20)
		f:SetHeight(data.size or 20)
		f:SetPoint(unpack(data.point) or 'CENTER')
		f:SetAlpha(data.alpha or 1.0)

		f.updatetimes = {}

		-- OnUpdate
		f.timeSinceLastUpdate = 0
		f:SetScript("OnUpdate", function(self, elapsed)
			self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed

			local time = GetTime()
			local i, t, found

			if (self.timeSinceLastUpdate > 0.05 and #self.updatetimes ~= 0) then

			end
		end)
	end
end

--==============================================--
--	Events
--==============================================--
function TruAuras:OnEvent(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then											-- self:UnregisterEvent(event) self:RegisterEvent('UNIT_AURA')
		TruAura:OnLoad()

	  -- CreateAnticipationFrame()
	end

	if (event == "UNIT_AURA") then
		local name, icon, count, duration, expiration, _									-- local _, name, dur, duration, expiration
		local exp = 0
		local dur

		for i = 1, 40 do

			name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
			if (not name) then return end


			if (name == Anticipation) then
				exp = expiration
				dur = duration

				if (dur > 0) then			-- obj:SetCooldown(start, duration [charges, maxCharges])
					CooldownFrame_SetTimer(self.cooldown, value.start, value.duration, 1)
					-- TruAnt.cooldown:SetCooldown(exp - dur - 0.5, dur - 0.5)				-- TruAnt.cooldown:SetText(count)
					-- TruAnt.cooldown:SetPoint('TOP', TruAuras, 'BOTTOM', 0, -10)
					self.icon:SetDesaturated(false)
				else
					self.icon:SetDesaturated(true)
				end

				if (count and (count > 0)) then	-- print("count", count)
					self.count:SetText(count)
				elseif (count and (count == 0)) then
					self.count:SetText("0")
				end

			end
		end
	end
end
TruAuras:SetScript('OnEvent', OnEvent)



--[[
local function OnLoad(self)
	self:SetBackdropBorderColor(ACHIEVEMENTUI_GOLDBORDER_R, ACHIEVEMENTUI_GOLDBORDER_G, ACHIEVEMENTUI_GOLDBORDER_B, ACHIEVEMENTUI_GOLDBORDER_A)
	self.buttons = {}

	self:RegisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", OnEvent)
end
TruAuras:SetScript('OnLoad', OnLoad)
--]]

--==============================================--
--	GetSpellInfo
--==============================================--
--[[		GetSpellInfo(spellId)
	name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId or spellName or spellLink)
--]]

--==============================================--
--	UnitBuff
--==============================================--
--[[		UnitBuff(unit, index or name, [filter])

@usage
	name, rank, icon, count, debuffType, duration, expiration, unitCaster, isStealable, consolidate, spellId = UnitBuff(unit, index or name, [filter])

@example
	UnitBuff("target", 1)							-- First buff on target
	UnitBuff("target", 1, "PLAYER")					-- First buff, cast by the player, on the target
	UnitBuff("player", "Lightning Shield")				-- First instance of "Lightning Shield" on the player
	UnitBuff("player", "Lightning Shield", nil, "PLAYER")	-- First instance of "Lightning Shield" on the player, cast by the player

@args
	unit 		String - The unit you want debuff information for
	index 		Number - The index of the debuff to retrieve info for. Starts at 1, maximum 40
	filter 		This parameter can be any of "PLAYER", "RAID", "CANCELABLE", "NOT_CANCELABLE"
				You can also specify several filters separated by a | or space character to chain multiple filters together
				(e.g. "CANCELABLE|RAID" or "CANCELABLE RAID" == cancelable buffs that you can cast on your raid)
@return
	name 		String  - The name of the spell or effect of the buff, or nil if no buff was found with the specified name or at the specified index.
						This is the name shown in yellow when you mouse over the icon.
	rank 		String  - The rank of the spell or effect that caused the buff. Returns "" if there is no rank.
	icon 		String  - The identifier of (path and filename to) the indicated buff.
	count 		Number  - The number of times the buff has been applied to the target.
	debuffType	String  - The magic type of the buff
	duration		Number  - The full duration of the buff in seconds
	expiration	Number  - Time the buff will expire in seconds
	source		String  - The unit that cast the buff
	isStealable	Boolean - 1 if it is stealable otherwise nil
	consolidate	Boolean - 1 if the buff should be placed in a buff consolidation box (usually long-term effects)
	spellId		Number  - spell ID of the aura.
	canApplyAura	Boolean - true if the player can apply the aura (not necessarily if the player DID apply the aura)
--]]

--==============================================--
--	SetCooldown
--==============================================--
--[[		Object:SetCooldown(start, duration [charges, maxCharges])

@args
	start	 (Number) - The time when the CD started (via GetTime()) - Zero if no CD
	duration	 (Number) - Cooldown duration in seconds - Zero if no CD
	charges 	 (Number) - amount of remaining charges on an ability
	maxCharges (Number) - maximum amount of charges on the ability

@example
	--------------------------------------------------------------------------------
	-- Guide: Create container frame, a texture and a cooldown frame to work with
	--------------------------------------------------------------------------------
	local myFrame = CreateFrame('Frame', nil, UIParent)
	myFrame:SetSize(80, 80)
	myFrame:SetPoint("CENTER")

	local myTexture = myFrame:CreateTexture()
	myTexture:SetAllPoints(myFrame)
	myTexture:SetTexture("Interface\\Icons\\Ability_Druid_TreeofLife")

	local myCooldown = CreateFrame("Cooldown", "myCooldown", myFrame)
	myCooldown:SetAllPoints(myFrame)

	---------------------------------------
	-- Then we display a 10s cooldown
	-- animation on the cooldown frame:
	---------------------------------------
	myCooldown:SetCooldown(GetTime(), 10)

	---------------------------------------
	-- To display a 20s cooldown
	-- animation which started 5s ago:
	---------------------------------------
	myCooldown:SetCooldown(GetTime() - 5, 20)

	---------------------------------------
	-- To reset the cooldown animation and
	-- display the "CD finished" flash:
	---------------------------------------
	myCooldown:SetCooldown(0, 0)

	---------------------------------------
	-- To set the animation according to
	-- the CD of a spell in the spellbook:
	---------------------------------------
	local start, duration = GetSpellCooldown(Spell Name)
	myCooldown:SetCooldown(start, duration)
--]]


--==============================================--
--	Backup
--==============================================--
--[[ 12.03 | 01.06 AM
TruAuras:SetScript('OnEvent', function(self, event, ...)
	if (event == 'PLAYER_ENTERING_WORLD') then CreateAnticipationFrame() end
	if (event == 'UNIT_AURA') then
		local name, icon, count, duration, expiration, _									-- local _, name, dur, duration, expiration
		local exp = 0
		local dur

		for i = 1, 40 do
			name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
			if (not name) then return end

			if (name == Anticipation) then
				exp = expiration
				dur = duration

				if (dur > 0) then
				  -- obj:SetCooldown(start, duration [charges, maxCharges])
					TruAnt.cooldown:SetCooldown(exp - dur - 0.5, dur - 0.5)
				end

				if (not count) then
					TruAnt.text = TruAnt:CreateFontString(nil, 'OVERLAY')
					TruAnt.text:SetFont(Addon.default.font[1], Addon.default.font[2], Addon.default.font[3])
					-- TruAnt:SetText("0")
				elseif (count > 1) then
					TruAnt.text = TruAnt:CreateFontString(nil, 'OVERLAY')
					TruAnt.text:SetFont(Addon.default.font[1], Addon.default.font[2], Addon.default.font[3])
					-- TruAnt:SetText(count)
				end
			end
		end
	end
end)
--]]


--==============================================--
--	Events
--==============================================--
--[=[ 12.02 | 11.00 PM
local function OnEvent(self, event, ...)
	if (event == 'PLAYER_ENTERING_WORLD') then

		TruAnt = CreateFrame('Frame', "TruAnt", TruAuras)
	  -- TruAnt = CreateFrame('Frame', "TruAnt")
		TruAnt.name = GetSpellInfo(115189)

		TruAnt.icon = TruAnt:CreateTexture(nil, 'BORDER')
		TruAnt.icon:SetAllPoints()
		TruAnt.icon:SetTexture(select(3, GetSpellInfo(115189)))

		TruAnt.cooldown = CreateFrame('Cooldown', nil, TruAnt)
		TruAnt.cooldown:SetAllPoints(TruAnt)

		TruAnt.text = TruAnt:CreateFontString(nil, 'OVERLAY')
		TruAnt.text:SetFont(Addon.default.font[1], Addon.default.font[2], Addon.default.font[3])

		TruAnt:SetPoint('TOPRIGHT', UIParent, 'CENTER', -100, -50)
	  -- TruAnt:SetPoint('TOPRIGHT', PlayerFrame, -3, 13)
		TruAnt:SetSize(26, 26)
	  -- TruAnt:SetSize(20, 20)

		-- self:UnregisterEvent(event)
		-- self:RegisterEvent('UNIT_AURA')
	end

	if (event == 'UNIT_AURA') then

		local name, icon, count, duration, expiration, _									-- local _, name, dur, duration, expiration
		local exp = 0
		local dur

		for i = 1, 40 do

			name, _, icon, count, _, duration, expiration = UnitBuff('player', i)
			if (not name) then return end


			if (name == Anticipation) then
				exp = expiration
				dur = duration

				if (dur > 0) then
					TruAnt.cooldown:SetCooldown(exp - dur - 0.5, dur - 0.5) --[[ obj:SetCooldown(start, duration [charges, maxCharges]) ]]
				end
			end
		end
	end

end

TruAuras:SetScript('OnEvent', OnEvent)
--]=]

--[[		GetSpellCooldown(spellName or spellID or slotID, "bookType")

	start, duration, enabled = GetSpellCooldown(spellName or spellID or slotID, "bookType")

@args
	spellName (String) - name of the spell to retrieve CD data
	spellID 	(Number) - ID of the spell in the database
	slotID 	(Number) - Valid values are 1 through total number of spells in the spellbook on all pages and all tabs, ignoring empty slots
	bookType 	(String) - BOOKTYPE_SPELL or BOOKTYPE_PET depending on whether you wish to query the player or pet spellbook

@return
	startTime	(Number) - The time when the cooldown started (as returned by GetTime())
					 Zero if no cooldown
					 CurrentTime if (enabled == 0)
	duration	(Number) - Cooldown duration in seconds, 0 if spell is ready to be cast
	enabled	(Number) - 0 if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc)
					 & the CD will begin as soon as the spell is used/cancelled; 1 otherwise


@example1
		local start, duration, enabled = GetSpellCooldown('Presence of Mind')

		if (enabled == 0) then
			DEFAULT_CHAT_FRAME:AddMessage('POM is currently active, use it & wait ' .. duration .. ' seconds to try again')
		elseif (start > 0 and duration > 0) then
			DEFAULT_CHAT_FRAME:AddMessage('POM is cooling down, wait ' .. (start + duration - GetTime()) .. ' more seconds')
		else
			DEFAULT_CHAT_FRAME:AddMessage('POM is ready')
		end
@return
		Checks status of the POM CD & outputs the appropriate msg to chat

@example2
		local start, duration, enabled = GetSpellCooldown(48505)

@return
		0, 0, 1 			- if the spell 'Starfall' is not on CD
		GetTime(), 90, 1 	- if 'Starfall' IS on CD
--]]

--==============================================--
--	Rogue Spells
--==============================================--
--[[		local snd 		= GetSpellInfo(5171) 	-- Slice and Dice
		local TruAnt	= GetSpellInfo(73651)	-- recuperateuperate
		local SHD 		= GetSpellInfo(51713)	-- Shadow Dance
		local EVA 		= GetSpellInfo(5277) 	-- Evasion
		local SPR 		= GetSpellInfo(2983) 	-- Sprint
		local CR  		= GetSpellInfo(74001)	-- Combat Readiness
		local COS 		= GetSpellInfo(31224)	-- Cloak of Shadows
		local TOT 		= GetSpellInfo(57934)	-- Tricks of the Trade
		local BF  		= GetSpellInfo(13877)	-- Blade Flurry
		local RUP 		= GetSpellInfo(   )		-- Rupture << debuff >>
--]]

--[[		73651 - TruAnt
		5171  - Slice and Dice
		57934 - Tricks of the Trade
		51713 - Shadow Dance
		5277  - Evasion
		2983  - Sprint
		74001 - Combat Readiness
		31224 - Cloak of Shadows
		13877 - Blade Flurry (COMBAT)
--]]

--============================================================================--

--	RogueTrackerX  (original version)

--============================================================================--

--[[	local RECUP = GetSpellInfo(73651)
	local SLICE = GetSpellInfo(5171)

	local function UpdateX(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD") then
			---------------------------------------
			--	TruAnt
			---------------------------------------
			REC = CreateFrame('Frame')
			REC:SetPoint("TOPRIGHT", PlayerFrame, -3, 13)
			REC:SetSize(26, 26)

			REC.c = CreateFrame("Cooldown", "RC", REC.t)
			REC.c:SetAllPoints(REC)

			REC.t = REC:CreateTexture(nil, 'BORDER')
			REC.t:SetAllPoints()
			REC.t:SetTexture("Interface\\Icons\\ability_rogue_recuperate")

			---------------------------------------
			--	SliceDice
			---------------------------------------
			SND = CreateFrame('Frame')
			SND:SetPoint("TOPRIGHT", PlayerFrame, -29, 13)
			SND:SetSize(26, 26)

			SND.c = CreateFrame("Cooldown", "SN", SND.t)
			SND.c:SetAllPoints(SND)

			SND.t = SND:CreateTexture(nil, 'BORDER')
			SND.t:SetAllPoints()
			SND.t:SetTexture("Interface\\Icons\\ability_rogue_slicedice")
		end

		if (event == "UNIT_AURA") then
			local maxx = 0
			local _, name, d, D, x

			for i = 1, 40 do
				name, _, icon, _, _, d, x = UnitBuff("player", i)
				if (not name) then break end

				if (name == RECUP) then
					maxx = x
					D = d
					if (D > 0) then
						RC:SetCooldown(maxx - D - 0.5, D)
					end
				elseif (name == SLICE) then
					maxx = x
					D = d

					if (D > 0) then
						SN:SetCooldown(maxx - D - 0.5, D)
					end
				end
			end
		end
	end

	RogueTrackerX:RegisterEvent("PLAYER_ENTERING_WORLD")
	RogueTrackerX:RegisterEvent("UNIT_AURA")
	RogueTrackerX:SetScript("OnEvent", UpdateX)
--]]
--============================================================================--

--[==[
	local function RogueRecuperate()
		local TruAnt = CreateFrame('Frame', 'TruAnt', UIParent)
		TruAnt:SetPoint('TOPRIGHT', PlayerFrame, -3, 13)
		TruAnt:SetSize(20, 20)

		TruAnt.name = GetSpellInfo(73651)

		TruAnt.texture = TruAnt:CreateTexture(nil, 'BORDER')
		TruAnt.texture:SetAllPoints(TruAnt)
		TruAnt.texture:SetTexture(select(3, GetSpellInfo(73651)))

		TruAnt.cooldown = CreateFrame('Cooldown', nil, TruAnt)
		TruAnt.cooldown:SetAllPoints(TruAnt)

		TruAnt:Hide()
	end
	local function RogueSliceDice()
		local SliceDice = CreateFrame('Frame', 'SliceDice', UIParent)
		SliceDice:SetPoint('TOPRIGHT', PlayerFrame, -29, 13)
		SliceDice:SetSize(20, 20)

		SliceDice.name = GetSpellInfo(5171)

		SliceDice.texture = SliceDice:CreateTexture(nil, 'BORDER')
		SliceDice.texture:SetAllPoints()
		SliceDice.texture:SetTexture(select(3, GetSpellInfo(5171)))

		SliceDice.cooldown = CreateFrame('Cooldown', nil, SliceDice)
		SliceDice.cooldown:SetAllPoints(SliceDice)

		SliceDice:Hide()
	end
	local function Update(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD") then
			RogueRecuperate()
			RogueSliceDice()
		end
		if (event == "UNIT_AURA") then
			local Expiration = 0
			local Duration, name, dur, exp, _

			for i = 1, 40 do
				name,_, icon,_,_, dur, exp = UnitBuff('player', i)

				if (not name) then break end

	--[[recup]]	if (name == TruAnt.name) then
					TruAnt:Show()

					-- local start, duration = GetSpellCooldown(TruAnt.name)
					-- TruAnt.cooldown:SetCooldown(start, duration)

					Duration = duration		-- Total spell duration
					Expiration = expiration	-- Time remaining

					if (Duration > 1) then
						TruAnt.cooldown:SetCooldown(Expiration - Duration - 0.5, Duration)
					else
						TruAnt:Hide()
					end

	--[[snd]]	 elseif (name == SliceDice.name) then
					SliceDice:Show()

					Expiration = expiration
					Duration = duration

					if (Duration > 0) then
						SliceDice.cooldown:SetCooldown(GetTime() - Expiration - 0.5, Duration)
						-- SliceDice.cooldown:SetCooldown(GetTime() - Expiration - Duration - 0.5, Duration)
					else
						SliceDice:Hide()
					end
				end
			end
		end
	end

	local BuffTracker = CreateFrame('Frame')
	BuffTracker:RegisterEvent('PLAYER_ENTERING_WORLD')
	BuffTracker:RegisterEvent('UNIT_AURA')
	BuffTracker:SetScript('OnEvent', Update)
--]==]