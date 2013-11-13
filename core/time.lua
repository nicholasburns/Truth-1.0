-- credit: AsphyxiaUI (Sinaris, Azilroka)
-- AsphyxiaUI\Elements\DataTexts\Elements\Time.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Time"]["Enable"]) then return end
local print = function(...) Addon.print('time', ...) end
local format, tonumber = string.format, tonumber
local GetGameTime, date = GetGameTime, date


-- Locale
local EuropeString	= "%s%02d|r:%s%02d|r"
local UKString		= "%s%d|r:%s%02d|r %s%s|r"

-- Properties
local CurrentHour
local CurrentMin
local tslu = 1

-- Datatable
local AMPM = {
	TIMEMANAGER_PM,
	TIMEMANAGER_AM,
}

-- Configuration
local UseLocalTime = C["Time"]["UseLocal"]

--[[ Date Table

	The following table displays:
	  - Tag
	  - Tag Description
	  - Value (uses the following data)
		~> September 16, 1998 (a Wednesday), at 23:48:10
	 [+] Range of possible values (numeric values only)

	----------------------------------------------------------------
	Tag	Meaning					Value			Range
	----------------------------------------------------------------
	%a	abbreviated weekday name 	(Wed)
	%A	full weekday name 			(Wednesday)
	%b	abbreviated month name 		(Sep)
	%B	full month name 			(September)
	%c	date and time 				(09/16/98 23:48:10)
	%d	day of the month 			(16) 			[01–31]
	%H	hour, using a 24-hour clock 	(23) 			[00–23]
	%I	hour, using a 12-hour clock 	(11) 			[01–12]
	%j	day of the year 			(259) 			[001–366]
	%M	minute 					(48) 			[00–59]
	%m	month 					(09) 			[01–12]
	%p	either 'am' or 'pm' 		(pm)
	%S	second 					(10) 			[00–60]
	%w	weekday 					(3) 				[0–6 = Sunday–Saturday]
	%x	date 					(09/16/98)
	%X	time						(23:48:10)
	%y	two-digit year 			(98) 			[00–99]
	%Y	full year 				(1998)
	%%	the character ‘%’
	----------------------------------------------------------------

	Fixed representations (mm/dd/yyyy) use explicit format strings:  "%m/%d/%Y"
--]]

--[[ Format Examples

  -- Default PC format
	date("%m/%d/%y %H:%M:%S")

  -- Default Mac format
	date("%a %b %d %H:%M:%S %Y")

  --
	date()

--]]

--[[ date()
	Converts a number representing the date and time, to a higher-level representation

	@[param1]		a format string describing the representation we want
	@[param2]		the numeric date–time; defaults to the current date and time


	Producing a date table
	This is done using the format string '*t' (param1)

	@[example]	date("*t",906000490)
	@[returns]	the following table:
				{
					year  = 1998,
					month = 9,
					day   = 16,
					yday  = 259,
					wday  = 4,
					hour  = 23,
					min   = 48,
					sec   = 10,
					isdst = false,
				}


	Notice that, besides the fields used by os.time, the table created by os.date
	also provides the following:

		- day of week (wday, 1 is Sunday)
		- day of year (yday, 1 is January 1st)

--]]

--==============================================--
--	Format The Time
--==============================================--
local function GetFormattedTime()
	local Hour, Minute, AmPm

	if (UseLocalTime) then
		local Hour24
		Hour24 = tonumber(date("%H"))
		Hour	  = tonumber(date("%I"))
		Minute = tonumber(date("%M"))

		if (Hour24 >= 12) then
			AmPm = 1
		else
			AmPm = 2
		end

		return Hour, Minute, AmPm

	else

		Hour, Minute = GetGameTime()

		if (Hour >= 12) then
			if (Hour > 12) then
				Hour = Hour - 12
			end

			AmPm = 1
		else
			if (Hour == 0) then
				Hour = 12
			end

			AmPm = 2
		end

		return Hour, Minute, AmPm
	end
end

T.GetFormattedTime = GetFormattedTime

-- Test
-- print(GetFormattedTime())


--==============================================--
--	Update
--==============================================--
--[[
local function Update(self, t)
	tslu = tslu - t

	if (tslu > 0) then return end

	local Hour, Minute, AmPm = GetFormattedTime()

	if (CurrentHour == Hour and CurrentMin == Minute) then
		return
	end

	if (AmPm == -1) then
		self.Text:SetText(format(EuropeString, DataText.NameColor, Hour, DataText.NameColor, Minute))
	else
		self.Text:SetText(format(UKString, DataText.NameColor, Hour, DataText.NameColor, Minute, DataText.ValueColor, AMPM[AmPm]))
	end

	CurrentHour = Hour
	CurrentMin = Minute

	tslu = 1
end
--]]