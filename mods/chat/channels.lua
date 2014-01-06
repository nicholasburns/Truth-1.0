-- credit: rChat (Zork)
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Channels"]["Enable"]) then return end
local print = function(...) Addon.print('chat.channels', ...) end

local format = string.format





--==============================================--
--	Constants
--==============================================--
local FORMATSTRING = C["Chat"]["Channels"]["FormatString"]

local L_BN_IN 			= format(FORMATSTRING, "B")
local L_BN_OUT			= format(FORMATSTRING, "@")
local L_GUILD 			= format(FORMATSTRING, "G")
local L_OFFICER 		= format(FORMATSTRING, "O")
local L_INSTANCE 		= format(FORMATSTRING, "I")	-- 01:13 |[Pigsblood]: nice pull who ever did that
local L_INSTANCE_LEADER 	= format(FORMATSTRING, "IL")
local L_PARTY 			= format(FORMATSTRING, "P")
local L_PARTY_GUIDE 	= format(FORMATSTRING, "PG")
local L_PARTY_LEADER 	= format(FORMATSTRING, "PL")
local L_RAID 			= format(FORMATSTRING, "R")
local L_RAID_LEADER 	= format(FORMATSTRING, "RL")
local L_RAID_WARNING 	= format(FORMATSTRING, "RW")
local L_WHISPER_IN		= format(FORMATSTRING, "W")
local L_WHISPER_OUT		= format(FORMATSTRING, "@")
local L_SAY			= format(FORMATSTRING, "S")
local L_YELL			= format(FORMATSTRING, "Y")
local L_AFK			= "AFK"
local L_DND			= "DND"

--==============================================--
--	Players Channels
--==============================================--
CHAT_BN_WHISPER_GET  		=  L_BN_IN				.. "%s:\32"
CHAT_BN_WHISPER_INFORM_GET  	=  L_BN_OUT				.. "%s:\32"
CHAT_GUILD_GET 			= "|Hchannel:GUILD|h"		.. L_GUILD		.. "|h%s:\32"
CHAT_OFFICER_GET 			= "|Hchannel:OFFICER|h"		.. L_OFFICER		.. "|h%s:\32"
CHAT_INSTANCE_CHAT_GET  		= "|Hchannel:INSTANCE_CHAT|h"	.. L_INSTANCE		.. "|h%s:\32"
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h"	.. L_INSTANCE_LEADER.. "|h%s:\32"
CHAT_PARTY_GET 			= "|Hchannel:PARTY|h"		.. L_PARTY		.. "|h%s:\32"
CHAT_PARTY_GUIDE_GET 		= "|Hchannel:PARTY|h"		.. L_PARTY_GUIDE	.. "|h%s:\32"
CHAT_PARTY_LEADER_GET 		= "|Hchannel:PARTY|h"		.. L_PARTY_LEADER	.. "|h%s:\32"
CHAT_RAID_GET 				= "|Hchannel:RAID|h"		.. L_RAID			.. "|h%s:\32"
CHAT_RAID_LEADER_GET 		= "|Hchannel:RAID|h"		.. L_RAID_LEADER	.. "|h%s:\32"
CHAT_RAID_WARNING_GET 		=  L_RAID_WARNING			.. "%s:\32"
CHAT_WHISPER_GET  			=  L_WHISPER_IN			.. "%s:\32"
CHAT_WHISPER_INFORM_GET  	=  L_WHISPER_OUT			.. "%s:\32"
CHAT_SAY_GET  				=  L_SAY 					.. "%s:\32"
CHAT_YELL_GET  			=  L_YELL					.. "%s:\32"
CHAT_FLAG_AFK  			= "[|cffE7E716" 			.. L_AFK 			.. "|r]\32"
CHAT_FLAG_DND  			= "[|cffFF0000" 			.. L_DND 			.. "|r]\32"

--==============================================--
--	Custom Channels
--==============================================--
do
	local gsub = string.gsub

	for i = 1, (C["Chat"]["Windows"]) do
		if (i ~= 2) then

			local f = _G["ChatFrame" .. i]
			local am = f.AddMessage

			local CHANNEL_FORMAT = " %1 "												-- local CHANNEL_FORMAT = "\32%1\32"

			f.AddMessage = function(frame, text, ...)
				return am(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h" .. CHANNEL_FORMAT .. "|h"), ...)
			end
		end
	end
end



--==============================================--
--	UTF-8
--==============================================--
--[[	UTF-8 Character Codes
	----------------------------------------------------------------------
		●	%s	\32  			WHITESPACE
		●	<	\60				LESS-THAN SIGN
		●	>	\62				GREATER-THAN SIGN
		●	@	\64				COMMERCIAL AT
		●	[	\91				LEFT SQUARE BRACKET
		●	]	\93				RIGHT SQUARE BRACKET
		●	©	\194 \169			COPYRIGHT SIGN
	----------------------------------------------------------------------
	 > http://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec
--]]

--==============================================--
--	Backup
--==============================================--
--[[ String Formats

	local FORMATSTRING = "||"
	local FORMATSTRING = "[%s]"				-- Default = "%s|| "
	%s = chat string (eg. "Guild", "2. Trade") (required)
--]]

--[[ Channel Names

	local T_BN_IN 						= "[B]"
	local T_BN_OUT						= "[@]"
	local T_GUILD 						= "[G]"
	local T_OFFICER 					= "[O]"
	local T_INSTANCE 					= "[I]"
	local T_INSTANCE_LEADER 				= "[IL]"
	local T_PARTY 						= "[P]"
	local T_PARTY_GUIDE 				= "[PG]"
	local T_PARTY_LEADER 				= "[PL]"
	local T_RAID 						= "[R]"
	local T_RAID_LEADER 				= "[RL]"
	local T_RAID_WARNING 				= "[RW]"
	local T_WHISPER_IN					= "[W]"
	local T_WHISPER_OUT					= "[@]"
	local T_SAY						= "[S]"
	local T_YELL						= "[Y]"
	local T_AFK 						= "[AFK]"
	local T_DND 						= "[DND]"
--]]

--==============================================--
--	Custom Channels
--==============================================--
--[[
do
	local gsub = string.gsub

	for i = 1, (C["Chat"]["Windows"]) do
		if (i ~= 2) then

			local f = _G["ChatFrame" .. i]
			local am = f.AddMessage

			local CHANNEL_FORMAT = "\32%1\32"
		  -- local CHANNEL_FORMAT = "%[%1%]"

			f.AddMessage = function(frame, text, ...)
				return am(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h" .. CHANNEL_FORMAT .. "|h"), ...)
			  -- return am(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h%[%1%]|h"), ...)	-- brackets added to channel number
			  -- return am(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h%1|h"), ...)		-- rChat original
			end
		end
	end
end
--]]

--==============================================--
--	Group Leader Icons
--==============================================--
--[[	credit: github.com/Xruptor/XanChat/blob/master/XanChat.lua

	CHAT_INSTANCE_CHAT_LEADER_GET	= [=[|Hchannel:INSTANCE_CHAT|h[BG|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	CHAT_PARTY_LEADER_GET 		= [=[|Hchannel:PARTY|h[P|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	CHAT_PARTY_GUIDE_GET  		= CHAT_PARTY_LEADER_GET
	CHAT_RAID_LEADER_GET  		= [=[|Hchannel:RAID|h[R|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	CHAT_RAID_WARNING_GET 		= [=[|Hchannel:RAIDWARNING|h[RW|TInterface\GroupFrame\UI-GROUP-MAINASSISTICON:0|t]|h %s: ]=]
--]]

--================================================================================================--
--	Group Channels
--================================================================================================--
--[["CHANNEL_CATEGORY_CUSTOM","CHANNEL_CATEGORY_WORLD","CHANNEL_CATEGORY_GROUP"]]
--[[
local L_BN_IN 						= format(FORMATSTRING, "B")	-- [B]
local L_BN_OUT						= format(FORMATSTRING, "@")
local L_GUILD 						= format(FORMATSTRING, "G")
local L_OFFICER 					= format(FORMATSTRING, "O")
local L_INSTANCE 					= format(FORMATSTRING, "I")
local L_INSTANCE_LEADER 				= format(FORMATSTRING, "IL")
local L_PARTY 						= format(FORMATSTRING, "P")
local L_PARTY_GUIDE 				= format(FORMATSTRING, "PG")
local L_PARTY_LEADER 				= format(FORMATSTRING, "PL")
local L_RAID 						= format(FORMATSTRING, "R")
local L_RAID_LEADER 				= format(FORMATSTRING, "RL")
local L_RAID_WARNING 				= format(FORMATSTRING, "RW")
local L_WHISPER_IN					= format(FORMATSTRING, "W")
local L_WHISPER_OUT					= format(FORMATSTRING, "@")
local L_SAY						= format(FORMATSTRING, "S")
local L_YELL						= format(FORMATSTRING, "Y")
local L_AFK 						= format(FORMATSTRING, "AFK")
local L_DND 						= format(FORMATSTRING, "DND")
--]]
--[[
local T_BN_IN 						= "[B]"
local T_BN_OUT						= "[@]"
local T_GUILD 						= "[G]"
local T_OFFICER 					= "[O]"
local T_INSTANCE 					= "[I]"
local T_INSTANCE_LEADER 				= "[IL]"
local T_PARTY 						= "[P]"
local T_PARTY_GUIDE 				= "[PG]"
local T_PARTY_LEADER 				= "[PL]"
local T_RAID 						= "[R]"
local T_RAID_LEADER 				= "[RL]"
local T_RAID_WARNING 				= "[RW]"
local T_WHISPER_IN					= "[W]"
local T_WHISPER_OUT					= "[@]"
local T_SAY						= "[S]"
local T_YELL						= "[Y]"
local T_AFK 						= "[AFK]"
local T_DND 						= "[DND]"

_G.CHAT_BN_WHISPER_GET 				=  T_BN_IN  				.. " %s:\32"
_G.CHAT_BN_WHISPER_INFORM_GET 		=  T_BN_OUT 				.. " %s:\32"
_G.CHAT_GUILD_GET 					= "|Hchannel:GUILD|h"   		.. T_GUILD   		.. "|h %s:\32"
_G.CHAT_OFFICER_GET 				= "|Hchannel:OFFICER|h" 		.. T_OFFICER 		.. "|h %s:\32"
_G.CHAT_INSTANCE_CHAT_GET 			= "|Hchannel:INSTANCE_CHAT|h" .. T_INSTANCE       .. "|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET		= "|Hchannel:INSTANCE_CHAT|h" .. T_INSTANCE_LEADER.. "|h %s:\32"
_G.CHAT_PARTY_GET 					= "|Hchannel:PARTY|h" 		.. T_PARTY        	.. "|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET 				= "|Hchannel:PARTY|h" 		.. T_PARTY_GUIDE  	.. "|h %s:\32"
_G.CHAT_PARTY_LEADER_GET 			= "|Hchannel:PARTY|h" 		.. T_PARTY_LEADER 	.. "|h %s:\32"
_G.CHAT_RAID_GET 					= "|Hchannel:RAID|h"  		.. T_RAID         	.. "|h %s:\32"
_G.CHAT_RAID_LEADER_GET 				= "|Hchannel:RAID|h"  		.. T_RAID_LEADER  	.. "|h %s:\32"
_G.CHAT_RAID_WARNING_GET 			=  T_RAID_WARNING			.. " %s:\32"
_G.CHAT_WHISPER_GET 				=  T_WHISPER_IN   			.. " %s:\32"
_G.CHAT_WHISPER_INFORM_GET 			=  T_WHISPER_OUT  			.. " %s:\32"
_G.CHAT_SAY_GET 					=  T_SAY          			.. " %s:\32"
_G.CHAT_YELL_GET 					=  T_YELL         			.. " %s:\32"
_G.CHAT_FLAG_AFK 					= "|cffE7E716" 			.. T_AFK .. "|r "
_G.CHAT_FLAG_DND 					= "|cffFF0000" 			.. T_DND .. "|r "

if (nil) then						-- Group Leader Icons
	_G.CHAT_INSTANCE_CHAT_LEADER_GET	= [=[|Hchannel:INSTANCE_CHAT|h[BG|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	_G.CHAT_PARTY_LEADER_GET 		= [=[|Hchannel:PARTY|h[P|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	_G.CHAT_PARTY_GUIDE_GET  		= CHAT_PARTY_LEADER_GET
	_G.CHAT_RAID_LEADER_GET  		= [=[|Hchannel:RAID|h[R|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]=]
	_G.CHAT_RAID_WARNING_GET 		= [=[|Hchannel:RAIDWARNING|h[RW|TInterface\GroupFrame\UI-GROUP-MAINASSISTICON:0|t]|h %s: ]=]
end								--[credit] https://github.com/Xruptor/XanChat/blob/master/XanChat.lua
--]]

--================================================================================================--
--	Backup
--================================================================================================--
--[[	_G.CHAT_BN_WHISPER_GET  				= "B %s\32"
	_G.CHAT_BN_WHISPER_INFORM_GET  		= "@ %s\32"
	_G.CHAT_GUILD_GET 					= "|Hchannel:GUILD|hG|h %s\32"
	_G.CHAT_OFFICER_GET 				= "|Hchannel:OFFICER|hO|h %s\32"
	_G.CHAT_INSTANCE_CHAT_GET  			= "|Hchannel:INSTANCE_CHAT|hI|h %s\32"
	_G.CHAT_INSTANCE_CHAT_LEADER_GET  		= "|Hchannel:INSTANCE_CHAT|hIL|h %s\32"
	_G.CHAT_PARTY_GET 					= "|Hchannel:PARTY|hP|h %s\32"
	_G.CHAT_PARTY_GUIDE_GET 				= "|Hchannel:PARTY|hPG|h %s\32"
	_G.CHAT_PARTY_LEADER_GET 			= "|Hchannel:PARTY|hPL|h %s\32"
	_G.CHAT_RAID_GET 					= "|Hchannel:RAID|hR|h %s\32"
	_G.CHAT_RAID_LEADER_GET 				= "|Hchannel:RAID|hRL|h %s\32"
	_G.CHAT_RAID_WARNING_GET 			= "! %s\32"
	_G.CHAT_WHISPER_GET  				= "W %s\32"
	_G.CHAT_WHISPER_INFORM_GET  			= "@ %s\32"
	_G.CHAT_SAY_GET  					= "S %s\32"
	_G.CHAT_YELL_GET  					= "Y %s\32"
	_G.CHAT_FLAG_AFK  					= "|cffE7E716[AFK]|r "
	_G.CHAT_FLAG_DND  					= "|cffFF0000[DND]|r "
--]]
