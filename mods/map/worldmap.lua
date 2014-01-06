-- credit: m_Map by Monolit & Tukui
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Map"]["Worldmap"]["Enable"]) then return end
local print = function(...) Addon.print('worldmap', ...) end

local floor = math.floor
local UIParent = UIParent


-- Global
WORLDMAP_WINDOWED_SIZE = C["Map"]["Worldmap"]["Scale"]


-- Constant
local WORLDMAP_POINT = {'CENTER', UIParent, 0, -100}						--{"BOTTOM", UIParent, "BOTTOM", -120, 320}


--==============================================--
--	Map Background
--==============================================--
local mapbg = CreateFrame('Frame', 'TruthWorldmapBG', WorldMapDetailFrame)		-- mapbg:SetTemplate('ClassColor')

T.MakeMovable(mapbg)


--==============================================--
--	Small Map
--==============================================--
local SmallerMap = GetCVarBool('miniWorldMap')
if (SmallerMap == nil) then SetCVar('miniWorldMap', 1) end

local SmallerMapSkin = function()										-- Styling World Map

	mapbg:SetScale(1 / WORLDMAP_WINDOWED_SIZE)
	-- mapbg:SetPoint('TOPLEFT', WorldMapDetailFrame, -2, 2)
	-- mapbg:SetPoint('BOTTOMRIGHT', WorldMapDetailFrame, 2, -2)
	mapbg:SetWidth(WorldMapDetailFrame:GetWidth())
	mapbg:SetHeight(WorldMapDetailFrame:GetHeight())
	mapbg:SetPoint('CENTER', UIParent, 'CENTER', 0, -100)
	mapbg:SetFrameStrata('MEDIUM')
	mapbg:SetFrameLevel(20)


	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, -100)
	T.MakeMovable(WorldMapFrame)
	-- WorldMapFrame:SetFrameStrata('MEDIUM')
	-- WorldMapFrame:SetClampedToScreen(true)
	-- WorldMapFrame:SetClampRectInsets(12, 227, -31, -134)
	-- WorldMapFrame:ClearAllPoints()
	-- WorldMapFrame:SetPoint(unpack(WORLDMAP_POINT))

	WorldMapButton:SetAllPoints(WorldMapDetailFrame)

	WorldMapDetailFrame:SetFrameStrata('MEDIUM')
  -- WorldMapPing:SetAlpha(0)
	WorldMapPlayerUpper:EnableMouse(false)
	WorldMapPlayerLower:EnableMouse(false)

	WorldMapTitleButton:Show()
	WorldMapTitleButton:SetFrameStrata('MEDIUM')
	WorldMapTooltip:SetFrameStrata('TOOLTIP')

	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameCloseButton:Hide()
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Hide()


	--=========================================--
	--	Texts
	--=========================================--
	local offset = C["Map"]["Worldmap"]["Font"][4]

	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetParent(WorldMapDetailFrame)
	WorldMapFrameTitle:SetPoint('TOP', WorldMapDetailFrame, 0, -5)
	WorldMapFrameTitle:SetFont(C["Map"]["Worldmap"]["Font"][1], C["Map"]["Worldmap"]["Font"][2], C["Map"]["Worldmap"]["Font"][3])

	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint('BOTTOMLEFT', WorldMapButton, 0, 0)

	WorldMapFrameAreaLabel:SetFont(C["Map"]["Worldmap"]["Font"][1], 40)
	WorldMapFrameAreaLabel:SetShadowOffset(offset, -offset)
	WorldMapFrameAreaLabel:SetTextColor(0.9, 0.83, 0.64)

	WorldMapFrameAreaDescription:SetFont(C["Map"]["Worldmap"]["Font"][1], 40)
	WorldMapFrameAreaDescription:SetShadowOffset(offset, -offset)

	WorldMapFrameAreaPetLevels:SetFont(C["Map"]["Worldmap"]["Font"][1], 32)
	WorldMapFrameAreaPetLevels:SetShadowOffset(offset, -offset)

	MapBarFrame.Description:SetFont(C["Map"]["Worldmap"]["Font"][1], C["Map"]["Worldmap"]["Font"][2], C["Map"]["Worldmap"]["Font"][3])
	MapBarFrame.Description:SetShadowOffset(offset, -offset)

	MapBarFrame.Title:SetFont(C["Map"]["Worldmap"]["Font"][1], C["Map"]["Worldmap"]["Font"][2], C["Map"]["Worldmap"]["Font"][3])
	MapBarFrame.Title:SetShadowOffset(offset, -offset)

	--==============================================--
	--	DropDowns
	--==============================================--
	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.00001)

	WorldMapShowDropDown:SetScale(C["Map"]["Worldmap"]["Scale"])
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint('TOPRIGHT', WorldMapButton, 10, -3)
	WorldMapShowDropDown:SetFrameStrata('HIGH')

	--==============================================--
	--	DropDownButton
	--==============================================--
	WorldMapContinentDropDownButton:HookScript("OnClick", function()
		DropDownList1:SetScale(A["UIScale"])
	end)

	WorldMapZoneDropDownButton:HookScript("OnClick", function(self)
		DropDownList1:SetScale(A["UIScale"])
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 2, -4)
	end)

end
hooksecurefunc('WorldMap_ToggleSizeDown', function() SmallerMapSkin() end)


local frame = CreateFrame('Frame')
-- frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function(self, event)
	-- if (event == 'PLAYER_LOGIN') then
	-- if (event == 'PLAYER_ENTERING_WORLD') then

		WorldMap_ToggleSizeDown()

		WorldMapBlobFrame.Show = function() end
		WorldMapBlobFrame.Hide = function() end

		WorldMapQuestPOI_OnLeave = function()
			WorldMapTooltip:Hide()
		end

		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	-- end
end)


--==============================================--
--	Coordinates
--==============================================--
local L_MAP_CURSOR = "Cursor: "
local L_MAP_BOUNDS = "Out of bounds!"


local coords = CreateFrame('Frame', 'TruthCoordsFrame', WorldMapFrame)


coords.PlayerText = WorldMapButton:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
coords.PlayerText:SetFont(C["Map"]["Worldmap"]["Font"][1], 20)
coords.PlayerText:SetJustifyH('LEFT')
coords.PlayerText:SetText(UnitName('player') .. ': 0,0')


if (IsAddOnLoaded('_NPCScan.Overlay')) then
	coords.PlayerText:SetPoint('TOPLEFT', WorldMapButton, 'TOPLEFT', 3, -50)
else
	coords.PlayerText:SetPoint('TOPLEFT', WorldMapButton, 'TOPLEFT', 3, -3)
end


coords.MouseText = WorldMapButton:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
coords.MouseText:SetFont(C["Map"]["Worldmap"]["Font"][1], C["Map"]["Worldmap"]["Font"][2], C["Map"]["Worldmap"]["Font"][3])
coords.MouseText:SetJustifyH('LEFT')
coords.MouseText:SetPoint('TOPLEFT', coords.PlayerText, 'BOTTOMLEFT', 0, -3)
coords.MouseText:SetText(L_MAP_CURSOR .. ': 0, 0')


local int = 0
coords:SetScript('OnUpdate', function(self, elapsed)
	int = int + 1

	if (int >= 3) then

		local inInstance = IsInInstance()
		local x, y = GetPlayerMapPosition('player')

		x = floor(100 * x)
		y = floor(100 * y)

		if (x ~= 0 and y ~= 0) then
			self.PlayerText:SetText(UnitName('player') .. ': ' .. x .. ',' .. y)
		else
			self.PlayerText:SetText(UnitName('player') .. ': ' .. '|cffff0000' .. L_MAP_BOUNDS .. '|r')
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()

		local x, y = GetCursorPosition()

		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if (adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then

			adjustedX = floor(100 * adjustedX)
			adjustedY = floor(100 * adjustedY)

			coords.MouseText:SetText(L_MAP_CURSOR .. adjustedX .. ',' .. adjustedY)
		else
			coords.MouseText:SetText(L_MAP_CURSOR .. '|cffff0000' .. L_MAP_BOUNDS .. '|r')
		end

		int = 0
	end
end)