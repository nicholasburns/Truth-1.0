local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Experience"]["Enable"]) then return end
local print = function(...) Addon.print('experience', ...) end




-- Addon
local XP = CreateFrame('Frame')





function XP:CHAT_MSG_COMBAT_XP_GAIN()
	local xpgained = arg1:match("(%d+) experience")
	local xptolvl = UnitXPMax("player") - UnitXP("player")

	DEFAULT_CHAT_FRAME:AddMessage(xpgained .. " XP gained, " .. floor(xptolvl / xpgained) .. " equal gains to next level")
end

--[[ CHAT_MSG_COMBAT_XP_GAIN
	Fires when the player gains experience points

	("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter )

	message 		- The message thats received (string)
	sender 		- The sender's username (string)
	language 		- The language the message is in (string)
	channelString 	- The full name of the channel, including number (string)
	target 		- The username of the target of the action; Not used by all events (string)
	flags 		- The various chat flags; like, DND or AFK (string)
	unknown 		- This variable has an unkown purpose (number)
	channelNumber 	- The numeric ID of the channel (number)
	channelName 	- The full name of the channel, does not include the number (string)
	unknown 		- This variable has an unkown purpose although it always seems to be 0 (number)
	counter 		- This variable appears to be a counter of chat events that the client recieves (number)
--]]

local function OnEvent(self, event, arg1, arg2)							-- (self, event, msgtype, faction, reputation, ...)

	if (event == "CHAT_MSG_COMBAT_XP_GAIN") then

		local xp_gained = arg1:match("(%d+) experience")
		local xp_tolvl  = UnitXPMax("player") - UnitXP("player")			-- local xp_remain

		print(xp_gained .. " XP gained, " .. floor(xp_tolvl / xp_gained) .. " equal gains to next level")

end

local function OnLoad(self)
	self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
	self:RegisterEvent("COMBAT_TEXT_UPDATE")
end

--==============================================--
--	Events
--==============================================--
XP:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN')
XP:SetScript('OnEvent', function(self, event, ...)

end)
XP:SetScript('OnLoad', function(self)

end)


-- ADDON_LOADED
XP:RegisterEvent("ADDON_LOADED")
XP:SetScript("OnEvent", function(self, event, addon)
	if (event == "ADDON_LOADED" and addon ~= "Truth") then
		return end

	if (event == "PLAYER_ENTERING_WORLD") then

		if (not TruthDB) then
			TruthDB = {}
		end

		if (not TruthDB["Experience"]) then

			TruthDB["Experience"] = {
				["Enable"]				= true,
				["Counter"] 				= 0,
				["Timestamp"] 				= '',
				["Announcements"]			= true,
			}
		end

		C["Experience"]["Enable"]		= TruthDB["Experience"]["Enable"]
		C["Experience"]["Counter"]		= TruthDB["Experience"]["Counter"]
		C["Experience"]["Timestamp"]		= TruthDB["Experience"]["Timestamp"]
		C["Experience"]["Announcements"]	= TruthDB["Experience"]["Announcements"]

		self:UnregisterEvent(event)
	end
end)


--==============================================--
--	Reference
--==============================================--
-- elseif (event == "COMBAT_TEXT_UPDATE" and msgtype == "FACTION") then end

--[[	COMBAT_TEXT_UPDATE
	This event is used by Blizzard's floating combat text addon

	arg1		Combat MESSAGE TYPE; includes the following:
			 - "FACTION" ... "DAMAGE", "HEAL", "ABSORB", "MISS", "RESIST", etc.

	arg2		For faction gain, this is the faction name

	arg3		For faction gains, the amount of reputation gained

	---------------------------------------------
	*--> http://www.wowwiki.com/Events/Combat
--]]

--==============================================--
--	Tutorial
--==============================================--
--[[ XP GainsEdit
	http://www.wowwiki.com/User:Smelladin/LUA_snippets

	This will show a message on each XP gain (mobs/quests),
	containing how much XP you earned, and how many equal
	gains you need until next level. Got the idea from Fizzwidget
	FactionFriend, which has similar functionality, only with
	Reputation Points instead of XP.

	Put this in the OnLoad function of your script:

		this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")

	Put this in the event handler that handles CHAT_MSG_COMBAT_XP_GAIN:

		local xpgained = arg1:match("(%d+) experience")
		local xptolvl = UnitXPMax("player") - UnitXP("player")

		DEFAULT_CHAT_FRAME:AddMessage(xpgained .. " XP gained, " .. floor(xptolvl/xpgained) .. " equal gains to next level")
--]]
