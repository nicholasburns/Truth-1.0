-- Credit: Elkano | _AllBags | Bags_and_Merchants (Curse name)
-- Opens/Closes all bags when at merchant (instead of only the backpack)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Bar"]["Bags"]["Enable"]) then return end
local print = function(...) Addon.print('bags', ...) end


--==============================================--
--	Addon Frame
--==============================================--
local bags = CreateFrame('Frame', 'TruthBags')



--==============================================--
--	Show Bags: Settings
--==============================================--
--[[	["EVENT"] = true	-->  "We want to ShowBags when ["EVENT"] is triggered"
	["EVENT"] = false	-->  "We DO NOT want to ShowBags when ["EVENT"] is triggered" ]]

local events_showbags = {

	["AUCTION_HOUSE_SHOW"] = true,
	["BANKFRAME_OPENED"] = true,
	["GUILDBANKFRAME_OPENED"] = true,
	["MAIL_SHOW"] = true,
	["MERCHANT_SHOW"] = true,
	["TRADE_SHOW"] = true,
	["SOCKET_INFO_UPDATE"] = true,			-- gem socketing
}


--==============================================--
--	Close Bags: Settings
--==============================================--
--[[	["EVENT"] = true	-->  "We want to CloseBags when ["EVENT"] is triggered"
	["EVENT"] = false	-->  "We DO NOT want to CloseBags when ["EVENT"] is triggered" ]]
local events_closebags = {
	["AUCTION_HOUSE_CLOSED"] = true,			-- closing the auction window
	["BANKFRAME_CLOSED"] = true,				-- closing the banking window
	["GUILDBANKFRAME_CLOSED"] = true,			-- closing the guild-banking window
	["MAIL_CLOSED"] = false,					-- closing the mail window
	["MERCHANT_CLOSED"] = true,				-- closing the merchant window
	["TRADE_CLOSED"] = true,					-- closing the trade window
	["SOCKET_INFO_CLOSE"] = true,				-- closing the gem socketing window
}


--==============================================--
--	Banking
--==============================================--
local events_bank = {
	["BANKFRAME_OPENED"] = true,
	["BANKFRAME_CLOSED"] = true,
}



--==============================================--
--	Events
--==============================================--
bags:SetScript("OnEvent", function(self, event)
	if (events_showbags[event]) then
		OpenAllBags(bags)

		if (events_bank[event]) then
			for i = NUM_BAG_FRAMES + 1, (NUM_CONTAINER_FRAMES) do
				OpenBag(i)
			end
		end
	end

	if (events_closebags[event]) then
		ContainerFrame1.backpackWasOpen = nil

		CloseAllBags(bags)

		if (events_bank[event]) then
			for i = NUM_BAG_FRAMES + 1, (NUM_CONTAINER_FRAMES) do
				CloseBag(i)
			end
		end
	end
end)

--==============================================--
--	Initialize
--==============================================--
for event in pairs(events_showbags) do
	bags:RegisterEvent(event)
end

for event in pairs(events_closebags) do
	bags:RegisterEvent(event)
end


--==============================================--
--	Backup
--==============================================--
--[[ Event Traces

	-- Opening the Socket Window: Events
	local SHIFT_R_CLICK = {
		["ITEM_LOCK_CHANGED"]	= true,
		["ITEM_LOCKED"]		= true,
		["SOCKET_INFO_UPDATE"]	= true,
	}

	-- Applying a New Gem: Events
	local APPLY_GEM_AND_ACCEPT = {
		["ITEM_LOCK_CHANGED"]	= true,
		["ITEM_UNLOCKED"]		= true,
		["SOCKET_INFO_CLOSE"]	= true,
	}

--]]

