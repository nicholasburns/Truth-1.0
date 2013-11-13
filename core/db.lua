local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('db', ...) end






local Default = {
	Timestamps = {
		login = 0,
		logout = 0,
		slashcmd = 0,
	},
	Counters = {
		login = 0,
		logout = 0,
		slashcmd = 0,
	},
	Raw = {
		date = 0,
		time = 0,
	},
}

--==============================================--
--	Events
--==============================================--
local frame = CreateFrame('Frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function(self, event, addon)

	if (event == 'ADDON_LOADED') and (addon == AddOn) then

		DB = TruthDB or {}
		TruthDB = DB

	end

	if (event == 'PLAYER_ENTERING_WORLD') then
		print('time(): ' .. time(), '  T.FormatTime(time()): ' .. T.FormatTime(time()))
	end

end)

--==============================================--
--	Database Engine
--==============================================--
do
	local f = CreateFrame('Frame')
	f:RegisterEvent('ADDON_LOADED')
	f:RegisterEvent('PLAYER_LOGOUT')
	f:SetScript('OnEvent', function(self, event, addon)
		if (event == 'ADDON_LOADED') then

			if (TruthDB == nil) then

			else
				TruthDB.Time.LOGIN = time()
			end

			self:UnregisterEvent(event)
		end

		if (event == 'PLAYER_LOGOUT') then

			TruthDB.Time.LOGOUT = time()								-- Final save occurs when the character logs out

		end
	end)
end


--==============================================--
--	Slash
--==============================================--
_G['SLASH_TRUTH_DATE1'] = '/truthdate'
_G['SLASH_TRUTH_TIME1'] = '/truthtime'


SlashCmdList['TRUTH_DATE'] = function(str)	-- Date
	print(date(), ' [date] ')
	print(T.FormatTime(date()), ' [date] ')
end

SlashCmdList['TRUTH_TIME'] = function()		-- Time
	print(time(), ' [seconds] ')
	print(T.FormatTime(time()), ' [time] ')
end

