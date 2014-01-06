local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Automation"]["Merchant"]["Enable"]) then return end
local print = function(...) Addon.print('merchant', ...) end



-- Properties
local count = 0
local toggle = 0
local startcash = GetMoney() or 0


--==============================================--
--	Events
--==============================================--
local f = CreateFrame('Frame')
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function(self, event, ...)

	--====================================--
	--	VENDOR WINDOW:  OPEN
	--====================================--
	if (event == "MERCHANT_SHOW") then
		count = 0
		startcash = GetMoney()

		for bag = 0, 4 do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)

				if (link and select(3, GetItemInfo(link)) == 0) then
					ShowMerchantSellCursor(1)
					UseContainerItem(bag, slot)

					count = count + 1
				end

			end
		end																		-- f:RegisterEvent("MERCHANT_CLOSED")

		-- self:RegisterEvent("MERCHANT_SHOW")

		local vendorstring = 'VendorTotal'
		local endcash = GetMoney()
		local gain = endcash - startcash

		if (gain == 0) then
			print(vendorstring, 'No items sold.')
		elseif (gain > 0) then
			print(vendorstring, GREEN_FONT_COLOR_CODE .. '+|r' .. GetCoinTextureString(gain))
		end


		--===============================--
		--	REPAIR ALL ITEMS
		--===============================--
		if (not CanMerchantRepair()) then return end

		local repairstring = 'Repairs'
		local availablemoney = GetMoney()
		local repaircost, canRepair = GetRepairAllCost()

		if (canRepair == 1) then														-- repairs are available (durability < 100%)
		  -- player can afford repairs
			if (repaircost <= availablemoney) then
				RepairAllItems(0)
				print(repairstring, RED_FONT_COLOR_CODE .. '-|r' .. GetCoinTextureString(repaircost))
		  -- player needs more gold for repairs
			else
				print(repairstring, ERR_NOT_ENOUGH_MONEY) 								-- ERR_NOT_ENOUGH_MONEY = "You don't have enough money."
			end
		else
		  -- no repairs needed
			if (repaircost <= 0) then
				print(repairstring, '0g')
			end
		end
	end
end)


--==============================================--
--	Backup
--==============================================--
--[[ --====================================--
	--	VENDOR WINDOW:  CLOSE
	--====================================--
	elseif (event == "MERCHANT_CLOSED") then
		local vendorstring = 'VendorTotal'
		local endcash = GetMoney()
		local gain = endcash - startcash

		if (gain == 0) then
			print(vendorstring, 'No items bought or sold.') 								-- f:UnregisterEvent("MERCHANT_CLOSED") return end
		elseif (gain < 0) then
			gain	= startcash - endcash
			print(vendorstring, RED_FONT_COLOR_CODE .. '-|r' .. GetCoinTextureString(gain))
		else
			print(vendorstring, GREEN_FONT_COLOR_CODE .. '+|r' .. GetCoinTextureString(gain))
		end
		f:UnregisterEvent("MERCHANT_CLOSED")
	end
end)
--]]
--[[ elseif (event == "MERCHANT_CLOSED") then
		local vendorstring = 'VendorTotal'
		local endcash = GetMoney()
		local gain = endcash - startcash
		if (gain == 0) then
			if (toggle == 0) then
				print(vendorstring, 'No items bought or sold.')
				toggle = 1
			else
				toggle = 0
			end
			return
		end
		if (gain < 0) then
			gain	= startcash - endcash
			print(vendorstring, RED_FONT_COLOR_CODE .. '-|r' .. GetCoinTextureString(gain))
		else
			print(vendorstring, GREEN_FONT_COLOR_CODE .. '+|r' .. GetCoinTextureString(gain))
		end
		f:UnregisterEvent("MERCHANT_CLOSED")
	end
--]]


--================================================================================================--

--	Reference

--================================================================================================--
--[=[ GetCoinText(10000)
	-- returns "1 Gold"

	GetCoinText(500050)
	-- returns "50 Gold, 50 Copper"

	GetCoinText(123456, " / ")
	-- returns "12 Gold / 4 Silver / 56 Copper"

	GetCoinTextureString(10000)
	-- returns "1|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"

	GetCoinTextureString(500050)
	-- returns "50|TInterface\\MoneyFrame\\U-GoldIcon:14:14:2:0|t 50|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t"

	GetCoinTextureString(123456)
	-- returns "12|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t 34|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t 56|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t"

	--[[ <merchant> Repairs:  None ]] 												-- DEFAULT_CHAT_FRAME:AddMessage(str .. "None |r")
	--[[ <merchant> Repairs:  0 {Gold texture} ]] 									-- DEFAULT_CHAT_FRAME:AddMessage(str .. "0|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t")
	--[[ <merchant> Repairs:  1 {Gold texture} ]] 									-- DEFAULT_CHAT_FRAME:AddMessage(str .. GetCoinTextureString(10000))
	--[[ <merchant> Repairs:  12 {Gold texture} 34 {Silver texture} 56 {Copper texture} ]] 	-- DEFAULT_CHAT_FRAME:AddMessage(str .. GetCoinTextureString(123456))
	--[[ <merchant> Repairs:  12 Gold, 34 Silver, 56 Copper ]] 							-- DEFAULT_CHAT_FRAME:AddMessage(str .. GetCoinText(123456, ", "))
--]=]
--================================================================================================--
--[[
		NORMAL_FONT_COLOR_CODE		= '|cffffd200'
		HIGHLIGHT_FONT_COLOR_CODE	= '|cffffffff'
		RED_FONT_COLOR_CODE			= '|cffff2020'
		GREEN_FONT_COLOR_CODE		= '|cff20ff20'
		GRAY_FONT_COLOR_CODE		= '|cff808080'
		YELLOW_FONT_COLOR_CODE		= '|cffffff00'
		LIGHTYELLOW_FONT_COLOR_CODE	= '|cffffff9a'
		ORANGE_FONT_COLOR_CODE		= '|cffff7f3f'
		ACHIEVEMENT_COLOR_CODE		= '|cffffff00'
		BATTLENET_FONT_COLOR_CODE	= '|cff82c5ff'
--]]
--================================================================================================--
--[[
	The Modulus Operator (%)		<http://luatut.com/crash_course.html>
	Remainder between the division of two numbers

		print(14 % 5)
		> 4

		print(10 % 3) 				-->  10 - 3 * 3
		> 1 						-->  = 1

		print(27.17 % 100)

	compacted: (10 - 3 * 3 = 1)
--]]
--================================================================================================--
