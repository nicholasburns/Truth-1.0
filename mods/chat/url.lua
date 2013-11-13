-- Credit: Gibberish (p3lim)
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Url"]["Enable"]) then return end
local print = function(...) Addon.print('url', ...) end
local select, unpack, gsub, match, sub = select, unpack, string.gsub, string.match, string.sub
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter


local PatternList = {
	'(https://%S+)',
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)',
}

local numPatterns = #PatternList

local FilterList = {
  -- Filter messages for URL patterns
	'CHAT_MSG_GUILD',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_BN_WHISPER',
	'CHAT_MSG_SAY',
}

for _, event in pairs(FilterList) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, str, ...)

		for index = 1, (#PatternList) do

			local result, match = gsub(str, PatternList[index], '|cff80C8FE|Hurl:%1|h[%1]|h|r')

			if (match > 0) then
				return false, result, ...
			end
		end
	end)
end



-- URL
local ChatEdit_GetLastActiveWindow = ChatEdit_GetLastActiveWindow
local ChatEdit_ActivateChat = ChatEdit_ActivateChat

local orig = ItemRefTooltip.SetHyperlink
function ItemRefTooltip.SetHyperlink(self, link, ...)
	if (sub(link, 1, 3) == "url") then
		local editbox = ChatEdit_GetLastActiveWindow()

		ChatEdit_ActivateChat(editbox)

		editbox:Insert(sub(link, 5))
		editbox:HighlightText()

		return
	end

	orig(self, link, ...)
end
