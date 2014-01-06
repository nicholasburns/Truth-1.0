local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('debugtools', ...) end
if (not C["Skin"]["DebugTools"]["Enable"]) then return end
local X = A["PixelSize"]
local P = A["PixelSizer"]

-- /d FrameStackTooltip:GetBackdrop().insets

--==============================================--
--	Framestack
--==============================================--
local frame = CreateFrame("Frame", "TruthFramestackTooltip", UIParent)
frame:SetScript("OnUpdate", function(self, elapsed)
	if (self.elapsed and self.elapsed > 0.1) then
		if (FrameStackTooltip) then
			local noscaler = X * A["UIScale"]

			FrameStackTooltip:SetBackdrop({
				bgFile   = Addon.default.backdrop.texture,
				edgeFile = Addon.default.border.texture,
				edgeSize = noscaler,
				insets   = {left = -noscaler, right = -noscaler, top = -noscaler, bottom = -noscaler}})
			FrameStackTooltip:SetBackdropColor(unpack(Addon.default.overlay.color))
			FrameStackTooltip:SetBackdropBorderColor(unpack(Addon.default.border.color))

			FrameStackTooltip.SetBackdropColor = A["Dummy"]
			FrameStackTooltip.SetBackdropBorderColor = A["Dummy"]

			self.elapsed = nil
			self:SetScript("OnUpdate", nil)
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

--==============================================--
--	DebugTools
--==============================================--
local function LoadSkin()
	ScriptErrorsFrame:SetParent(UIParent)
	ScriptErrorsFrame:Template("TRANSPARENT")
	EventTraceFrame:Template("TRANSPARENT")
	ScriptErrorsFrameClose:SkinCloseButton()
	EventTraceFrameCloseButton:SkinCloseButton()
	EventTraceFrameScrollBG:SetTexture(nil)
	_G["EventTraceTooltip"]:HookScript("OnShow", function(self)
		self:Template("TRANSPARENT")
	end)

	local Textures = {
		"TopLeft",
		"TopRight",
		"Top",
		"BottomLeft",
		"BottomRight",
		"Bottom",
		"Left",
		"Right",
		"TitleBG",
		"DialogBG",
	}
	for i = 1, (#texs) do
		_G["ScriptErrorsFrame" .. Textures[i]]:SetTexture(nil)
		_G["EventTraceFrame" .. Textures[i]]:SetTexture(nil)
	end

	for i = 1, (ScriptErrorsFrame:GetNumChildren()) do
		local child = select(i, ScriptErrorsFrame:GetChildren())
		if (child:GetObjectType() == "Button" and not child:GetName()) then
			child:SkinButton()
		end
	end
end

-- T.SkinFuncs["Blizzard_DebugTools"] = LoadSkin