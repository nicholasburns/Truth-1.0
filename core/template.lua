local AddOn, Addon = ...


local P = Addon[1]["PixelSizer"] or 1


--==============================================--
--	Template
--==============================================--
local template = {

  -- Addon.template.backdrop
	backdrop = {
		['bgFile']   	= Addon.media.background.solid,	-- Addon.template.backdrop.bgFile
		['tile']     	= false,						-- Addon.template.backdrop.tile
		['tileSize'] 	= 0,							-- Addon.template.backdrop.tileSize
		['edgeFile'] 	= Addon.media.border.solid,		-- Addon.template.backdrop.edgeFile
		['edgeSize'] 	= P[1],						-- Addon.template.backdrop.edgeSize
		['insets']   	= {							-- Addon.template.backdrop.insets
			left = -P[1], right = -P[1], top = -P[1], bottom = -P[1]
		},
	},

}


Addon.template = template
