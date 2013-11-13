-- credit: InterruptAnnouncer (Hix [Trollbane] <Lingering>)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C.announce.interrupts.enable) then return end



--==============================================--
--	Anno Frame
--==============================================--
local Anno = CreateFrame('Frame') 													-- ('Frame', 'TruthInterrupts')
Anno:RegisterEvent('GROUP_ROSTER_UPDATE')
Anno:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
--[[
Anno:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
Mono:SetScript('OnEvent', function(self, event, ...) self[event](...) end)
QMA :SetScript('OnEvent', function(self, event, ...) if (self[event]) then self[event](self, ...) end end)
--]]


--==============================================--
--	Properties
--==============================================--
Anno.channel		= nil
Anno.GUID			= nil
Anno.lastTime		= nil
Anno.lastInterrupt	= nil
Anno.petGUID		= nil


--==============================================--
--	COMBAT_LOG_EVENT_UNFILTERED
--==============================================--
function Anno:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, _, sGUID, _,_,_,_, dName, _,_,_, spellName,_, spellID)

	-- Filter combat events
	if (sGUID ~= self.GUID) and (sGUID ~= self.petGUID) then return end
	if (event ~= 'SPELL_INTERRUPT') then return end
	if (timestamp == self.lastTime) and (spellID == self.lastInterrupt) then return end

	-- Update variables
	self.lastTime = timestamp
	self.lastInterrupt = spellID

	-- Send chat message
	SendChatMessage(format('%s - %s (%s)', spellName, GetSpellLink(spellID), dName), self.channel)
end


--==============================================--
--	GROUP_ROSTER_UPDATE
--==============================================--
function Anno:GROUP_ROSTER_UPDATE()

	local _, instanceType = IsInInstance()

	if (IsInActiveWorldPVP() or ((instanceType == 'pvp') and (not IsRatedBattleground()))) then -- or GetNumGroupMembers() == 0) then
  -- if (IsInActiveWorldPVP() or ((instanceType == 'pvp') and (not IsRatedBattleground())) or GetNumGroupMembers() == 0) then

		-- Unregister combat events
		self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		self:UnregisterEvent('UNIT_PET')

		-- Reset variables
		self.channel 		= nil
		self.GUID 		= nil
		self.lastTime 		= nil
		self.lastInterrupt	= nil
		self.petGUID		= nil

		return
	end

	-- Set channel for output
	if (GetNumGroupMembers() == 0) then
		self.channel = 'SAY'
	elseif (GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0) then
		self.channel = 'INSTANCE_CHAT'
	else
		self.channel = (IsInRaid() and 'RAID') or 'PARTY'
	end

--[[	-- Set channel for output
	if (GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0) then
		self.channel = 'INSTANCE_CHAT'
	else
		self.channel = (IsInRaid() and 'RAID') or 'PARTY'
	end
--]]
	if (self.GUID) then return end

	-- Collect GUIDs
	self.GUID = UnitGUID('player')
	self.petGUID = UnitGUID('pet')

	-- Register combat events
	self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:RegisterEvent('UNIT_PET')
end


--==============================================--
--	UNIT_PET
--==============================================--
function Anno:UNIT_PET(unit)
	if (unit ~= 'player') then return end
	if (not self.GUID) then return end

	-- Update pet GUID
	self.petGUID = UnitGUID('pet')
end