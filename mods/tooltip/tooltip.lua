local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["Enable"]) then return end
local print = function(...) Addon.print('tooltip', ...) end
local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']

local pairs, select, unpack = pairs, select, unpack
local gsub, find, format, match = string.gsub, string.find, string.format, string.match


-- Locale
local L_CHAT_AFK = '<AFK>'
local L_CHAT_DND = '<DND>'




-- Addon
local TruthTip = CreateFrame('Frame', "TruthTip", UIParent)



local GameTooltip = _G['GameTooltip']
local GameTooltipStatusBar = _G['GameTooltipStatusBar']
local ItemRefTooltip = _G['ItemRefTooltip']

local Tooltips = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3,
	FriendsTooltip,
	ConsolidatedBuffsTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefShoppingTooltip3,
}
for _, Tooltip in pairs(Tooltips) do
--~  print('Tooltip: ', Tooltip:GetName())

	T.SkinTooltip(Tooltip)

	Tooltip:HookScript("OnShow", function(self)
		self:SetBackdropColor(unpack(Addon.default.overlay.color))
		self:SetBackdropBorderColor(unpack(Addon.default.border.color))
	end)
end

--==============================================--
--	Unit Classification
--==============================================--
local Classification = {
-- local Classification = UnitClassification(unit)
-- Returns the classification of the our unit:
	worldboss = "|cffAF5050Boss|r",
	rareelite = "|cffAF5050+ Rare|r",
	elite 	= "|cffAF5050+|r",
	rare 	= "|cffAF5050Rare|r",
}

--==============================================--
--	Anchor
--==============================================--
local anchor = CreateFrame("Frame", "TruthTooltipAnchor", UIParent)
anchor:SetSize(200, 40)
anchor:SetPoint('RIGHT', MultiBarLeft, 'LEFT', -20, 0)

--==============================================--
--	Text
--==============================================--
PVP_ENABLED = ""							-- Hide PvP Text
COALESCED_REALM_TOOLTIP = ""					-- Hide Realm Text			-- "Coalesced Realm (*)\nGroup, Whisper";
INTERACTIVE_REALM_TOOLTIP = ""				-- Hide Realm Text			-- "Interactive Realm (#)\nYou can interact with this player as if they were on your own realm";

--==============================================--
--	Cursor Anchor
--==============================================--
TargetFrameHealthBar:HookScript('OnEnter', function() GameTooltip:Hide() end)
TargetFrameManaBar:HookScript('OnEnter',   function() GameTooltip:Hide() end)

local GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor
function GameTooltip_SetDefaultAnchor(tooltip, parent)
	tooltip:SetOwner(parent, "ANCHOR_CURSOR")
end






























--==============================================--
--	Notes
--==============================================--
--[[ unitID

	player 			- Player
	pet 				- Player Pet
	vehicle 			- Player Vehicle; Must be CURRENTLY controlled by the player
	target 			- Player Target
	focus 			- Player Focus
	mouseover 		- Moused Unit
	none				- A valid unit TOKEN that always refers to NO UNIT
	npc 				- The unit the player is currently interacting with (Merchant, Trainer, Bank, etc); NOT necessarily an NPC

	party1	 (1-4)	- Another member of the player's party
	partypet1	 (1-4)	- A pet belonging to another member of the players party
	raid1	(1-40)	- A member of the players raid group
	raidpet1	(1-40)	- A pet belonging to a member of the players raid group
	boss1	 (1-4)	- The ACTIVE BOSSES of the current encounter
	arena1	 (1-5)	- A member of the OPPOSING TEAM in an Arena match

--]]

--==============================================--

	    if (not false) then return end

--==============================================--
--[=====[
local HealthBar = _G['GameTooltipStatusBar']
HealthBar:SetStatusBarTexture(Addon.default.statusbar.texture)
HealthBar:ClearAllPoints()
HealthBar:SetPoint('BOTTOMLEFT', HealthBar:GetParent(), 'TOPLEFT', 0, P[3])
HealthBar:SetPoint('BOTTOMRIGHT', HealthBar:GetParent(), 'TOPRIGHT', 0, P[3])
HealthBar:SetHeight(P[15])

T.Backdrop(HealthBar, 'TRANSPARENT')




--==============================================--
--	Update Tooltip
--==============================================--
local NeedBackdropBorderRefresh = true

local function UpdateTooltip(self)
	local owner = self:GetOwner()
	if (not owner) then return end

	if (self:GetAnchorType() == 'ANCHOR_CURSOR') then
		if (NeedBackdropBorderRefresh) then
			NeedBackdropBorderRefresh = false
			self:ClearAllPoints()
			self:SetBackdropColor(unpack(Addon.default.backdrop.color))

			if (not C["Tooltip"].cursor) then
				self:SetBackdropBorderColor(unpack(Addon.default.border.color))
			end
		end
	end

	local x = P[5]																	-- fix X-offset or Y-offset
	local ownername = owner:GetName()
	if (ownername and BuffFrame) then
		if (BuffFrame:GetPoint():match('LEFT') and (ownername:match(BuffFrame))) then
			self:SetAnchorType('ANCHOR_BOTTOMRIGHT', x, -x)
		end
	end

	if (self:GetAnchorType() == 'ANCHOR_NONE' and TruthTooltipAnchor) then
		local point = TruthTooltipAnchor:GetPoint()
		if (point == 'TOPLEFT') then
			self:ClearAllPoints()
			self:SetPoint('TOPLEFT', TruthTooltipAnchor, 'BOTTOMLEFT', 0, -x)
		elseif (point == 'TOP') then
			self:ClearAllPoints()
			self:SetPoint('TOP', TruthTooltipAnchor, 'BOTTOM', 0, -x)
		elseif (point == 'TOPRIGHT') then
			self:ClearAllPoints()
			self:SetPoint('TOPRIGHT', TruthTooltipAnchor, 'BOTTOMRIGHT', 0, -x)
		elseif (point == 'BOTTOMLEFT' or point == 'LEFT') then
			self:ClearAllPoints()
			self:SetPoint('BOTTOMLEFT', TruthTooltipAnchor, 'TOPLEFT', 0, x)
		elseif (point == 'BOTTOMRIGHT' or point == 'RIGHT') then
			self:ClearAllPoints()
			self:SetPoint('BOTTOMRIGHT', TruthTooltipAnchor, 'TOPRIGHT', 0, x)
		else
			self:ClearAllPoints()
			self:SetPoint('BOTTOM', TruthTooltipAnchor, 'TOP', 0, x)
		end
	end
end



--==============================================--
--	Default Anchor
--==============================================--
local function SetTooltipDefaultAnchor(self, parent)
	if (C["Tooltip"].cursor) then														-- if (C["Tooltip"].anchor.cursor) then
		if (parent ~= UIParent) then
			self:SetOwner(parent, 'ANCHOR_NONE')
		else
			self:SetOwner(parent, 'ANCHOR_CURSOR')
		end
	else
		self:SetOwner(parent, 'ANCHOR_NONE')
	end

	self:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -111111, -111111)						-- hack to update GameStatusBar instantly
end
hooksecurefunc('GameTooltip_SetDefaultAnchor', SetTooltipDefaultAnchor)
GameTooltip:HookScript('OnUpdate', function(self, ...) UpdateTooltip(self) end)



--==============================================--
--	Border Color
--==============================================--
local BorderColor = function(self)
	local GMF 		= GetMouseFocus()
	local unit 		= (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute('unit'))
	local Player		= unit and UnitIsPlayer(unit)
	local Reaction 	= unit and UnitReaction(unit, 'player')
  -- local tapped 		= unit and UnitIsTapped(unit)
  -- local tappedbyme 	= unit and UnitIsTappedByPlayer(unit)
  -- local connected 	= unit and UnitIsConnected(unit)
  -- local dead 		= unit and UnitIsDead(unit)
	local r, g, b


	T.SkinTooltip(self)

	if (Player) then
		local Class = select(2, UnitClass(unit))
		local Color = Addon.color.class[Class]
		r, g, b = Color[1], Color[2], Color[3]

		HealthBar:SetStatusBarColor(r, g, b)
		self:SetBackdropBorderColor(r, g, b)
		HealthBar.backdrop:SetBackdropBorderColor(r, g, b)

	elseif (Reaction) then
		local Color = Addon.color.reaction[Reaction]
		r, g, b = Color[1], Color[2], Color[3]

		self:SetBackdropColor(r * 0.2, g * 0.2, b * 0.2)
		self:SetBackdropBorderColor(r, g, b)

		HealthBar:SetStatusBarColor(r, g, b)
		HealthBar.backdrop:SetBackdropBorderColor(r, g, b)

	else
		local link = select(2, self:GetItem())
		local quality = link and select(3, GetItemInfo(link))

		if (quality and quality >= 2) then
			r, g, b = GetItemQualityColor(quality)
			self:SetBackdropBorderColor(r, g, b)
		else
			HealthBar:SetStatusBarColor(unpack(Addon.default.border.color))
			self:SetBackdropBorderColor(unpack(Addon.default.border.color))
			HealthBar.backdrop:SetBackdropBorderColor(unpack(Addon.default.border.color))
		end
	end

	NeedBackdropBorderRefresh = true									-- need this
end



--==============================================--
--	Events
--==============================================--
Addon:RegisterEvent('PLAYER_ENTERING_WORLD')
Addon:SetScript('OnEvent', function(self, event, addon)
	if (event == 'PLAYER_ENTERING_WORLD') then

		for _, tt in pairs(Tooltips) do
			tt:HookScript('OnShow', BorderColor)
		end

		ItemRefTooltip:HookScript('OnTooltipSetItem', BorderColor)
		ItemRefTooltip:HookScript('OnShow', BorderColor)

	  -- T.Template(FriendsTooltip)

	  -- self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	end
end)
--]=====]



--==============================================--
--	Backup
--==============================================--
--[[ Template Factory

local function Template(f, t)
	local backdropA = 0.9

	if (t == 'TRANSPARENT') then
		backdropA = 0.5
	end

	bA = backdropA

	f:SetBackdrop({
		bgFile 	= Addon.default.backdrop.texture,
		edgeFile 	= Addon.default.border.texture,
		edgeSize 	= px,
		insets 	= {left = -px, right = -px, top = -px, bottom = -px}})
	f:SetBackdropColor(bR, bG, bB, bA)
	f:SetBackdropBorderColor(eR, eG, eB, eA)
end
--]]

--[[ HealthBar Backdrop

	local HealthBar.backdrop = CreateFrame('Frame', '$parentBackground', HealthBar)
	HealthBar.backdrop:SetFrameLevel(HealthBar:GetFrameLevel() - 1)
	HealthBar.backdrop:SetPoint('TOPLEFT', -P[2], P[2])
	HealthBar.backdrop:SetPoint('BOTTOMRIGHT', P[2], -P[2])

	T.SkinFrame(HealthBar.backdrop, 'TRANSPARENT')
--]]


--==============================================--
--	Future
--==============================================--
--[[ DebugTools

local d = CreateFrame('Frame')
d:RegisterEvent('ADDON_LOADED')
d:SetScript('OnEvent', function(self, event, addon)
	if (addon ~= 'Blizzard_DebugTools') then return end

	print('<tt> Debug Tools')

	if (FrameStackTooltip) then
		FrameStackTooltip:SetScale(0.64)
		FrameStackTooltip:HookScript('OnShow', function(self) Template(self) end)
	end

	if (EventTraceTooltip) then
		EventTraceTooltip:HookScript('OnShow', function(self) Template(self) end)
	end
end)
--]]
