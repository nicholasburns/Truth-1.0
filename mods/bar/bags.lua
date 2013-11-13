-- Credit: Elkano | _AllBags | Bags_and_Merchants (Curse name)
-- Opens/Closes all bags when at merchant (instead of only the backpack)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Bar"]["Bags"]["Enable"]) then return end
local print = function(...) Addon.print('bags', ...) end

local P  = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']


local bags = CreateFrame('Frame', 'TruthBags')


local MY_EVENT_TRACE_CAPTURE = {
	["ITEM_LOCK_CHANGED"]	= true,
	["ITEM_LOCKED"]		= true,
	["SOCKET_INFO_UPDATE"]	= true,
	  --
	["ITEM_LOCK_CHANGED"]	= true,
	["ITEM_UNLOCKED"]		= true,
	["SOCKET_INFO_CLOSE"]	= true,
}


local events_showbags = {
	["AUCTION_HOUSE_SHOW"] = true,
	["BANKFRAME_OPENED"] = true,
	["GUILDBANKFRAME_OPENED"] = true,
	["MAIL_SHOW"] = true,
	["MERCHANT_SHOW"] = true,
	["TRADE_SHOW"] = true,

	["SOCKET_INFO_UPDATE"] = true,			-- gem socketing
}

local events_closebags = {
	["AUCTION_HOUSE_CLOSED"] = true,
	["BANKFRAME_CLOSED"] = true,
	["GUILDBANKFRAME_CLOSED"] = true,
	["MAIL_CLOSED"] = true,
	["MERCHANT_CLOSED"] = true,
	["TRADE_CLOSED"] = true,

	["SOCKET_INFO_CLOSE"] = true,				-- gem socketing
}

local events_bank = {
	["BANKFRAME_OPENED"] = true,
	["BANKFRAME_CLOSED"] = true,
}



for event in pairs(events_showbags) do
	bags:RegisterEvent(event)
end
for event in pairs(events_closebags) do
	bags:RegisterEvent(event)
end


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
