local AddOn, Addon = ...


local color = {
	dead					= {089/255, 089/255, 089/255, 1, ['HEX'] = 'ff808080'},
	disconnected			= {214/255, 191/255, 165/255, 1, ['HEX'] = 'ffC0C0C0'}, -- disconnected = not UnitIsConnected(unit)
	flagged				= {255/255, 255/255, 000/255, 1, ['HEX'] = 'ffFFFF00'},
	ghost				= {051/255, 051/255, 191/255, 1, ['HEX'] = ''},
	hated				= {222/255, 095/255, 095/255, 1, ['HEX'] = 'ffFF0000'},
	tapped				= {140/255, 145/255, 155/255, 1, ['HEX'] = 'ffC0C0C0'},

	power = {
		['MANA']			= {079/255, 115/255, 166/255},	-- {0.31, 0.45, 0.63}
		['RAGE']			= {176/255, 079/255, 079/255},	-- {0.69, 0.31, 0.31}
		['FOCUS']			= {181/255, 110/255, 069/255},	-- {0.71, 0.43, 0.27}
		['ENERGY']		= {165/255, 166/255, 089/255},	-- {0.65, 0.63, 0.35}
		['RUNES']			= {140/255, 145/255, 155/255},	-- {0.55, 0.57, 0.61}
		['RUNIC_POWER']	= {000/255, 209/255, 255/255},	-- {0.00, 0.82, 1.00}
	},

	class = {
		['WARRIOR']		= {199/255, 156/255, 110/255,	['HEX'] = '|cffC79C6E'},
		['DEATHKNIGHT']	= {196/255, 030/255, 060/255,	['HEX'] = '|cffC41F3B'},
		['PALADIN']		= {245/255, 140/255, 186/255,	['HEX'] = '|cffF58CBA'},
		['MONK']			= {000/255, 255/255, 150/255,	['HEX'] = '|cff00FF96'},
		['PRIEST']		= {212/255, 212/255, 212/255,	['HEX'] = '|cffFFFFFF'},
		['SHAMAN']		= {041/255, 079/255, 155/255,	['HEX'] = '|cff0070DE'},
		['DRUID']			= {255/255, 125/255, 010/255,	['HEX'] = '|cffFF7D0A'},
		['ROGUE']			= {255/255, 243/255, 082/255,	['HEX'] = '|cffFFF569'},
		['MAGE']			= {104/255, 205/255, 255/255,	['HEX'] = '|cff69CCF0'},
		['WARLOCK']		= {148/255, 130/255, 201/255,	['HEX'] = '|cff9482C9'},
		['HUNTER']		= {171/255, 214/255, 116/255,	['HEX'] = '|cffABD473'},
	},

	reaction = {
		[1] = {222/255, 095/255, 095/255},		-- hated		[R]
		[2] = {222/255, 095/255, 095/255},		-- hostile	[R]
		[3] = {222/255, 095/255, 095/255},		-- unfriendly	[R]
		[4] = {218/255, 197/255, 092/255},		-- neutral	[Y]
		[5] = {075/255, 175/255, 075/255},		-- friendly	[G]
		[6] = {075/255, 175/255, 075/255},		-- honored	[G]
		[7] = {075/255, 175/255, 075/255},		-- revered	[G]
		[8] = {075/255, 175/255, 075/255},		-- exalted	[G]
	},

	reactionbackdrop = {
		[1] = {0.20, 0.20, 0.20},
		[2] = {0.30, 0.00, 0.00},
		[3] = {0.30, 0.15, 0.00},
		[4] = {0.30, 0.30, 0.00},
		[5] = {0.00, 0.30, 0.10},
		[6] = {0.00, 0.00, 0.50},
		[7] = {0.05, 0.05, 0.05},
	},

	runes = {
		[1] = {176/255, 079/255, 079/255},		-- {0.69, 0.31, 0.31}
		[2] = {084/255, 155/255, 084/255},		-- {0.33, 0.59, 0.33}
		[3] = {079/255, 115/255, 166/255},		-- {0.31, 0.45, 0.63}
		[4] = {214/255, 191/255, 165/255},		-- {0.84, 0.75, 0.65}
	},

	tooltip = {
		['CHAT']		= '|cffFFFFFF',	-- white
		['GUILD']		= '|cff0080CC',
		['LEVEL']		= '|cffC0C0C0',	-- grey
		['RACE']		= '|cffFFFFFF',	-- white
		['SAMEGUILD']	= '|cffFF32FF',	-- fusia
	},

	cff = {
		r		= '|cffFF82C5',
		o		= '|cffFF7F3F',
		y		= '|cffFFFF9A',	pale = '|cffFFFF80',
		g		= '|cff82FFC5',
		b		= '|cff82C5FF',	sky = '|cff66CCFF',
		i		= '|cffFF6699',
		v		= '|cff912CEE',

		white 	= '|cffFFFFFF',
		grey  	= '|cff82C5FF',
		black 	= '|cff000000',

		reaction = {
			[1]			= '|cffC0C0C0',	-- tapped
			[2]			= '|cffFF0000',
			[3]			= '|cffFF7F00',
			[4]			= '|cffFFFF00',	-- pvp flagged
			[5]			= '|cff00FF00',
			[6]			= '|cff25C1EB',
			[7]			= '|cff808080',	-- dead
		},
	},

	custom = {['PALE'] = '|cffFFFF80'},		-- gentle yellow
}

Addon.color = color
Addon[1]["Color"] = color

--================================================================================================--
--	Backup
--================================================================================================--
--[[	Regex Strings

	Hexadecimal (matches hex numbers)
	●	0x[0-9a-fA-F]+					0xcafebabe
	●	\|cff[0-9a-fA-F]+				|cffFF82C5

	C/C++ includes: matches valid include statements in C/C++ files:
	●	^#include[ \t]+[<"][^>"]+[">]		#include <iostream>					(also, #include "parent.h")

		if (true) then
	●	if (						(else|if)+\s+([\(])
	●	if (						(else|if)+[ \t]+([\(])

	Parentheses - (if)				if (true) then
	●	(else|if)+\s+([\(])			if (
	●	(else|if)+[ \t]+([\(])		if (

	Parentheses - if				if true then
	●	(else|if)+\s+([^\(])		if t


		if UnitPlayerControlled(unit)) then
			if UnitCanAttack(unit, 'player')) then
				break
			elseif UnitCanAttack('player', unit)) then
				return
			end
		elseif	not UnitCanAttack('player', unit)) then
			if					true) then
				r = 0
			elseif true) then
				r = 1
			end
		end

		if (UnitPlayerControlled(unit)) then
			if (UnitCanAttack(unit, 'player')) then
				break
			elseif (UnitCanAttack('player', unit)) then
				return
			end
		elseif	(not UnitCanAttack('player', unit)) then
			if					(true) then
				r = 0
			elseif (true) then
				r = 1
			end
		end
--]]


--==============================================--
--	Constants
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


--================================================================================================--
--[[	RAID_CLASS_COLORS = {											--@ Constants.lua
		['WARRIOR']	= {r = 0.78, g = 0.61, b = 0.43, colorStr = 'ffC79C6E'},
		['DEATHKNIGHT']= {r = 0.77, g = 0.12, b = 0.23, colorStr = 'ffC41F3B'},
		['PALADIN']	= {r = 0.96, g = 0.55, b = 0.73, colorStr = 'ffF58CBA'},
		['MONK']		= {r = 0.00, g = 1.00, b = 0.59, colorStr = 'ff00FF96'},
		['PRIEST']	= {r = 1.00, g = 1.00, b = 1.00, colorStr = 'ffFFFFFF'},
		['SHAMAN']	= {r = 0.00, g = 0.44, b = 0.87, colorStr = 'ff0070DE'},
		['DRUID']	= {r = 1.00, g = 0.49, b = 0.04, colorStr = 'ffFF7D0A'},
		['ROGUE']	= {r = 1.00, g = 0.96, b = 0.41, colorStr = 'ffFFF569'},
		['MAGE']		= {r = 0.41, g = 0.80, b = 0.94, colorStr = 'ff69CCF0'},
		['WARLOCK']	= {r = 0.58, g = 0.51, b = 0.79, colorStr = 'ff9482C9'},
		['HUNTER']	= {r = 0.67, g = 0.83, b = 0.45, colorStr = 'ffABD473'},
	}
--]]
--================================================================================================--
--[[ FACTION_BAR_COLORS = {											--@ ReputationFrame.lua
		[1] = {r = 0.80, g = 0.30, b = 0.22},	-- [Red]		Hated
		[2] = {r = 0.80, g = 0.30, b = 0.22},	-- [Red]		Hostile players are red
		[3] = {r = 0.75, g = 0.27, b = 0.00},	-- [Red]		Unfriendly
		[4] = {r = 0.90, g = 0.70, b = 0.00},	-- [Yellow]	Players we can attack but which are not hostile are yellow
		[5] = {r = 0.00, g = 0.60, b = 0.10},	-- [Green]	Always color friendships green
		[6] = {r = 0.00, g = 0.60, b = 0.10},	-- [Green]	Players we can assist but are PvP flagged are green
		[7] = {r = 0.00, g = 0.60, b = 0.10},	-- [Green]
		[8] = {r = 0.00, g = 0.60, b = 0.10},	-- [Green]
	}
--]]

--[=[ local function GTT_UnitColor(unit)

		-- UnitPlayerControlled
		-- -------------------------------------------------------
		--d:	Returns whether a unit is controlled by a player
		--u:	isPlayer = UnitPlayerControlled("unit")
		--r:	●(1) if unit is 'player-controlled-unit' (controlled by a player)
		--		●(nil) if unit is NPC
		-- -------------------------------------------------------

		local r, g, b

		-- Unit is a player (not NPC)
		if (UnitPlayerControlled(unit)) then

			-- Unit can attack me
			if (UnitCanAttack(unit, 'player')) then

				-- I cannot attack unit
				if (not UnitCanAttack('player', unit)) then									--[[ r = 1.0 g = 0.5 b = 0.5 ]]--[[ r = 0.0 g = 0.0 b = 1.0 ]]--
					r = 1.0
					g = 1.0
					b = 1.0
				else
					-- Hostile players are red
					r = FACTION_BAR_COLORS[2].r
					g = FACTION_BAR_COLORS[2].g
					b = FACTION_BAR_COLORS[2].b
				end

			-- I can attack unit
			elseif (UnitCanAttack('player', unit)) then

				-- Players we can attack but which are not hostile are yellow
				r = FACTION_BAR_COLORS[4].r
				g = FACTION_BAR_COLORS[4].g
				b = FACTION_BAR_COLORS[4].b


			-- Players we can not attack and who can not attack us
			elseif (UnitIsPVP(unit)) then

				-- Players we can assist but are PvP flagged are green
				r = FACTION_BAR_COLORS[6].r
				g = FACTION_BAR_COLORS[6].g
				b = FACTION_BAR_COLORS[6].b

			else
				-- All other players are blue (the usual state on the 'blue' server)				--[[ r = 0.0 g = 0.0 b = 1.0 ]]
				r = 1.0
				g = 1.0
				b = 1.0
			end

		-- Unit is an NPC
		else

			local reaction = UnitReaction(unit, 'player')

			--[[ UnitReaction
				d:	Determines the reaction of a 'unit' to 'other_unit'
				u:	reaction = UnitReaction('unit', 'other_unit')
				r:	● (number) Reaction Level of 'unit' towards 'other_unit' (1 to 8)
						1.Hated
						2.Hostile	*
						3.Unfriendly
						4.Neutral	*
						5.Friendly	*
						6.Honored
						7.Revered
						8.Exalted
					● (nil)If the reaction is UNKNOWN, returns nil
			--]]

			if (reaction) then
				r = FACTION_BAR_COLORS[reaction].r
				g = FACTION_BAR_COLORS[reaction].g
				b = FACTION_BAR_COLORS[reaction].b
			else																		--[[ r = 0.0 g = 0.0 b = 1.0 ]]
				r = 1.0
				g = 1.0
				b = 1.0
			end
		end

		return r, g, b
	end
--]=]

--================================================================================================--


--================================================================================================--

--	Notes

--================================================================================================--
--[[	T['c'] = {
		unknown	= {3/5, 3/5, 3/5},

		grey	= {1/3, 1/3, 1/3},
		silver	= {8/9, 8/9, 8/9},

		red		= {4/5, 2/5, 2/5},
		green	= {1/3, 4/5, 1/3},
		blue		= {1/5, 2/5, 3/4},

		skyblue	= {1/2, 8/9, 1/1},		-- mage blue
		darkblue	= {1/5, 1/3, 3/4},		-- shaman blue

		bnet		= {0, 2/3, 1},		-- bnet blue
		mage		= {1/2, 8/9, 1},		-- mage blue
		shaman	= {1/5, 1/3, 3/4},		-- shaman blue

		yellow	= {4/5, 4/5, 1/5},		-- energy yellow
		brown	= {8/9, 3/4, 1/2},		-- warrior brown
	}

	F['C'] = {
		red		= {175/255, 0/255, 0/255},
		green	= { 75/255, 175/255,75/255},
		blue	= { 85/255,85/255, 175/255},
		grey	= { 85/255,85/255,85/255},
	}
--]]

--[[ Notes:

	0 0 0/225
	------------------------
	 .1 1/9 *23/225
	 .2 1/545/225
	 .3 1/368/225
	 .4 2/590/225
	------------------------
	 .5 1/2 112/225
	------------------------
	 .6 3/5 135/225
	 .7 3/4 158/225
	 .8 4/5 180/225
	 .9 8/9 * 203/225
	------------------------
	1 1 225/225

	* = ballparked
--]]


--================================================================================================--

--	Class Color
--	Prat3.0\services\classcolor.lua

--================================================================================================--
--[[ T.GetClassColor = function(class)
		class = class:upper()

		if (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) then
			return CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
		end

		if (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]) then
			return RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
		end

		return 0.63, 0.63, 0.63
	end
--]]

--================================================================================================--

--	Backkup

--================================================================================================--
-- ['AMMOSLOT'] = {0.8, 0.6, 0.0}, ['FUEL'] = {0.0, 0.5, 0.5}, ['POWER_TYPE_STEAM'] = {0.5, 0.6, 0.6}, ['POWER_TYPE_PYRITE'] = {0.6, 0.1, 0.2},

--[[	Reaction = { -- Hated, Hostile, Unfriendly, Neutral, Friendly, Honored, Revered, Exalted, Tapped, Dead } ]]

--[[ T.UnitColor (unmodified)
	T.UnitColor = {
		tapped = {0.55, 0.57, 0.61},
		disconnected = {0.84, 0.75, 0.65},
		power = {
			['MANA'] = {0.31, 0.45, 0.63},
			['RAGE'] = {0.69, 0.31, 0.31},
			['FOCUS'] = {0.71, 0.43, 0.27},
			['ENERGY'] = {0.65, 0.63, 0.35},
			['RUNES'] = {0.55, 0.57, 0.61},
			['RUNIC_POWER'] = {0, 0.82, 1},
			['AMMOSLOT'] = {0.8, 0.6, 0},
			['FUEL'] = {0, 0.55, 0.5},
			['POWER_TYPE_STEAM'] = {0.55, 0.57, 0.61},
			['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17},
		},
		runes = {
				[1] = {.69,.31,.31},
				[2] = {.33,.59,.33},
				[3] = {.31,.45,.63},
				[4] = {.84,.75,.65},
		},
		reaction = {
			[1] = { 222/255, 95/255,95/255 }, -- Hated
			[2] = { 222/255, 95/255,95/255 }, -- Hostile
			[3] = { 222/255, 95/255,95/255 }, -- Unfriendly
			[4] = { 218/255, 197/255, 92/255 }, -- Neutral
			[5] = { 75/255,175/255, 76/255 }, -- Friendly
			[6] = { 75/255,175/255, 76/255 }, -- Honored
			[7] = { 75/255,175/255, 76/255 }, -- Revered
			[8] = { 75/255,175/255, 76/255 }, -- Exalted
		},
		class = {
			['DEATHKNIGHT'] = { 196/255,30/255,60/255 },
			['DRUID'] = { 255/255, 125/255,10/255 },
			['HUNTER']= { 171/255, 214/255, 116/255 },
			['MAGE']= { 104/255, 205/255, 255/255 },
			['PALADIN'] = { 245/255, 140/255, 186/255 },
			['PRIEST']= { 212/255, 212/255, 212/255 },
			['ROGUE'] = { 255/255, 243/255,82/255 },
			['SHAMAN']= {41/255,79/255, 155/255 },
			['WARLOCK'] = { 148/255, 130/255, 201/255 },
			['WARRIOR'] = { 199/255, 156/255, 110/255 },
			['MONK']= { 0/255, 255/255, 150/255 },
		},
	}
--]]

--[[ bUnitFrames colors
	PowerBarColor['MANA']		= {r = 48/255, g = 113/255, b = 191/255}
	PowerBarColor['RAGE']		= {r = 255/255, g = 1/255, b = 1/255}
	PowerBarColor['FOCUS']		= {r = 255/255, g = 178/255, b = 0}
	PowerBarColor['ENERGY']		= {r = 1, g = 1, b = 34/255}
	PowerBarColor['CHI']		= {r = 1, g = 1, b = 34/255}
	PowerBarColor['RUNES']		= {r = .55, g = .57, b = .61}
	PowerBarColor['RUNIC_POWER']	= {r = 1, g = 0, b = 34/255}
	PowerBarColor['AMMOSLOT']	= {r = .8, g = .6, b = 0}
--]]

--[[ T.UnitColor = {					-- Text Power Class Reaction Runes Tapped Dead Disconnected
		tapped = {
			[1] = 0.55,
			[2] = 0.57,
			[3] = 0.61,
		},
		disconnected = {
			[1] = 0.84,
			[2] = 0.75,
			[3] = 0.65,
		},
		runes = {
			[1] = {0.69, 0.31, 0.31},
			[2] = {0.33, 0.59, 0.33},
			[3] = {0.31, 0.45, 0.63},
			[4] = {0.84, 0.75, 0.65},
		},
		reaction = {
			[1] = {222/255, 95/255,95/255},	-- Hated
			[2] = {222/255, 95/255,95/255},	-- Hostile
			[3] = {222/255, 95/255,95/255},	-- Unfriendly
			[4] = {218/255, 197/255, 92/255},	-- Neutral
			[5] = {75/255,175/255, 76/255},	-- Friendly
			[6] = {75/255,175/255, 76/255},	-- Honored
			[7] = {75/255,175/255, 76/255},	-- Revered
			[8] = {75/255,175/255, 76/255},	-- Exalted
		},
		power = {
			['MANA']					= {0.31, 0.45, 0.63},
			['RAGE']					= {0.69, 0.31, 0.31},
			['FOCUS']				= {0.71, 0.43, 0.27},
			['ENERGY']				= {0.65, 0.63, 0.35},
			['RUNES']				= {0.55, 0.57, 0.61},
			['RUNIC_POWER']			= { 0, 0.82,1},
			['AMMOSLOT']				= {0.80, 0.60,0},
			['FUEL']					= { 0, 0.55, 0.50},
			['POWER_TYPE_STEAM']		= {0.55, 0.57, 0.61},
			['POWER_TYPE_PYRITE']		= {0.60, 0.09, 0.17},
		},
		class = {
			['DEATHKNIGHT']			= {196/255,30/255,60/255},
			['DRUID']			= {255/255, 125/255,10/255},
			['HUNTER']			= {171/255, 214/255, 116/255},
			['MAGE']			= {104/255, 205/255, 255/255},
			['PALADIN']			= {245/255, 140/255, 186/255},
			['PRIEST']			= {212/255, 212/255, 212/255},
			['ROGUE']			= {255/255, 243/255,82/255},
			['SHAMAN']			= { 41/255,79/255, 155/255},
			['WARLOCK']			= {148/255, 130/255, 201/255},
			['WARRIOR']			= {199/255, 156/255, 110/255},
			['MONK']			= {0/255, 255/255, 150/255},
		},
	}
--]]
