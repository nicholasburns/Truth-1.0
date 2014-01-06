-- credit: ShestakUI
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('author', ...) end
local ipairs = ipairs





--==============================================--
--	Auction Frame
--==============================================--
if (false) then
	local af = CreateFrame('Frame')
	af:RegisterEvent("ADDON_LOADED")
	af:SetScript('OnEvent', function(self, event, addon)
		if (addon == "Blizzard_AuctionUI") then

			local BrowseButtons = {
				BrowseBidButton,
				BidBidButton,
				BrowseBuyoutButton,
				BidBuyoutButton,
				BrowseCloseButton,
				BidCloseButton,
				BrowseSearchButton,
				AuctionsCreateAuctionButton,
				AuctionsCancelAuctionButton,
				AuctionsCloseButton,
				BrowseResetButton,
				AuctionsStackSizeMaxButton,
				AuctionsNumStacksMaxButton,
			}

		  -- AuctionFrame					-- 15
			AuctionFrame:Template()
			AuctionFrame:MakeMovable()

		  -- AuctionFrameBrowse				-- 16
		  -- T.Template(AuctionFrameBrowse)

		  -- Browse Buttons					-- 17
			for _, v in ipairs(BrowseButtons) do
				if (v) then
					v:SkinButton()
				end
			end

		  -- Fix Button Positions
			AuctionsCloseButton:Point("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
			AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)

			BidCloseButton:Point("BOTTOMRIGHT", AuctionFrameBid, "BOTTOMRIGHT", 66, 10)
			BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
			BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)

			BrowseCloseButton:Point("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 10)
			BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
			BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)
			BrowseResetButton:Point("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 81, -74)
			BrowseSearchButton:Point("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)

			AuctionsItemButton:Strip()
			AuctionsItemButton:StyleButton()
			AuctionsItemButton:Template('DEFAULT', true)

			AuctionsItemButton:SetScript("OnUpdate", function()
				if (AuctionsItemButton:GetNormalTexture()) then
					AuctionsItemButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
					AuctionsItemButton:GetNormalTexture():ClearAllPoints()
					AuctionsItemButton:GetNormalTexture():Point("TOPLEFT", 2, -2)
					AuctionsItemButton:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
				end
			end)


		  -- Filter Buttons					-- 17
			for i = 1, (NUM_FILTERS_TO_DISPLAY or 15) do
				local button = _G["AuctionFilterButton" .. i]
				if (button) then
					button:SkinButton()
				end
			end

		  -- Check Boxes
			IsUsableCheckButton:SkinCheckBox()
			ShowOnPlayerCheckButton:SkinCheckBox()

		  -- Tabs							-- AuctionFrameTab1-3
			for i = 1, (AuctionFrame.numTabs --[[ or 3]]) do
				local tab = _G["AuctionFrameTab" .. i]

				if (tab) then
					tab:SkinTab(true)
				end
			end

		  -- PrevNextButtons
			BrowsePrevPageButton:SkinPrevNextButton()
			BrowseNextPageButton:SkinPrevNextButton()

		  -- ScrollBar
			BrowseFilterScrollFrameScrollBar:SkinScrollBar()
			BrowseScrollFrameScrollBar:SkinScrollBar()
			AuctionsScrollFrameScrollBar:SkinScrollBar()
			BidScrollFrameScrollBar:SkinScrollBar()


		  -- Release Data Tables
			BrowseButtons = nil

		  -- Print Confirmation
		  -- print('AucutionFrame skinning is..:', 'complete')
		end
	end)
end



--==============================================--
--	Macro Frame
--==============================================--
do
	local mf = CreateFrame('Frame')
	mf:RegisterEvent("ADDON_LOADED")
	mf:SetScript('OnEvent', function(self, event, addon)
		if (addon == "Blizzard_MacroUI") then
			T.MakeMovable(MacroFrame)

			local MacroFrameButtons = {
				MacroEditButton,
				MacroSaveButton,
				MacroCancelButton,
				MacroExitButton,
				MacroNewButton,
				MacroDeleteButton,
			}

			for _, v in ipairs(MacroFrameButtons) do
				if (v) then
					v:SkinButton()
				else
					print('button:  '.. (v.GetName and v:GetName() or v), 'wtf')
				end
			end

			MacroFrameButtons = nil

		  -- print('MacroUI Skin:', 'complete')
		end
	end)
end

--==============================================--
--	Reforging Frame
--==============================================--
do
	local rf = CreateFrame('Frame')
	rf:RegisterEvent("ADDON_LOADED")
	rf:SetScript('OnEvent', function(self, event, addon)
		if (addon == "Blizzard_ReforgingUI") then
			T.MakeMovable(ReforgingFrame)
		end
	end)
end

--==============================================--
--	Spell Overlay Strata
--==============================================--
do
	SpellActivationOverlayFrame:SetFrameStrata("BACKGROUND")
end

--==============================================--
--	Force other warning
--==============================================--
do
	local PlaySound = PlaySound

	local warn = CreateFrame('Frame')
	warn:RegisterEvent("PARTY_INVITE_REQUEST")
	warn:RegisterEvent("CONFIRM_SUMMON")
	warn:SetScript('OnEvent', function(self, event)
		if (event == "PARTY_INVITE_REQUEST" or event == "CONFIRM_SUMMON") then
			PlaySound("ReadyCheck", "Master")
		end
	end)
end

--==============================================--
--	Auto SetFilter for AchievementUI
--==============================================--
--[[ Broken by Blizzard v5.4.0 (11.06.2013)

	do
		local AchievementFrame_SetFilter = AchievementFrame_SetFilter

		local filt = CreateFrame('Frame')
		filt:RegisterEvent("ADDON_LOADED")
		filt:SetScript('OnEvent', function(self, event, addon)
			if (addon == "Blizzard_AchievementUI") then
				AchievementFrame_SetFilter(3)
			end
		end)
	end
--]]

--==============================================--
--	Force quit
--==============================================--
--[[
do
	local ForceQuit = ForceQuit

	local quit = CreateFrame('Frame')
	quit:RegisterEvent("CHAT_MSG_SYSTEM")
	quit:SetScript('OnEvent', function(self, event, msg)
		if (event == "CHAT_MSG_SYSTEM") then
			if (msg and msg == IDLE_MESSAGE) then	-- IDLE_MESSAGE = "You have been inactive for some time and will be logged out of the game. If you wish to remain logged in, hit the cancel button."
				ForceQuit()
			end
		end
	end)
end
--]]

--==============================================--
--	Delete Replace Enchant popup
--==============================================--
do
	local ReplaceEnchant = ReplaceEnchant
	local StaticPopup_Hide = StaticPopup_Hide

	local ench = CreateFrame('Frame')
	ench:RegisterEvent("REPLACE_ENCHANT")
	ench:SetScript('OnEvent', function(self, event)
		if (event == "REPLACE_ENCHANT") then
			ReplaceEnchant()
			StaticPopup_Hide("REPLACE_ENCHANT")
		end
	end)
end

--==============================================--
--	Hide character controls
--==============================================--
-- CharacterModelFrameControlFrame:HookScript("OnShow", function(self) self:Hide() end)
-- DressUpModelControlFrame:HookScript("OnShow", function(self) self:Hide() end)
-- SideDressUpModelControlFrame:HookScript("OnShow", function(self) self:Hide() end)

--==============================================--
--	Hide subzone text
--==============================================--
-- SubZoneTextFrame:SetScript("OnShow", function() SubZoneTextFrame:Hide() end)

--==============================================--
--	Disable flash tab
--==============================================--
-- ChatTypeInfo.WHISPER = {sticky = 1, flashTab = false, flashTabOnGeneral = false}
-- ChatTypeInfo.BN_WHISPER = {sticky = 1, flashTab = false, flashTabOnGeneral = false}

--==============================================--
--	Switch resolution
--==============================================--
--[[
SlashCmdList.TRUTH_RESOLUTION = function()
	if (({GetScreenResolutions()})[GetCurrentResolution()] == "2560x1440") then
		SetCVar("gxWindow", 1)
		SetCVar("gxResolution", "1920x1080")
	else
		SetCVar("gxWindow", 0)
		SetCVar("gxResolution", "2560x1440")
	end
	RestartGx()
end

SLASH_TRUTH_RESOLUTION1 = "/reso"
--]]
--==============================================--
--	Hide stats from CharacterFrame
--	credit: Inomena by p3lim
--==============================================--
PAPERDOLL_STATCATEGORIES = {
	GENERAL = {
		id = 1,
		stats = {
			"ITEMLEVEL",
			"MOVESPEED",
		},
	},
	MELEE = {
		id = 2,
		stats = {
			"STRENGTH",
			"AGILITY",
			"MELEE_AP",
			"ENERGY_REGEN",
			"RUNE_REGEN",
			"HASTE",
			"CRITCHANCE",
			"HITCHANCE",
			"EXPERTISE",
			"MASTERY",
		},
	},
	RANGED = {
		id = 2,
		stats = {
			"AGILITY",
			"RANGED_AP",
			"RANGED_HASTE",
			"FOCUS_REGEN",
			"CRITCHANCE",
			"RANGED_HITCHANCE",
			"MASTERY",
		},
	},
	SPELL = {
		id = 2,
		stats = {
			"SPIRIT",
			"INTELLECT",
			"SPELLDAMAGE",
			"SPELLHEALING",
			"SPELL_HASTE",
			"MANAREGEN",
			"SPELLCRIT",
			"SPELL_HITCHANCE",
			"MASTERY",
		},
	},
	DEFENSE = {
		id = 3,
		stats = {
			"STAMINA",
			"ARMOR",
			"DODGE",
			"PARRY",
			"BLOCK",
			"RESILIENCE_REDUCTION",
			"PVP_POWER",
		},
	},
}


local orig  = PaperDoll_InitStatCategories
local class = select(3, UnitClass("player"))
local sort  = {
	[1] = {
		"GENERAL",
		"MELEE",
		"DEFENSE",
	},
	[2] = {
		"GENERAL",
		"RANGED",
		"DEFENSE",
	},
	[3] = {
		"GENERAL",
		"SPELL",
		"DEFENSE",
	},
}

local spec
local specs = {
	{1, 1, 1},
	{3, 1, 1},
	{2, 2, 2},
	{1, 1, 1},
	{3, 3, 3},
	{1, 1, 1},
	{3, 1, 3},
	{3, 3, 3},
	{3, 3, 3},
	{1, 3, 1},
	{3, 1, 1, 3},
}


local handler = CreateFrame('Frame')
handler:RegisterEvent("PLAYER_TALENT_UPDATE")
handler:SetScript('OnEvent', function()
	spec = GetSpecialization()
	if (spec) then
		PaperDoll_InitStatCategories = function()
			orig(sort[specs[class][spec]], nil, nil, "player")
			PaperDollFrame_CollapseStatCategory(CharacterStatsPaneCategory4)
		end
	end
end)


for index = 1, 3 do
	local toolbar = _G["CharacterStatsPaneCategory" .. index .. "Toolbar"]
	toolbar:SetScript("OnEnter", nil)
	toolbar:SetScript("OnClick", nil)
	toolbar:RegisterForDrag()
end


--==============================================--
--	Hooks
--==============================================--
do
	local setStat = PaperDollFrame_SetStat
	function PaperDollFrame_SetStat(self, unit, statIndex, ...)				-- function PaperDollFrame_SetStat(self, ...)
		if (statIndex == 1 and class ~= 6 and class ~= 2 and class ~= 1) then
			return self:Hide()
		end
		setStat(self, unit, statIndex, ...)							-- setStat(self, ...)
	end


	local setSpellHit = PaperDollFrame_SetSpellHitChance
	function PaperDollFrame_SetSpellHitChance(self, ...)
		if (class == 5 and spec ~= 3) then
			return self:Hide()
		elseif ((class == 11 or class == 7) and spec == 3) then
			return self:Hide()
		end

		setSpellHit(self, ...)
	end


	local setParry = PaperDollFrame_SetParry
	function PaperDollFrame_SetParry(self, ...)
		if (class ~= 2 and class ~= 1 and class ~= 6 and not (class == 10 and spec == 2)) then
			return self:Hide()
		end

		setParry(self, ...)
	end


	local setBlock = PaperDollFrame_SetBlock
	function PaperDollFrame_SetBlock(self, ...)
		if (class ~= 2 and class ~= 1) then
			return self:Hide()
		end

		setBlock(self, ...)
	end
end