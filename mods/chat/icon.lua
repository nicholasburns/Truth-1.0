-- Add item icons to tooltips (credit: Tipachu by Tuller)
local A, C, T, L = unpack(select(2, ...))
if (not C["Tooltip"]["Icon"]) then return end
local print = function(...) Addon.print('icon', ...) end
































--==============================================--
--	Group Leader Icons
--	github.com/Xruptor/XanChat/blob/master/XanChat.lua
--==============================================--
CHAT_INSTANCE_CHAT_LEADER_GET	= [[|Hchannel:INSTANCE_CHAT|h[BG|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
CHAT_PARTY_LEADER_GET		= [[|Hchannel:Party|h[P|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
CHAT_PARTY_GUIDE_GET		= CHAT_PARTY_LEADER_GET
CHAT_RAID_LEADER_GET		= [[|Hchannel:Raid|h[R|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
CHAT_RAID_WARNING_GET		= [[|Hchannel:RaidWarning|h[RW|TInterface\GroupFrame\UI-GROUP-MAINASSISTICON:0|t]|h %s: ]]
