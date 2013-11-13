local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Chat"]["Bubbles"]["Enable"]) then return end
local print = function(...) Addon.print('bubbles', ...) end



local pairs, select 				= pairs, select
local WorldFrame					= WorldFrame
local GetCVarBool 					= GetCVarBool



local Events = {
	CHAT_MSG_SAY 			= 'chatBubbles',
	CHAT_MSG_YELL 			= 'chatBubbles',
	CHAT_MSG_PARTY 		= 'chatBubblesParty',
	CHAT_MSG_PARTY_LEADER 	= 'chatBubblesParty',
	CHAT_MSG_MONSTER_SAY 	= 'chatBubbles',
	CHAT_MSG_MONSTER_YELL 	= 'chatBubbles',
	CHAT_MSG_MONSTER_PARTY 	= 'chatBubblesParty',
}

--==============================================--
--	Is Bubble ??
--==============================================--
local function isBubble(frame)
	if (frame:GetName()) then return end
	if (not frame:GetRegions()) then return end

	local region = frame:GetRegions()
	return region:GetTexture() == [=[Interface\Tooltips\ChatBubble-Background]=]
end

--==============================================--
--	Skin Bubbles
--==============================================--
local skinBubbles
skinBubbles = function(frame, ...)
	if (not frame.isTransparentBubble and isBubble(frame)) then

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())

			if (region:GetObjectType() == 'Texture') then
				region:SetTexture(nil)

			elseif (region:GetObjectType() == 'FontString') then
				local f, s = region:GetFont()
				region:SetFont(f, s, 'OUTLINE')
			end
		end

		frame.isTransparentBubble = true
	end

	if (...) then
		skinBubbles(...)
	end
end

--==============================================--
--	Events
--==============================================--
local numChildren = -1

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, event, addon)
	if (addon ~= AddOn) then return end
	self:Show()

	self:SetScript('OnEvent', function(self, event)
		if (GetCVarBool(Events[event])) then

			local count = WorldFrame:GetNumChildren()
			if (count ~= numChildren) then
				numChildren = count

				self.elapsed = 0

				if (not self:IsShown()) then
					self:Show()
				end
			end
		end
	end)

	for k, v in pairs(Events) do
		self:RegisterEvent(k)
	end

	self:UnregisterEvent(event)
	self.ADDON_LOADED = nil
end)


f.elapsed = 0
f:Hide()
f:SetScript('OnUpdate', function(self, elapsed)
	self.elapsed = self.elapsed + elapsed

	if (self.elapsed > 0.1) then
		self:Hide()
		skinBubbles(WorldFrame:GetChildren())
	end
end)



--==============================================--


	   if (not false) then return end


--==============================================--
--	Asphyxia\Skinning\Elements\Blizzard\ChatBubbles.lua
--==============================================--
local A, C, T, L = unpack(select(2, ...))
if (IsAddOnLoaded("BossEncounter2")) then return end

local chatbubblehook = CreateFrame("Frame", nil, UIParent)
local noscalemult = A["Mult"] * C["General"]["UIScale"]

local tslu = 0
local numkids = 0
local bubbles = {}


local function skinbubble(frame)
	for i = 1, (frame:GetNumRegions()) do
		local Region = select(i, frame:GetRegions())

		if (Region:GetObjectType() == "Texture") then
			Region:SetTexture(nil)

		elseif (Region:GetObjectType() == "FontString") then
			frame.text = Region
		end
	end

	frame:SetBackdrop({
		bgFile   = C["Media"]["Textures"]["Blank"],
		tile     = false,
		tileSize = 0,
		edgeFile = C["Media"]["Textures"]["Blank"],
		edgeSize = noscalemult,
		insets   = {
			left   = -noscalemult,
			right  = -noscalemult,
			top    = -noscalemult,
			bottom = -noscalemult,
		}
	})
	frame:SetBackdropColor(unpack(Addon.default.backdrop.color))
	frame:SetBackdropBorderColor(unpack(Addon.default.border.color))
	frame:CreateShadow()

  -- frame.text:SetFont(C.media.font, 14)

	tinsert(bubbles, frame)
end


local function ischatbubble(frame)
	if (frame:GetName()) then return end
	if (not frame:GetRegions()) then return end

	return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
end


chatbubblehook:SetScript("OnUpdate", function(chatbubblehook, elapsed)
	tslu = tslu + elapsed

	if (tslu > 0.05) then
		tslu = 0

		local newnumkids = WorldFrame:GetNumChildren()

		if (newnumkids ~= numkids) then

			for i = numkids + 1, newnumkids do
				local frame = select(i, WorldFrame:GetChildren())

				if (ischatbubble(frame)) then
					skinbubble(frame)
				end
			end

			numkids = newnumkids
		end

		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()

			frame:SetBackdropBorderColor(r, g, b, 0.8)
		end
	end
end)
