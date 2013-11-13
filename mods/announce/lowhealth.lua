local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Announce"]["Lowhealth"]["Enable"]) then return end
local print = function(...) Addon.print('lowhealth', ...) end

local floor = math.floor
local PlaySoundFile = PlaySoundFile
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax





--	Addon
local f = CreateFrame('ScrollingMessageFrame', 'TruthLowhealthFrame', UIParent)
f.threshold = C["Announce"]["Lowhealth"]["Threshold"]
f.warned = false


-- Initialize
function Addon:Initialize()
	f:SetSize(450, 200)
	f:SetPoint('CENTER', UIParent, 0, 0)
	f:SetFont(unpack(C["Announce"]["Lowhealth"]["Font"]))
	f:SetShadowColor(0, 0, 0, .75)
	f:SetShadowOffset(3, -3)
	f:SetJustifyH('CENTER')
	f:SetMaxLines(2)
	f:SetTimeVisible(1)
	f:SetFadeDuration(1)

	Addon:Update()
end


local heathpercent
function Addon:Update()
	heathpercent = floor((UnitHealth('player') / UnitHealthMax('player')) * 100)

	if ((heathpercent <= f.threshold) and (f.warned == false)) then

		PlaySoundFile(C["Announce"]["Lowhealth"]["Sound"], 'Master')
		f:AddMessage(C["Announce"]["Lowhealth"]["Message"], 1, 0, 0, nil, 3)
		f.warned = true

		return
	end

	if (floor((UnitHealth('player') / UnitHealthMax('player')) * 100) > f.threshold) then
		f.warned = false
		return
	end
end


--==============================================--
--	Events
--==============================================--
function Addon:OnEvent(event, a1, ...)
	if (event == 'PLAYER_LOGIN') then self:UnregisterEvent(event)
		Addon:Initialize()
		return
	end
	if (event == 'UNIT_HEALTH' and a1 == 'player') then
		Addon:Update()
		return
	end
end

f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('UNIT_HEALTH')
f:SetScript('OnEvent', Addon.OnEvent)



--==============================================--
--	Backup
--==============================================--
--[[ Constants
	local LOWHEALTH_FONT			= C.lowhealth_font or [=[Interface\AddOns\Truth\media\font\grunge.ttf]=]
	local LOWHEALTH_FONTSIZE			= C.lowhealth_fontsize or 30
	local LOWHEALTH_FONTFLAG			= C.lowhealth_fontflag or 'THICKOUTLINE'
	local LOWHEALTH_MESSAGE			= C.lowhealth_message or '- LOW HEALTH -'
	local LOWHEALTH_THRESHOLD 		= C.lowhealth_threshold or 50
	local LOWHEALTH_SOUND			= C.lowhealth_sound or [=[Interface\AddOns\Truth\media\sound\warn.ogg]=]
--]]
--[[ Addon Revert

	local AddOn, Addon = ...
	local f = CreateFrame('ScrollingMessageFrame', 'TruthLowHeathFrame', UIParent)
	f.Threshold = LOWHEALTH_THRESHOLD
	f.Warned = false

	function Addon:Initialize()
		f:SetWidth(450)
		f:SetHeight(200)
		f:SetPoint('CENTER', UIParent, 0, 0)

		f:SetFont(LOWHEALTH_FONT, LOWHEALTH_FONTSIZE, LOWHEALTH_FONTFLAG)
		f:SetShadowColor(0, 0, 0, .75)
		f:SetShadowOffset(3, -3)
		f:SetJustifyH('CENTER')
		f:SetMaxLines(2)
		f:SetTimeVisible(1)
		f:SetFadeDuration(1)

		Addon:Update()
	end

	function Addon:Update()
		if (floor((UnitHealth('player') / UnitHealthMax('player')) * 100) <= f.Threshold and f.Warned == false) then

			PlaySoundFile(LOWHEALTH_SOUND, 'Master')

			f:AddMessage(LOWHEALTH_MESSAGE, 1, 0, 0, nil, 3)
			f.Warned = true

			return
		end

		if (floor((UnitHealth('player') / UnitHealthMax('player')) * 100) > f.Threshold) then
			f.Warned = false

			return
		end
	end

	function Addon:OnEvent(event, a1, ...)
		if (event == 'PLAYER_LOGIN') then
			Addon:Initialize()
			return
		end

		if (event == 'UNIT_HEALTH' and a1 == 'player') then
			Addon:Update()
			return
		end
	end
	f:SetScript('OnEvent', Addon.OnEvent)
	f:RegisterEvent('PLAYER_LOGIN')
	f:RegisterEvent('UNIT_HEALTH')
--]]
