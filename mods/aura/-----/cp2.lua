local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Aura"]["CP"]["Enable"]) then return end
local print = function(...) Addon.print('cp', ...) end
if (not T.PlayerIsRogue()) then return end

local pairs = pairs
local match = string.match
local lower = string.lower
local tonumber = tonumber
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitAura = UnitAura
local InCombatLockdown = InCombatLockdown
local GetComboPoints = GetComboPoints
local IsAltKeyDown = IsAltKeyDown
local MAX_COMBO_POINTS = MAX_COMBO_POINTS
local ColorPickerFrame = ColorPickerFrame

local AnticipationBuffName = GetSpellInfo(115189)


local backdrop = C["Aura"]["CP"]["Backdrop"]
--[[  local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	tile = true,
	tileSize = 4,
	edgeFile = [=[Interface\Tooltips\UI-Tooltip-Border]=],
	edgeSize = 4,
	insets = {left = 0.5, right = 0.5, top = 0.5, bottom = 0.5}
}
--]]


--==============================================--
--	Addon
--==============================================--
local f = CreateFrame("Frame", "TruthCP", UIParent)
-- f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

--==============================================--
--	Properties
--==============================================--
local pad = C["Aura"]["CP"]["Pad"]
local point = C["Aura"]["CP"]["Point"]
local scale = C["Aura"]["CP"]["Scale"]
local size = C["Aura"]["CP"]["Size"]
local r = 0.9686274509803922
local g = 0.674509803921568
local b = 0.1450980392156863
local Ant = {
	["r"] = 0.90,
	["g"] = 0.05,
	["b"] = 0.15,
}

local cframes = {}
local aframes = {}
local aframes_shown = true
local currently_shown = true



--==============================================--
--	Functions
--==============================================--
local function refreshDisplayState()
	-- if (not InCombatLockdown() and GetComboPoints("player") == 0) then
		-- for i = 1, (MAX_COMBO_POINTS) do cframes[i]:Hide() end
		-- currently_shown = false
	-- else
		-- if (not currently_shown) then
			for i = 1, (MAX_COMBO_POINTS) do
				cframes[i]:Show()
			end
			-- currently_shown = true
		-- end
	-- end
end


local function updateCP()
	local power = GetComboPoints("player")
	local i = 1

	while (i <= power) do
		cframes[i]:SetBackdropColor(r, g, b, 1)
		i = 1 + i
	end

	while (i <= MAX_COMBO_POINTS) do
		cframes[i]:SetBackdropColor(r, g, b, 0.1)
		i = 1 + i
	end

	if (currently_shown) then
		local _, _, _, count = UnitAura("player", "Ant")

		if (count == nil) then
			count = 0
		end

		if (count == 0 and aframes_shown == true) then
			for i = 1, (MAX_COMBO_POINTS) do
				aframes[i]:Hide()
			end

			aframes_shown = false
		end

		if (count > 0 and aframes_shown == false) then
			for i = 1, (MAX_COMBO_POINTS) do
				aframes[i]:Show()
			end

			aframes_shown = true
		end

		if (aframes_shown) then
			local ai = 1

			while (ai <= count) do
				aframes[ai]:SetBackdropColor(Ant.r, Ant.g, Ant.b, 1.0)
				ai = 1 + ai
			end

			while (ai <= MAX_COMBO_POINTS) do
				aframes[ai]:SetBackdropColor(Ant.r, Ant.g, Ant.b, 0.1)
				ai = 1 + ai
			end
		end
	end
end


local function updateFrames()
	for i = 1, (MAX_COMBO_POINTS) do
		cframes[i]:SetSize(size, size)
		cframes[i]:SetBackdropColor(r, g, b, 0.1)
		cframes[i]:SetBackdropBorderColor(0, 0, 0, 1)

		if (i == 1) then
			cframes[i]:SetPoint(unpack(C["Aura"]["CP"]["Point"]))
			cframes[i]:SetScale(scale)
			cframes[i]:SetMovable(true)
			cframes[i]:EnableMouse(true)
			cframes[i]:RegisterForDrag("LeftButton")
			cframes[i]:SetScript("OnDragStart", function(self) if (IsAltKeyDown()) then self:StartMoving() end end)
			cframes[i]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()
				local pt, _, xoff, yoff = self:GetPoint(1)

				TruthCPDB["Point"] = { pt, xoff, yoff }

			end)
		else
			cframes[i]:SetPoint("RIGHT", size + pad, 0)
		end

		cframes[i]:Show()
	end

	for i = 1, (MAX_COMBO_POINTS) do
		aframes[i]:SetSize(size, size)
		aframes[i]:SetBackdropColor(Ant.r, Ant.g, Ant.b, 0.1)
		aframes[i]:SetBackdropBorderColor(0, 0, 0, 1)

		if (i == 1) then
			aframes[i]:SetPoint("BOTTOM", cframes[1], "TOP", 0, pad)
		-- else
			-- aframes[i]:SetPoint("RIGHT", size + pad, 0)
		end

		aframes[i]:Hide()
	end

	aframes_shown = false

	updateCP()
end


local function initFrames()
	for i = 1, (MAX_COMBO_POINTS) do
		cframes[i] = CreateFrame("Frame", "CPFrame" .. i, i == 1 and UIParent or cframes[i - 1])
		cframes[i]:SetBackdrop(unpack(C["Aura"]["CP"]["Backdrop"]))

		local fs = cframes[i]:CreateFontString(nil, 'OVERLAY')
		fs:SetFont(unpack(Addon.default.pxfont))
		cframes[i].text = fs

	end

	for i = 1, (MAX_COMBO_POINTS) do
		aframes[i] = CreateFrame("Frame", "ACPFrame" .. i, i == 1 and cframes[1] or aframes[i - 1])
		aframes[i]:SetBackdrop(unpack(C["Aura"]["CP"]["Backdrop"]))

		-- local fs = aframes[i]:CreateFontString(nil, 'OVERLAY')
		-- fs:SetFont(unpack(Addon.default.pxfont))
		-- aframes[i].text = fs

	end

	updateFrames()
end

local function destroyFrames()
	for i = 1, (MAX_COMBO_POINTS) do
		cframes[i]:Hide()
		cframes[i] = nil
	end

	cframes = {}
end

local CPColorPickCallback = function (restore)
	if (restore) then
		r, g, b = unpack(restore)
	else
		r, g, b = ColorPickerFrame:GetColorRGB()
	end

	TruthCPDB["r"] = r
	TruthCPDB["g"] = g
	TruthCPDB["b"] = b

	updateFrames()
end

local A_CPColorPickCallback = function(restore)
	if (restore) then
		Ant.r, Ant.g, Ant.b = unpack(restore)
	else
		Ant.r, Ant.g, Ant.b = ColorPickerFrame:GetColorRGB()
	end

	TruthCPDB["Ant"]["r"] = Ant.r
	TruthCPDB["Ant"]["g"] = Ant.g
	TruthCPDB["Ant"]["b"] = Ant.b

	updateFrames()
end

f:SetScript("OnEvent", function(self, event, addon, ...)
--[[	function f:UNIT_COMBO_POINTS() updateCP() end
	function f:UNIT_AURA(unit) if (unit == "player") then updateCP() end end
	function f:PLAYER_TARGET_CHANGED() updateCP() end
	function f:PLAYER_REGEN_ENABLED() refreshDisplayState() end
	function f:PLAYER_ENTERING_WORLD() updateCP() end
--]]

	if (event == UNIT_COMBO_POINTS) then updateCP() end

	if (event == UNIT_AURA) then
		if (addon == "player") then
			updateCP()
		end
	end
	if (event == PLAYER_TARGET_CHANGED) then updateCP() end
	if (event == PLAYER_REGEN_ENABLED) then refreshDisplayState() end
	if (event == PLAYER_ENTERING_WORLD) then updateCP() end

	if (event == ADDON_LOADED) then

	-- function f:ADDON_LOADED(addon)
		if (addon ~= AddOn) then return end
		if (not T.PlayerIsRogue()) then return end

		local Default = {
			["pad"] = C["Aura"]["CP"]["Pad"],
			["point"] = C["Aura"]["CP"]["Point"],
			["scale"] = C["Aura"]["CP"]["Scale"],	-- 1,
			["size"] = C["Aura"]["CP"]["Size"],
			["r"] = 0.9686274509803922,
			["g"] = 0.6745098039215687,
			["b"] = 0.1450980392156863,
			["Ant"] = {				-- ["scale"] = 1,
				["r"] = 0.90,
				["g"] = 0.05,
				["b"] = 0.15,
			},
		}

		TruthCPDB = TruthCPDB or {}

		for k, v in pairs(Default) do
			if (TruthCPDB[k] == nil) then
				TruthCPDB[k] = v
			end
		end

		SlashCmdList["TRUTH_CP"] = function(txt)
			local cmd, msg = txt:match("^(%S*)%S*(.-)$")
			cmd = lower(cmd)
			msg = lower(msg)
			if (cmd == "reset") then
				TruthCPDB["point"], point = C["Aura"]["CP"]["Point"], C["Aura"]["CP"]["Point"]
				TruthCPDB["pad"], pad = C["Aura"]["CP"]["Pad"], C["Aura"]["CP"]["Pad"]
				TruthCPDB["scale"], scale = C["Aura"]["CP"]["Scale"], C["Aura"]["CP"]["Scale"]
				TruthCPDB["r"], r = 0.9686274509803922, 0.9686274509803922
				TruthCPDB["g"], g = 0.674509803921568,  0.674509803921568
				TruthCPDB["b"], b = 0.1450980392156863, 0.1450980392156863
				TruthCPDB["Ant"]["r"], Ant.r = 0.90, 0.90
				TruthCPDB["Ant"]["g"], Ant.g = 0.05, 0.05
				TruthCPDB["Ant"]["b"], Ant.b = 0.15, 0.15

				destroyFrames()
				initFrames()

				print("Frame reset to the center, you can now move it to the desired position.")

				return
			end
			local num = msg and tonumber(msg) or nil
			if (cmd == "scale") then
				if (num) then
					TruthCPDB["scale"], scale = num, num
					updateFrames()
				else
					print("Not a valid scale", "Use scale between 0.5 and 3")
				end

		  -- elseif (cmd == "Ant.scale") then
				-- if (num) then
					-- TruthCPDB["Ant"]["scale"], Ant.scale = num, num
					-- updateFrames()
				-- else
					-- print("Not a valid 'scale'", "Use scale between 0.5 and 3")
				-- end

			elseif (cmd == "color") then
				ColorPickerFrame:SetColorRGB(r, g, b)
				ColorPickerFrame.previousValues = {r, g, b}
				ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = CPColorPickCallback, CPColorPickCallback, CPColorPickCallback
				ColorPickerFrame:Hide() -- apparently needed...
				ColorPickerFrame:Show()

				T.MakeMovable(ColorPickerFrame, 'DIALOG')

				updateFrames()

			elseif (cmd == "anticipation.color") then
				ColorPickerFrame:SetColorRGB(Ant.r, Ant.g, Ant.b)
				ColorPickerFrame.previousValues = {Ant.r, Ant.g, Ant.b}
				ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = A_CPColorPickCallback, A_CPColorPickCallback, A_CPColorPickCallback
				ColorPickerFrame:Hide() -- apparently needed...
				ColorPickerFrame:Show()

				updateFrames()

			else
				print("",
			   [[|cff3399FF/cp reset|r    |cffE4F3FFResets the addon back to default settings
								  |cffE4F3FFUse if (you can't see the frame and/or dragged it out of the screen|r
				|cff3399FF/cp scale|r    |cffE4F3FFChange the scale of the addon|r
				|cff3399FF/cp color|r    |cffE4F3FFOpen the color picker window|r
				|cff3399FF/cp acolor|r  |cffE4F3FFOpen the anticipation color picker window|r
				|cff33FF99Move Boxes:|r |cffE4F3FFAlt+Left mouse button on the leftmost box to drag it|r ]]
				)
	--[=[
				print("/cp reset|r", "Resets the addon back to default settings. \n Use if (you can't see the frame and/or dragged it out of the screen")
				print("/cp scale|r", "Change the scale of the addon")
				print("/cp color|r", "Open the color picker window")
				print("/cp Ant.color|r", "Open the anticipation color picker window")
			  -- print("/cp Ant.scale|r", "Change the scale of the anticipation boxes")
				print("|cff33FF99To move the boxes:|r", "Alt+Left mouse button on the leftmost box to drag it")
	--]=]
			end
		end


		pad = TruthCPDB["pad"]
		point = TruthCPDB["point"]
		scale = TruthCPDB["scale"]
		size= TruthCPDB["size"]
		r = TruthCPDB["r"]
		g = TruthCPDB["g"]
		b = TruthCPDB["b"]

		Ant.r = TruthCPDB["Ant"]["r"]
		Ant.g = TruthCPDB["Ant"]["g"]
		Ant.b = TruthCPDB["Ant"]["b"]

		initFrames()

		f:RegisterEvent("UNIT_COMBO_POINTS")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:RegisterEvent("PLAYER_TARGET_CHANGED")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:RegisterEvent("UNIT_AURA")
	end
end)

SLASH_TRUTH_CP1 = "/cp"


f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")



-- function f:PLAYER_LOGOUT() end
