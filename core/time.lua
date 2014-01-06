-- credit: AsphyxiaUI (Sinaris, Azilroka)
-- AsphyxiaUI\Elements\DataTexts\Elements\Time.lua
local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C["Addon"]["Time"]["Enable"]) then return end
local print = function(...) Addon.print('time', ...) end

local ceil, floor, mod = math.ceil, math.floor, math.mod
local format, tonumber = string.format, tonumber
local GetGameTime, date = GetGameTime, date


-- GlobalStrings.lua
local DAYS = "|4Day:Days"
local DAYS_ABBR = "%d |4Day:Days"
local DAY_ONELETTER_ABBR = "%d d"




--[[
	body = BetterDate(CHAT_TIMESTAMP_FORMAT, time()) .. body
]]
T.BetterDate = function(formatString, timeVal)
  -- UIParent.lua / BetterDate()  ==> Like date(), but localizes AM/PM

	local dateTable = date("*t", timeVal)
	local amString = (dateTable.hour >= 12) and TIMEMANAGER_PM or TIMEMANAGER_AM

	-- First, we'll replace %p with the appropriate AM or PM.
	formatString = gsub(formatString, "^%%p", amString)	--Replaces %p at the beginning of the string with the am/pm token
	formatString = gsub(formatString, "([^%%])%%p", "%1"..amString) -- Replaces %p anywhere else in the string, but doesn't replace %%p (since the first % escapes the second)

	return date(formatString, timeVal)
end


--==============================================--
--	Format Time
--==============================================--
T.FormatTime = function(s)
  -- credit:	AsphyxiaUI/Handler/Math.lua
  -- @[use]:	local Time = T.FormatTime(Seconds)

	local Day, Hour, Minute = 86400, 3600, 60

	if (s >= Day) then
		return format("%dd", ceil(s / Day))
	elseif (s >= Hour) then
		return format("%dh", ceil(s / Hour))
	elseif (s >= Minute) then
		return format("%dm", ceil(s / Minute))
	elseif (s >= Minute / 12) then
		return floor(s)
	end

	return format("%.1f", s)
end

--==============================================--
--	Tests
--==============================================--
local function SecToTime(seconds, noSeconds, notAbbreviated, maxCount, roundUp)
	local time = ""
	local count = 0
	local tempTime

	seconds = roundUp and ceil(seconds) or floor(seconds)
	maxCount = maxCount or 2

	if ( seconds >= 86400  ) then
		count = count + 1
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / 86400)
		else
			tempTime = floor(seconds / 86400)
		end
		if ( notAbbreviated ) then
			time = format(D_DAYS,tempTime)
		else
			time = format(DAYS_ABBR,tempTime)
		end
		seconds = mod(seconds, 86400)
	end
	if ( count < maxCount and seconds >= 3600  ) then
		count = count + 1
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER
		end
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / 3600)
		else
			tempTime = floor(seconds / 3600)
		end
		if ( notAbbreviated ) then
			time = time..format(D_HOURS, tempTime)
		else
			time = time..format(HOURS_ABBR, tempTime)
		end
		seconds = mod(seconds, 3600)
	end
	if ( count < maxCount and seconds >= 60  ) then
		count = count + 1
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER
		end
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / 60)
		else
			tempTime = floor(seconds / 60)
		end
		if ( notAbbreviated ) then
			time = time..format(D_MINUTES, tempTime)
		else
			time = time..format(MINUTES_ABBR, tempTime)
		end
		seconds = mod(seconds, 60)
	end
	if ( count < maxCount and seconds > 0 and not noSeconds ) then
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER
		end
		seconds = format("%d", seconds)
		if ( notAbbreviated ) then
			time = time..format(D_SECONDS, seconds)
		else
			time = time..format(SECONDS_ABBR, seconds)
		end
	end
	return time
end


--[[
        1384337774    nil

        16022d  	  36974
        16023d  	  nil
        16023d 	  nil
        16022d  	  36974
		--
time()= 1384337775    16022d = T.FormatTime(time())
		16022 Days  10 Hr  nil
		%d d  	  16023
--]]
-- print( time() )
-- print( T.FormatTime(time()) )

-- print( SecToTimeAbbrev(time()) )
-- print( SecToTime(time()) )
-- print( SecondsToTime(time()) )
-- print( MinutesToTime(time()) )


--==============================================--
--	GetFormatted Time
--==============================================--

-- Locale
local EuropeString = "%s%02d|r:%s%02d|r"
local UKString = "%s%d|r:%s%02d|r %s%s|r"

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
local UseLocalTime = C["Addon"]["Time"]["UseLocal"]

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
	@[param2]		the numeric date–time defaults to the current date and time


	Producing a date table
	This is done using the format string '*t' (param1)

	@[example]	date("*t", 906000490)
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

