--[[



	UnitAura(unit, index|name, [filter])
--~  arg2 can either be the index of the aura or the name ("|")

	[args]
	duration	- Total duration of the aura (in seconds) (number)
	expires	- Time at which the aura will expire; can be compared to GetTime() to determine time remaining (number)

--]]

local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if (not C['Aura']['UNIT_AURA']['Enable']) then return end
local print = function(...) Addon.print('aura', ...) end


if (not false) then return end



--[[--==========================================--
--			SANDBOX SCRIPT
--		------------------------------
--		 UNIT_AURA Event Handler
--	wowprogramming.com/forums/development/590
--]]--==========================================--


local i_darkintent_bs = 85768			 		--~  Dark Intent (buff to self)
local i_darkintent_p  = 94310			 		--~  Dark Intent (proc, stacks up to 3 times)



function edm:UNIT_AURA(unitID)				--~  print("UNIT_AURA")
	local _ctime = GetTime()
	local idx = 1

	repeat
		local name, _, icon, count, _, duration, expirationTime, _, _, _, spellID = UnitAura(unitID, idx, nil, "PLAYER|HELPFUL")

		if (spellID and spellID == i_darkintent_p) then

			print(name, " count: ", count, ", duration: ", duration, ", expirationTime: ", expirationTime)

			if (count == 1) then

				print("DI 1 stack")

				di1beg_t = expirationTime - duration
				di1end_t = expirationTime

			elseif (count == 2) then

				print("DI 2 stacks")

				-- if we bump up, total out the 1 stack timer
				di1end_t = _ctime
				di1total_t = di1total_t + (di1end_t - di1beg_t)

				print((di1end_t - di1beg_t), " seconds of 1 stack")

				di2beg_t = expirationTime - duration
				di2end_t = expiration

			elseif (count == 3) then

				print("DI 3 stacks")

				-- if we bump up, total out 2 stack timer
				di2end_t = _ctime
				di2total_t = di2total_t + (di2end_t - di2beg_t)

				print((di2end_t - di2beg_t), " seconds of 2 stacks")

				-- we get 7 seconds of 3 stacks, so just add it on
				di3beg_t = expirationTime - duration
				di3total_t = di3total_t + duration
			end
		end

		idx = idx + 1

	until name == nil
 end

