local AddOn, Addon = ...			--[[ local L = setmetatable({}, {__index = function(t, k) local v = tostring(k) rawset(t, k, v) return v end}) ]]
-- _G[AddOn][3] = {}

local C, T, Locale = unpack(select(2, ...))


-- _G[AddOn]['L'] = {}


local L = {}

--==============================================--
--	Random
--==============================================--
L['OUTBOUND'] = '»'


--==============================================--
--	Chat
--==============================================--
L['Chat']	= 'Chat'
L['From']	= 'From'
L['To'] 	= 'To'
L['G'] 	= 'G'
L['O'] 	= 'O'
L['I'] 	= 'I'
L['IL'] 	= 'IL'
L['P'] 	= 'P'
L['PL'] 	= 'PL'
L['R'] 	= 'R'
L['RL'] 	= 'L'
L['RW'] 	= 'RW'
L['PB'] 	= 'PB'						-- petbattle
L['<AFK>']= '<AFK>'
L['<DND>']= '<DND>'
L['has come |cff298F00online|r' ] = 'has come |cff298F00online|r'
L['has gone |cffff0000offline|r'] = 'has gone |cffff0000offline|r'

--==============================================--
--	Tooltip
--==============================================--
L['Item ID:'] 		= 'Item ID:'
L['Item count:'] 	= 'Item count:'
L['Spell ID:'] 	= 'Spell ID:'
L['Targeted By'] 	= '|cffFF0000Targeted By:|r'


--==============================================--
--	Raid Symbols
--==============================================--
L['SKULL']	= '|cffFFFFFF Skull |r'
L['CROSS']	= '|cffFF0000 Cross |r'
L['SQUARE']	= '|cff00FFFF Square |r'
L['MOON']		= '|cffC7C7C7 Moon |r'
L['TRIANGLE']	= '|cff00FF00 Triangle |r'
L['DIAMOND']	= '|cff912CEE Diamond |r'
L['CIRCLE']	= '|cffFF8000 Circle |r'
L['STAR']		= '|cffFFFF00 Star |r'
L['-----']	= '-------------------'
L['CLEAR']	= '|cffCCCCCC Clear |r'

L.symbol_CLEAR 	= 'Clear'
L.symbol_SKULL 	= 'Skull'
L.symbol_CROSS 	= 'Cross'
L.symbol_SQUARE 	= 'Square'
L.symbol_MOON 		= 'Moon'
L.symbol_TRIANGLE 	= 'Triangle'
L.symbol_DIAMOND 	= 'Diamond'
L.symbol_CIRCLE 	= 'Circle'
L.symbol_STAR 		= 'Star'

-- L['SKULL']	= '|cffFFFFFF Skull |r'
-- L['CROSS']	= '|cffFF0000 Cross |r'
-- L['SQUARE']	= '|cff00FFFF Square |r'
-- L['MOON']		= '|cffC7C7C7 Moon |r'
-- L['TRIANGLE']	= '|cff00FF00 Triangle |r'
-- L['DIAMOND']	= '|cff912CEE Diamond |r'
-- L['CIRCLE']	= '|cffFF8000 Circle |r'
-- L['STAR']		= '|cffFFFF00 Star |r'
-- L['-----']	= '-------------------'
-- L['CLEAR']	= '|cffCCCCCC Clear |r'


-- L['Raid Markers'] = true
-- L['|cffFFFFFF Skull |r'] = '|cffFFFFFF Skull |r'
-- L['|cffFF0000 Cross |r'] = '|cffFF0000 Cross |r'
-- L['|cff00FFFF Square |r'] = '|cff00FFFF Square |r'
-- L['|cffC7C7C7 Moon |r'] = '|cffC7C7C7 Moon |r'
-- L['|cff00FF00 Triangle |r'] = '|cff00FF00 Triangle |r'
-- L['|cff912CEE Diamond |r'] = '|cff912CEE Diamond |r'
-- L['|cffFF8000 Circle |r'] = '|cffFF8000 Circle |r'
-- L['|cffFFFF00 Star |r'] = '|cffFFFF00 Star |r'
-- L['-------------------'] = '-------------------'
-- L['|cffCCCCCC Clear |r'] = '|cffCCCCCC Clear |r'


--==============================================--
--	Interface
--==============================================--
-- addon[3] = L 														-- Addon.L = L


-- _G[AddOn][3] = L

Locale = L
