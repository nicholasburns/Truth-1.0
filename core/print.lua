local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))



local debug = false


--==============================================--
--	Print
--==============================================--
local MY_GRN_COLOR_CODE = '|cff99CC99'
local MY_SKY_COLOR_CODE = '|cffE4F3FF'
local MY_BLU_COLOR_CODE = '|cff3399FF'

local print

do
	local gsub = string.gsub
	local upper = string.upper
	local format = string.format

	local AddOn = format("%s%s", MY_GRN_COLOR_CODE, AddOn)

	print = function(file, key, value, ...)
		file  = format("%s%s", BATTLENET_FONT_COLOR_CODE, file:gsub("^%l", upper))
		key   = format("%s%s", MY_BLU_COLOR_CODE, tostring(key))
		value = format("%s%s", MY_SKY_COLOR_CODE, tostring(value))

		DEFAULT_CHAT_FRAME:AddMessage(format("%s %s:  %s  %s", AddOn, file, key, value))
	end
end

Addon.print = print


--==============================================--
--	Print Table Values
--==============================================--
Addon.printpairs = function(t)
--   Print all values of table "t"

	for k, v in pairs(t) do
		print(k, v)
	end
end


--==============================================--
--	print_r
--==============================================--
-- A function in Lua similar to PHP's print_r
-- [src] https://gist.github.com/nrk/31175
-- [credit] http://luanet.net/lua/function/print_r
local string = string
local len = string.len
local rep = string.rep
local pairs = pairs
local type = type
local tostring = tostring


Addon.print_r = function(t)
    local print_r_cache = {}

    local function sub_print_r(t, indent)

        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true

            if (type(t) == "table") then

                for pos, val in pairs(t) do

                    if (type(val) == "table") then

                        print(indent .."[" .. pos .. "] => ".. tostring(t) .. " {")

                        sub_print_r(val,indent .. rep(" ", len(pos) + 8))

                        print(indent .. rep(" ", len(pos) + 6) .. "}")

                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    sub_print_r(t, "  ")
end

--==============================================--
--	Print_r Dumper   [src] pastebin.com/A7JScXWk
--
--	Returns str instead of printing by default
--==============================================--
Addon.dumpvar = function(data)
--[[ Usage:
	>  print(dumpvar(Tbl))
--]]
	local tablecache = {}

	local buffer = ""
	local padder = "    "

	local function _dumpvar(d, depth)
		local typ = type(d)
		local str = tostring(d)

		if (typ == "table") then

			if (tablecache[str]) then
				buffer = buffer .. "<" .. str .. ">\n"

			else
				tablecache[str] = (tablecache[str] or 0) + 1

				buffer = buffer .. "(" .. str .. ") {\n"

				for k, v in pairs(d) do
					buffer = buffer .. rep(padder, depth + 1) .. "[" .. k .. "] => "

					_dumpvar(v, depth + 1)
				end

				buffer = buffer .. rep(padder, depth) .. "}\n"
			end

		elseif (typ == "number") then
			buffer = buffer .. "(" .. typ .. ") " .. str .. "\n"

		else
			buffer = buffer .. "(" .. typ .. ") \"" .. str .. "\"\n"
		end
	end

	_dumpvar(data, 0)

	return buffer
end

--[[ Example Code

	-- usage:

	print(dumpvar({
		[1] = "this is the first element",
		[2] = "and this is the second",
		[3] = 3,
		[4] = 3.1415,
		["nested"] = {
			["lua"] = "is cool but",
			["luajit"] = "is fucking awesome!"
		},
		["some-files"] = {
			[0] = io.stdin,
			[1] = io.stdout,
			[2] = io.stderr
		}
	}))

	-- outputs:

	(table: 0x41365f60) {
	    [1] => (string) "this is the first element"
	    [2] => (string) "and this is the second"
	    [3] => (number) 3
	    [4] => (number) 3.1415
	    [nested] => (table: 0x41365fb0) {
		   [lua] => (string) "is cool but"
		   [luajit] => (string) "is fucking awesome!"
	    }
	    [some-files] => (table: 0x41366048) {
		   [0] => (userdata) "file (0x3f1e79b6a0)"
		   [1] => (userdata) "file (0x3f1e79b780)"
		   [2] => (userdata) "file (0x3f1e79b860)"
	    }
	}
--]]

--==============================================--
--	SysMsg
--==============================================--
--[[ Addon.sysmsg = function(...)
		print(self:mytostring(" ", 200, ...), 1, .5, 0)
	end
--]]

--==============================================--
--	Debug
--==============================================--
--[[ Addon.debug = function(...)
	    if (debug) then
			print(mytostring("#", 200, "  #", ...) .. "#", 1, .5, 0)
			return true
		end

		return false
	end
--]]
--==============================================--
--	Pattern Matching
--==============================================--
--[[ Search for a date in the format:  dd/mm/yyyy
	using the pattern:  "%d%d/%d%d/%d%d%d%d":

		s = "Deadline is 30/05/1999, firm"
		date = "%d%d/%d%d/%d%d%d%d"
		print(string.sub(s, string.find(s, date))) --> 30/05/1999

	The following table lists all character classes:

	----------------------------------------
			  Character Classes
	----------------------------------------
	  .  all characters
	 %a  letters
	 %c  control characters
	 %d  digits
	 %g  printable characters except spaces
	 %l  lower-case letters
	 %p  punctuation characters
	 %s  space characters
	 %u  upper-case letters
	 %w  alphanumeric characters
	 %x  hexadecimal digits
	----------------------------------------

	Examples
	--------
	"%.2f"		means:  format this var as a number with two decimal places
				usage:  text = string.format(“%.2f, %.2f”, x, y);
--]]

--==============================================--
--	Blizzard Constants
--==============================================--
--[[
	NORMAL_FONT_COLOR_CODE		= '|cffFFD200'
	HIGHLIGHT_FONT_COLOR_CODE	= '|cffFFFFFF'
	RED_FONT_COLOR_CODE			= '|cffFF2020'
	GREEN_FONT_COLOR_CODE		= '|cff20FF20'
	GRAY_FONT_COLOR_CODE		= '|cff808080'
	YELLOW_FONT_COLOR_CODE		= '|cffFFFF00'
	LIGHTYELLOW_FONT_COLOR_CODE	= '|cffFFFF9A'
	ORANGE_FONT_COLOR_CODE		= '|cffFF7F3F'
	ACHIEVEMENT_COLOR_CODE		= '|cffFFFF00'
	BATTLENET_FONT_COLOR_CODE	= '|cff82C5FF'
--]]

--==============================================--
--	Backup
--==============================================--
--[[	D | credit: QTip (addon)

	local D
	do
		local print = print
		local upper = string.upper
		local printHeader = '|cFF33FF99%s|r: '

		D = function(tag, msg, ...)
			local tag = '|cffCC3333 Truth|r:' .. '|cffDB7070' .. upper(tag) .. '|r '
			local msg = '|cffFFFFFF' .. msg .. '|r '
			local dot = ''

			if (...) then dot = '|cffFFFF80' .. ... .. '|r' end

			DEFAULT_CHAT_FRAME:AddMessage(tag .. msg .. dot)
		end
	end

	D(('%s%s%s: %s%s %s%s'):format(L.COLOR_ACE3, L.N_TITLE, L.COLOR_STOP, L.COLOR_GREY, L.N_L_QTIP, L.NOT_QTIP, L.COLOR_STOP))

	Addon.print = D
--]]

--==============================================--
--	Dump
--==============================================--
--[[ Addon.dump = function(...)
		for i = 1, select('#', ...) do
			local arg = select(i, ...) 		-- get i-th parameter

			-- <loop body>

			print(#(...))
			print(i, arg[i])

		  -- print('print', #(...))
		  -- print('print', i, arg[i])
		end
	end
--]]

