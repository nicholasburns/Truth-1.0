-- credit: ShestakUI by Shestak
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Bar"]["Cooldown"]["Enable"]) then return end
if (IsAddOnLoaded("OmniCC") or IsAddOnLoaded("ncCooldown") or IsAddOnLoaded("tullaCC")) then return end
local print = function(...) Addon.print('cooldown', ...) end
local format, floor, min, GetTime = string.format, math.floor, math.min, GetTime

-- debug
-- local fontfile = C["Bar"]["Cooldown"]["Font"][1]
-- print(fontfile)

--================================================================================================--
--	Cooldown Count
--================================================================================================--
local function GetFormattedTime(s)
	local day, hour, minute = 86400, 3600, 60

	if (s >= day) then
		return format("%dd", floor(s / day + 0.5)), s % day
	elseif (s >= hour) then
		return format("%dh", floor(s / hour + 0.5)), s % hour
	elseif (s >= minute) then
		return format("%dm", floor(s / minute + 0.5)), s % minute
	end

	return floor(s + 0.5), s - floor(s)
end

--================================================================================================--
--	Timer API
--================================================================================================--
local function Timer_Stop(self)
	self.enabled = nil
	self:Hide()
end

local function Timer_ForceUpdate(self)
	self.nextUpdate = 0
	self:Show()
end

local function Timer_OnSizeChanged(self, width, height)
	local fontScale = T.Round(width) / 40

	if (fontScale == self.fontScale) then return end

	self.fontScale = fontScale
	-- if (fontScale < 0.5) then				--[[-NB-]]
		-- self:Hide()
	-- else
		self.text:SetFont(C["Bar"]["Cooldown"]["Font"][1], C["Bar"]["Cooldown"]["Font"][2], C["Bar"]["Cooldown"]["Font"][3]) 							-- self.text:SetFont(C["Bar"]["Cooldown"]["Font"].file, C["Bar"]["Cooldown"]["Font"].size * fontScale, C["Bar"]["Cooldown"]["Font"].flag)
		self.text:SetShadowOffset(C["Bar"]["Cooldown"]["Font"][4] or 1, -C["Bar"]["Cooldown"]["Font"][4] or -1)
		self.text:SetShadowColor(C["Bar"]["Cooldown"]["Font"][5])								-- self.text:SetShadowColor(0, 0, 0, 0.8)

		if (self.enabled) then
			Timer_ForceUpdate(self)
		end
	-- end
end

local function Timer_OnUpdate(self, elapsed)
	if (self.text:IsShown()) then

		if (self.nextUpdate > 0) then
			self.nextUpdate = self.nextUpdate - elapsed
		else

			if ((self:GetEffectiveScale() / UIParent:GetEffectiveScale()) < 0.5) then
				self.text:SetText("")
				self.nextUpdate = 1

			else

				local remain = self.duration - (GetTime() - self.start)

				if (floor(remain + 0.5) > 0) then
					local time, nextUpdate = GetFormattedTime(remain)

					self.text:SetText(time)
					self.nextUpdate = nextUpdate

					if (floor(remain + 0.5) > 5) then
						self.text:SetTextColor(1, 1, 1)
					else
						self.text:SetTextColor(1, 0.2, 0.2)
					end
				else
					Timer_Stop(self)
				end
			end
		end
	end
end

local function Timer_Create(self)
--~  Watches OnSizeChanged events (this is needed since OnSizeChanged has buggy triggering if the frame with the handler is not shown)

	local scaler = CreateFrame("Frame", nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame("Frame", nil, scaler)
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript("OnUpdate", Timer_OnUpdate)

	local text = timer:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", 1, 0)
	text:SetFont(C["Bar"]["Cooldown"]["Font"][1], C["Bar"]["Cooldown"]["Font"][2], C["Bar"]["Cooldown"]["Font"][3])
	timer.text = text

	Timer_OnSizeChanged(timer, scaler:GetSize())

	scaler:SetScript("OnSizeChanged", function(self, ...)
		Timer_OnSizeChanged(timer, ...)
	end)

	self.timer = timer

	return timer
end

local function Timer_Start(self, start, duration, charges, maxCharges)
	local remainingCharges = charges or 0

	if ((start > 0) and (duration > 2) and (remainingCharges == 0) and (not self.noOCC)) then

		local timer = self.timer or Timer_Create(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0

		-- if (timer.fontScale >= 0.5) then
			timer:Show()
		-- end
	else
		local timer = self.timer
		if (timer) then
			Timer_Stop(timer)
		end
	end
end

hooksecurefunc(getmetatable(_G["ActionButton1Cooldown"]).__index, "SetCooldown", Timer_Start)



--==============================================--
--	Escape
--==============================================--
if (not _G["ActionBarButtonEventsFrame"]) then return end


-- Datatables
local active = {}
local hooked = {}



local function cooldown_OnShow(self)
	active[self] = true
end

local function cooldown_OnHide(self)
	active[self] = nil
end

local function cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges)
	local timer = self.timer
	if (not timer) then
		return true
	end

	return not (timer.start == start or timer.charges == charges or timer.maxCharges == maxCharges)
end

local function cooldown_Update(self)
	local button = self:GetParent()

	local start, duration, enable = GetActionCooldown(button.action)
	local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(button.action)

	if (cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges)) then
		Timer_Start(self, start, duration, charges, maxCharges)
	end
end


--==============================================--
--	EventWatcher
--==============================================--
local pairs = pairs

local EventWatcher = CreateFrame("Frame")												-- EventWatcher:Hide()
EventWatcher:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
EventWatcher:SetScript("OnEvent", function(self, event)
	for cd in pairs(active) do
		cooldown_Update(cd)
	end
end)


local function actionButton_Register(frame)
	local cd = frame.cooldown

	if (not hooked[cd]) then
		cd:HookScript("OnShow", cooldown_OnShow)
		cd:HookScript("OnHide", cooldown_OnHide)

		hooked[cd] = true
	end
end


if (_G["ActionBarButtonEventsFrame"].frames) then
	for i, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
		actionButton_Register(frame)
	end
end

hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", actionButton_Register)

--================================================================================================--

--	ORIGINAL

--================================================================================================--
--[[ Tukui version of OmniCC --> as a backup to the current Shestak version ]]--

--[[	local A, C, T, L = unpack(select(2, ...))
	if (not C.combat_cooldowns) then return end

	-- credit: Tukui by Tukz

	if (IsAddOnLoaded('OmniCC') or IsAddOnLoaded('ncCooldown')) then return end

	OmniCC = true

	local ICON_SIZE = 36

	local DAY, HOUR, MINUTE = 86400, 3600, 60
	local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5
	local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5

	--configuration settings
	local CooldownFont 					= C.cooldown_font
	local CooldownFontSize 				= C.cooldown_font_size 			-- 20
	local CooldownMinScale 				= C.cooldown_min_scale			-- 0.5
	local CooldownMinDuration 			= C.cooldown_min_duration		-- 2.5

	local EXPIRING_DURATION 				= C.cooldown_threshold
	local EXPIRING_FORMAT				= T.RGBToHex(1, 0, 0)   .. '%.1f|r' 	-- format for timers that are soon to expire
	local SECONDS_FORMAT				= T.RGBToHex(1, 1, 0)   ..   '%d|r' 	-- format for timers that have seconds remaining
	local MINUTES_FORMAT				= T.RGBToHex(1, 1, 1)   ..  '%dm|r' 	-- format for timers that have minutes remaining
	local HOURS_FORMAT					= T.RGBToHex(.4, 1, 1)  ..  '%dh|r' 	-- format for timers that have hours remaining
	local DAYS_FORMAT					= T.RGBToHex(.4, .4, 1) ..  '%dh|r' 	-- format for timers that have days remaining

	--local bindings!
	local floor = math.floor
	local min = math.min
	local GetTime = GetTime

	--returns both what text to display, and how long until the next update
	local function getTimeText(s)

		--format text as seconds when below a minute
		if (s < MINUTEISH) then
			local seconds = tonumber(T.Round(s))

			if (seconds > EXPIRING_DURATION) then
				return SECONDS_FORMAT, seconds, s - (seconds - 0.51)
			else
				return EXPIRING_FORMAT, s, 0.051
			end

		--format text as minutes when below an hour
		elseif s < HOURISH then
			local minutes = tonumber(T.Round(s/MINUTE))
			return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)

		--format text as hours when below a day
		elseif s < DAYISH then
			local hours = tonumber(T.Round(s/HOUR))
			return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)

		--format text as days
		else
			local days = tonumber(T.Round(s/DAY))
			return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
		end
	end

	--stops the timer
	local function Timer_Stop(self)
		self.enabled = nil
		self:Hide()
	end

	--forces the given timer to update on the next frame
	local function Timer_ForceUpdate(self)
		self.nextUpdate = 0
		self:Show()
	end

	--adjust font size whenever the timer's parent size changes
	--hide if it gets too tiny
	local function Timer_OnSizeChanged(self, width, height)
		local fontScale = T.Round(width) / ICON_SIZE
		if fontScale == self.fontScale then
			return
		end

		self.fontScale = fontScale
		if fontScale < CooldownMinScale then
			self:Hide()
		else
			self.text:SetFont(CooldownFont, fontScale * CooldownFontSize, 'MONOCHROME, OUTLINE') --'OUTLINE')
			self.text:SetShadowColor(0, 0, 0, 0.5)
			self.text:SetShadowOffset(1, -1) --(2, -2)
			if self.enabled then
				Timer_ForceUpdate(self)
			end
		end
	end

	--update timer text, if it needs to be
	--hide the timer if done
	local function Timer_OnUpdate(self, elapsed)
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			local remain = self.duration - (GetTime() - self.start)
			if tonumber(T.Round(remain)) > 0 then
				if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < CooldownMinScale then
					self.text:SetText('')
					self.nextUpdate  = 1
				else
					local formatStr, time, nextUpdate = getTimeText(remain)
					self.text:SetFormattedText(formatStr, time)
					self.nextUpdate = nextUpdate
				end
			else
				Timer_Stop(self)
			end
		end
	end

	--returns a new timer object
	local function Timer_Create(self)
		--a frame to watch for OnSizeChanged events
		--needed since OnSizeChanged has funny triggering if the frame with the handler is not shown
		local scaler = CreateFrame('Frame', nil, self)
		scaler:SetAllPoints(self)

		local timer = CreateFrame('Frame', nil, scaler) timer:Hide()
		timer:SetAllPoints(scaler)
		timer:SetScript('OnUpdate', Timer_OnUpdate)

		local text = timer:CreateFontString(nil, 'OVERLAY')
		text:SetPoint('CENTER', 2, 0)
		text:SetJustifyH('CENTER')
		timer.text = text

		Timer_OnSizeChanged(timer, scaler:GetSize())
		scaler:SetScript('OnSizeChanged', function(self, ...) Timer_OnSizeChanged(timer, ...) end)

		self.timer = timer
		return timer
	end

	--hook the SetCooldown method of all cooldown frames
	--ActionButton1Cooldown is used here since its likely to always exist
	--and I'd rather not create my own cooldown frame to preserve a tiny bit of memory
	local function Timer_Start(self, start, duration, charges, maxCharges)
		if self.noOCC then return end

		--start timer
		if start > 0 and duration > CooldownMinDuration then
			local timer = self.timer or Timer_Create(self)
			local num = charges or 0
			timer.start = start
			timer.duration = duration
			timer.charges = num
			timer.maxCharges = maxCharges
			timer.enabled = true
			timer.nextUpdate = 0
			if timer.fontScale >= CooldownMinScale and timer.charges < 1 then
				timer:Show()
			end
		--stop timer
		else
			local timer = self.timer
			if timer then
				Timer_Stop(timer)
			end
		end
	end

	hooksecurefunc(getmetatable(_G['ActionButton1Cooldown']).__index, 'SetCooldown', Timer_Start)

	local active = {}
	local hooked = {}

	local function cooldown_OnShow(self)
		active[self] = true
	end

	local function cooldown_OnHide(self)
		active[self] = nil
	end

	T.UpdateActionButtonCooldown = function(self)
		local button = self:GetParent()
		local start, duration, enable = GetActionCooldown(button.action)
		local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(button.action)

		Timer_Start(self, start, duration, charges, maxCharges)
	end

	local EventWatcher = CreateFrame('Frame')
	EventWatcher:Hide()
	EventWatcher:SetScript('OnEvent', function(self, event)
		for cooldown in pairs(active) do
			T.UpdateActionButtonCooldown(cooldown)
		end
	end)
	EventWatcher:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')

	local function actionButton_Register(frame)
		local cooldown = frame.cooldown
		if not hooked[cooldown] then
			cooldown:HookScript('OnShow', cooldown_OnShow)
			cooldown:HookScript('OnHide', cooldown_OnHide)
			hooked[cooldown] = true
		end
	end

	if _G['ActionBarButtonEventsFrame'].frames then
		for i, frame in pairs(_G['ActionBarButtonEventsFrame'].frames) do
			actionButton_Register(frame)
		end
	end

	hooksecurefunc('ActionBarButtonEventsFrame_RegisterFrame', actionButton_Register)
--]]

