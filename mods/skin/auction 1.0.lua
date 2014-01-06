-- local _G = _G
--================================================================================================--
--[[
-- AuctionFrame
local AuctionFrame				     		= AuctionFrame
local AuctionFrameAuctions              		= AuctionFrameAuctions
local AuctionFrameBid                   		= AuctionFrameBid
local AuctionFrameBrowse                		= AuctionFrameBrowse
local AuctionFrameCloseButton           		= AuctionFrameCloseButton
local AuctionFrameTab1                  		= AuctionFrameTab1
local AuctionFrameTab2                  		= AuctionFrameTab2
local AuctionFrameTab3                  		= AuctionFrameTab3
-- AuctionProgress
local AuctionProgressBar                		= AuctionProgressBar
local AuctionProgressBarIcon            		= AuctionProgressBarIcon
local AuctionProgressBarText            		= AuctionProgressBarText
local AuctionProgressFrame              		= AuctionProgressFrame
local AuctionProgressFrameCancelButton  		= AuctionProgressFrameCancelButton
-- Auctions
local AuctionsCancelAuctionButton       		= AuctionsCancelAuctionButton
local AuctionsCloseButton               		= AuctionsCloseButton
local AuctionsCreateAuctionButton       		= AuctionsCreateAuctionButton
local AuctionsItemButton                		= AuctionsItemButton
local AuctionsNumStacksMaxButton        		= AuctionsNumStacksMaxButton
local AuctionsStackSizeMaxButton        		= AuctionsStackSizeMaxButton
local AuctionsScrollFrame               		= AuctionsScrollFrame
local AuctionsScrollFrameScrollBar				= AuctionsScrollFrameScrollBar
local AuctionsStackSizeEntry					= AuctionsStackSizeEntry
local AuctionsNumStacksEntry					= AuctionsNumStacksEntry
-- Big
local BidBuyoutButton                   		= BidBuyoutButton
local BidCloseButton                    		= BidCloseButton
local BidScrollFrame                    		= BidScrollFrame
local BidScrollFrameScrollBar					= BidScrollFrameScrollBar
-- BidBig
local BidBidButton                      		= BidBidButton
local BidBidPriceCopper                           = BidBidPriceCopper
local BidBidPriceSilver                           = BidBidPriceSilver
local BidBidPriceGold                             = BidBidPriceGold
-- Buyout
local BuyoutPriceCopper                           = BuyoutPriceCopper
local BuyoutPriceSilver                           = BuyoutPriceSilver
local BuyoutPriceGold                             = BuyoutPriceGold
-- Browse
local BrowseBidPriceCopper                        = BrowseBidPriceCopper
local BrowseBidPriceSilver                        = BrowseBidPriceSilver
local BrowseBidPriceGold                          = BrowseBidPriceGold
local BrowseFilterScrollFrame           		= BrowseFilterScrollFrame
local BrowseFilterScrollFrameScrollBar			= BrowseFilterScrollFrameScrollBar
local BrowseMinLevel                              = BrowseMinLevel
local BrowseMaxLevel                              = BrowseMaxLevel
local BrowseName                                  = BrowseName
local BrowseScrollFrame                 		= BrowseScrollFrame
local BrowseScrollFrameScrollBar				= BrowseScrollFrameScrollBar
-- StartPrice
local StartPriceCopper                            = StartPriceCopper
local StartPriceSilver                            = StartPriceSilver
local StartPriceGold                              = StartPriceGold
--==============================================--
--	Objects
--==============================================--
-- Dropdowns
local BrowseDropDown                    		= BrowseDropDown
local PriceDropDown                     		= PriceDropDown
local DurationDropDown                  		= DurationDropDown
-- Check Buttons
local IsUsableCheckButton               		= IsUsableCheckButton
local ShowOnPlayerCheckButton           		= ShowOnPlayerCheckButton
-- Buttons
local BrowseBuyoutButton                		= BrowseBuyoutButton
local BrowseBidButton                   		= BrowseBidButton
local BrowseCloseButton                 		= BrowseCloseButton
local BrowseResetButton                 		= BrowseResetButton
local BrowseSearchButton                		= BrowseSearchButton
-- PrevNexts
local BrowseNextPageButton              		= BrowseNextPageButton
local BrowsePrevPageButton              		= BrowsePrevPageButton
--]]
--================================================================================================--
--	Addon
--================================================================================================--
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('auction', ...) end
if (not C["Skin"]["Auction"]["Enable"]) then return end
local pairs = pairs
local CreateFrame = CreateFrame

--==============================================--
--	Globals			Blizzard_AuctionUI.lua
--==============================================--
--[[ NUM_BROWSE_TO_DISPLAY		= 8				--  8 | Total items visible at once for the default Browsing Window (Default: 8)
	NUM_BIDS_TO_DISPLAY			= 9				--  9 | Total items visible at once for the Biding Window (Default: 9)
	NUM_AUCTIONS_TO_DISPLAY		= 9				--  9 | Total items visible at once for the Auction Window (Default: 9)
	 --
	NUM_AUCTION_ITEMS_PER_PAGE	= 50				-- 50 | Total items listed, per page, that can be scrolled through
	NUM_FILTERS_TO_DISPLAY		= 15				-- 15 | Total filter buttons visible on left
	 --
	AUCTIONS_BUTTON_HEIGHT		= 37				-- 30
	BROWSE_FILTER_HEIGHT		= 20				-- 20 | Height of filter buttons on left
--]]

--==============================================--
--	Auction Frame
--==============================================--
do
	local af = CreateFrame('Frame')
	af:RegisterEvent("ADDON_LOADED")
	af:SetScript('OnEvent', function(self, event, addon)
		if (addon == "Blizzard_AuctionUI") then

			AuctionFrameCloseButton:SkinCloseButton()

			--==============================================--
			--	Auction Window
			--==============================================--
			AuctionFrame:Strip(true) -- (true)
			AuctionFrame:Template() -- ("TRANSPARENT")
			AuctionFrame:Shadow()
			AuctionFrame:MakeMovable()

			--==============================================--
			--	Scrollareas
			--==============================================--
			AuctionsScrollFrame:Strip()
			BidScrollFrame:Strip()
			BrowseFilterScrollFrame:Strip()
			BrowseScrollFrame:Strip()

			--==============================================--
			--	Dropdowns
			--==============================================--
			BrowseDropDown:SkinDropDownBox()
			PriceDropDown:SkinDropDownBox()
			DurationDropDown:SkinDropDownBox(200) -- (80)

			--==============================================--
			--	Checkboxes
			--==============================================--
			IsUsableCheckButton:SkinCheckBox()
			ShowOnPlayerCheckButton:SkinCheckBox()

			--==============================================--
			-- Dress Up Frame
			--==============================================--
			do
				local frame = _G["SideDressUpFrame"]
				local reset = _G["SideDressUpModelResetButton"]
				local close = _G["SideDressUpModelCloseButton"]
				local left  = _G["SideDressUpFrameModelRotateLeftButton"]
				local right = _G["SideDressUpFrameModelRotateRightButton"]

				frame:HookScript("OnShow", function(self) self:Strip() frame:Template() end)
				frame:ClearAllPoints()
				frame:SetPoint("TOPLEFT", AuctionFrame, "TOPRIGHT", 16, 0)

				reset:SkinButton()
				close:Strip()
				close:SkinCloseButton()

				if (left and right) then
					left:SkinRotateButton()
					right:SkinRotateButton()
					right:SetPoint("TOPLEFT", left, "TOPRIGHT", 4, 0)
				end
			end

			--==============================================--
			-- Progress Frame
			--==============================================--
			AuctionProgressFrame:Strip()
			AuctionProgressFrame:Template("TRANSPARENT")
			AuctionProgressFrame:Shadow()

			AuctionProgressFrameCancelButton:StyleButton()
			AuctionProgressFrameCancelButton:Template()
			AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
			AuctionProgressFrameCancelButton:GetNormalTexture():ClearAllPoints()
			AuctionProgressFrameCancelButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			AuctionProgressFrameCancelButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
			AuctionProgressFrameCancelButton:SetSize(28, 28)
			AuctionProgressFrameCancelButton:SetPoint("LEFT", AuctionProgressBar, "RIGHT", 8, 0)

			AuctionProgressBarIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)		-- SUI
		  -- AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)	-- TUK

			local backdrop = CreateFrame("Frame", "$parentBackdrop", AuctionProgressBarIcon:GetParent())
			backdrop:SetPoint("TOPLEFT", AuctionProgressBarIcon, "TOPLEFT", -2, 2)
			backdrop:SetPoint("BOTTOMRIGHT", AuctionProgressBarIcon, "BOTTOMRIGHT", 2, -2)
			backdrop:Template()

			AuctionProgressBarIcon:SetParent(backdrop)

			AuctionProgressBarText:ClearAllPoints()
			AuctionProgressBarText:SetPoint("CENTER")

			AuctionProgressBar:Strip()
			AuctionProgressBar:Backdrop()
			AuctionProgressBar:SetStatusBarTexture(Addon.default.statusbar.texture)
			AuctionProgressBar:SetStatusBarColor(1, 1, 0)

			--==============================================--
			--	Buttons
			--==============================================--
			local Buttons = {
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

			for _, button in pairs(Buttons) do
				button:SkinButton()
			end

			AuctionsCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
			AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)
			--
			BidCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBid, "BOTTOMRIGHT", 66, 10)
			BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -4, 0)
			BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -4, 0)
			--
			BrowseResetButton:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 10, -74)

			BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 10)
			BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
			BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)
			--
			AuctionsItemButton:Strip()
			AuctionsItemButton:StyleButton()
			AuctionsItemButton:Template()
			AuctionsItemButton:SetScript("OnUpdate", function()
				if (AuctionsItemButton:GetNormalTexture()) then
					AuctionsItemButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
					AuctionsItemButton:GetNormalTexture():ClearAllPoints()
					AuctionsItemButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
					AuctionsItemButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
				end
			end)

			-- PrevNext
			BrowseNextPageButton:SkinPrevNextButton()
			BrowseNextPageButton:ClearAllPoints()
			BrowseNextPageButton:SetPoint("TOPRIGHT", AuctionFrameBrowse"TOPRIGHT", -10, -40)

			BrowseSearchButton:ClearAllPoints()
			BrowseSearchButton:SetPoint("RIGHT", BrowseNextPageButton, "LEFT", -10, 0)

			BrowsePrevPageButton:SkinPrevNextButton()
			BrowsePrevPageButton:ClearAllPoints()
			BrowsePrevPageButton:SetPoint("RIGHT", BrowseSearchButton, "LEFT", -10, 0)

			--==============================================--
			--	Tabs
			--==============================================--
			local sorttabs = {
				"BrowseQualitySort",
				"BrowseLevelSort",
				"BrowseDurationSort",
				"BrowseHighBidderSort",
				"BrowseCurrentBidSort",
				"BidQualitySort",
				"BidLevelSort",
				"BidDurationSort",
				"BidBuyoutSort",
				"BidStatusSort",
				"BidBidSort",
				"AuctionsQualitySort",
				"AuctionsDurationSort",
				"AuctionsHighBidderSort",
				"AuctionsBidSort",
			}

			for _, sorttab in pairs(sorttabs) do
				_G[sorttab .. "Left"]:Kill()
				_G[sorttab .. "Middle"]:Kill()
				_G[sorttab .. "Right"]:Kill()
			end

			AuctionFrameTab1:ClearAllPoints()
			AuctionFrameTab1:SetPoint("TOPLEFT", AuctionFrame, "BOTTOMLEFT", -5, 2) -- Default-X,Y: 15,12

			for i = 1, (AuctionFrame.numTabs) do
				_G["AuctionFrameTab" .. i]:SkinTab()
			end

			for i = 1, (NUM_FILTERS_TO_DISPLAY) do
				local tab = _G["AuctionFilterButton" .. i]
				tab:Strip()
				tab:StyleButton()
			end

			--==============================================--
			--	Editboxes
			--==============================================--
			local Editboxs = {
				BrowseName,
				BrowseMinLevel,
				BrowseMaxLevel,
				BrowseBidPriceGold,
				BrowseBidPriceSilver,
				BrowseBidPriceCopper,
				BidBidPriceGold,
				BidBidPriceSilver,
				BidBidPriceCopper,
				AuctionsStackSizeEntry,
				AuctionsNumStacksEntry,
				StartPriceGold,
				StartPriceSilver,
				StartPriceCopper,
				BuyoutPriceGold,
				BuyoutPriceSilver,
				BuyoutPriceCopper,
			}

			for _, editbox in pairs(Editboxs) do
				editbox:SkinEditBox()
				editbox:SetTextInsets(2, 2, -2, 2) -- (1, 1, -1, 1)
			end

		  -- Name
			BrowseName:ClearAllPoints()
			BrowseName:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 10, -40)

		  -- Level Range
			BrowseMaxLevel:SetPoint("LEFT", BrowseMinLevel, "RIGHT", 12, 0) -- 8, 0)

		  -- Reset Button


		  -- Auctions
			AuctionsStackSizeEntry.backdrop:SetAllPoints()
			AuctionsNumStacksEntry.backdrop:SetAllPoints()


			--==============================================--
			--	Browser Window
			--==============================================--
			for i = 1, (NUM_BROWSE_TO_DISPLAY) do
				local button = _G["BrowseButton" .. i]
				local icon   = _G["BrowseButton" .. i .. "Item"]
				local hilite = _G["BrowseButton" .. i .. "Highlight"]

				if (_G["BrowseButton" .. i .. "ItemIconTexture"]) then
					_G["BrowseButton" .. i .. "ItemIconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					_G["BrowseButton" .. i .. "ItemIconTexture"]:ClearAllPoints()
					_G["BrowseButton" .. i .. "ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
					_G["BrowseButton" .. i .. "ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)
				end

				if (icon) then
					icon:StyleButton()
					icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
					icon:Backdrop()			-- icon.backdrop:SetAllPoints()
				end

				if (button) then
					button:Strip()
					button:StyleButton()
					hilite = button:GetHighlightTexture()								-- _G["BrowseButton" .. i .. "Highlight"] = button:GetHighlightTexture()
					button:GetHighlightTexture():ClearAllPoints()
					button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
					button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
					button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
				end
			end

			--==============================================--
			--	Auction Items
			--==============================================--
			for i = 1, (NUM_AUCTIONS_TO_DISPLAY) do
				local button = _G["AuctionsButton" .. i]
				local icon   = _G["AuctionsButton" .. i .. "Item"]
				local hilite = _G["AuctionsButton" .. i .. "Highlight"]

				_G["AuctionsButton" .. i .. "ItemIconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["AuctionsButton" .. i .. "ItemIconTexture"].SetTexCoord = A["Dummy"]
				_G["AuctionsButton" .. i .. "ItemIconTexture"]:ClearAllPoints()
				_G["AuctionsButton" .. i .. "ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
				_G["AuctionsButton" .. i .. "ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)

				icon:StyleButton()
				icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
				icon:Backdrop()				-- icon.backdrop:SetAllPoints()

				button:Strip()
				button:StyleButton()
				hilite = button:GetHighlightTexture()								-- _G["AuctionsButton" .. i .. "Highlight"] = button:GetHighlightTexture()
				button:GetHighlightTexture():ClearAllPoints()
				button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
				button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
			end

			--==============================================--
			--	Player Bids
			--==============================================--
			for i = 1, (NUM_BIDS_TO_DISPLAY) do
				local button = _G["BidButton" .. i]
				local icon   = _G["BidButton" .. i .. "Item"]
				local hilite = _G["BidButton" .. i .. "Highlight"]

				_G["BidButton" .. i .. "ItemIconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["BidButton" .. i .. "ItemIconTexture"]:ClearAllPoints()
				_G["BidButton" .. i .. "ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
				_G["BidButton" .. i .. "ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)

				icon:StyleButton()
				icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
				icon:Backdrop()				-- icon.backdrop:SetAllPoints()

				button:Strip()
				button:StyleButton()
				hilite = button:GetHighlightTexture()								-- _G["BidButton" .. i .. "Highlight"] = button:GetHighlightTexture()
				button:GetHighlightTexture():ClearAllPoints()
				button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
				button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
			end

			--==============================================--
			-- Custom Backdrops
			--==============================================--

			-- /outline AuctionFrameBrowseBackground1

			AuctionFrameBrowse.background1 = CreateFrame("Frame", "$parentBackground1", AuctionFrameBrowse)
			AuctionFrameBrowse.background1:Template("OVERLAY")
			AuctionFrameBrowse.background1:SetPoint("TOPLEFT", 10, -100)		-- 20, -103)
			AuctionFrameBrowse.background1:SetPoint("BOTTOMLEFT", 10, 40)		-- -575, 40)
			AuctionFrameBrowse.background1:SetWidth(300)
		  -- AuctionFrameBrowse.background1:SetPoint("BOTTOMRIGHT", -575, 40)
			BrowseFilterScrollFrame:SetHeight(300)												-- Adjust scrollbar slightly

			AuctionFrameBrowse.background2 = CreateFrame("Frame", "$parentBackground2", AuctionFrameBrowse)
			AuctionFrameBrowse.background2:Template("OVERLAY")
			AuctionFrameBrowse.background2:SetPoint("TOPLEFT", AuctionFrameBrowse.background1, "TOPRIGHT", 4, 0)
			AuctionFrameBrowse.background2:SetPoint("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -10, 40)		-- -8, 40)
			AuctionFrameBrowse.background2:SetFrameLevel(AuctionFrameBrowse.background2:GetFrameLevel() - 2)
			BrowseScrollFrame:SetHeight(300)													-- Adjust scrollbar slightly

			AuctionFrameBid.background = CreateFrame("Frame", "$parentBackground", AuctionFrameBid)
			AuctionFrameBid.background:Template("OVERLAY")
			AuctionFrameBid.background:SetPoint("TOPLEFT", 22, -72)
			AuctionFrameBid.background:SetPoint("BOTTOMRIGHT", 66, 39)
			AuctionFrameBid.background:SetFrameLevel(AuctionFrameBid.background:GetFrameLevel() - 2)
			BidScrollFrame:SetHeight(332)

			AuctionsScrollFrame:SetHeight(336)
			AuctionFrameAuctions.background1 = CreateFrame("Frame", "$parentBackground1", AuctionFrameAuctions)
			AuctionFrameAuctions.background1:Template("OVERLAY")
			AuctionFrameAuctions.background1:SetPoint("TOPLEFT", 15, -70)
			AuctionFrameAuctions.background1:SetPoint("BOTTOMRIGHT", -545, 35)
			AuctionFrameAuctions.background1:SetFrameLevel(AuctionFrameAuctions.background1:GetFrameLevel() - 2)

			AuctionFrameAuctions.background2 = CreateFrame("Frame", "$parentBackground2", AuctionFrameAuctions)
			AuctionFrameAuctions.background2:Template("OVERLAY")
			AuctionFrameAuctions.background2:SetPoint("TOPLEFT", AuctionFrameAuctions.background1, "TOPRIGHT", 3, 0)
			AuctionFrameAuctions.background2:SetPoint("BOTTOMRIGHT", AuctionFrame, -8, 35)
			AuctionFrameAuctions.background2:SetFrameLevel(AuctionFrameAuctions.background2:GetFrameLevel() - 2)

			--==============================================--
			--	Scrollbars
			--==============================================--
			BrowseFilterScrollFrameScrollBar:SkinScrollBar()
			BrowseScrollFrameScrollBar:SkinScrollBar()
			AuctionsScrollFrameScrollBar:SkinScrollBar()
			BidScrollFrameScrollBar:SkinScrollBar()

		end
	end)
end
