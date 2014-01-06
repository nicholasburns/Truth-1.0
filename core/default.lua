local AddOn, Addon = ...


local P = Addon[1]["PixelSizer"] or 1


--==============================================--
--	Default
--==============================================--
local default = {

  -- Addon.default.backdrop
	backdrop = {
		['color']		= {.1, .1, .1, 1},				-- Addon.default.backdrop.color
		['colorAlt']	= {.2, .2, .2, 1},				-- Addon.default.backdrop.colorAlt
		['texture']	= Addon.media.background.solid,	-- Addon.default.backdrop.texture
		['textureAlt']	= Addon.media.background.tooltip,	-- Addon.default.backdrop.textureAlt
	},

  -- Addon.default.border
	border = {
		['color']		= {.6, .6, .6, 1},				-- Addon.default.border.color
		['texture']	= Addon.media.border.solid,		-- Addon.default.border.texture
		['textureAlt']	= Addon.media.border.white,		-- Addon.default.border.textureAlt
	},

  -- Addon.default.font
	font = {
		[1]			= Addon.media.font.continuum,		-- Addon.default.font[1]
		[2]			= P[14],						-- Addon.default.font[2]
		[3]			= '',						-- Addon.default.font[3]
		[4]			= P[1],						-- Addon.default.font[4]
		['file']		= Addon.media.font.continuum,		-- Addon.default.font.file
		['size']		= P[14],						-- Addon.default.font.size
		['flag']		= '',						-- Addon.default.font.flag
		['shad']		= P[1],						-- Addon.default.font.shad
	},

  -- Addon.default.pxfont
	pxfont = {
		[1]			= Addon.media.font.visitor,		-- Addon.default.pxfont[1]
		[2]			= P[14],						-- Addon.default.pxfont[2]
		[3]			= '',						-- Addon.default.pxfont[3]
		[4]			= P[1],						-- Addon.default.pxfont[4]
		['file']		= Addon.media.font.visitor,		-- Addon.default.pxfont.file
		['size']		= P[14],						-- Addon.default.pxfont.size
		['flag']		= '',						-- Addon.default.pxfont.flag
		['shad']		= P[1],						-- Addon.default.pxfont.shad
	},

  -- Addon.default.overlay
	overlay = {
		['color']		= {0, 0, 0, .7},				-- Addon.default.overlay.color
		['texture']	= Addon.media.background.solid,	-- Addon.default.overlay.texture
	},

  -- Addon.default.statusbar
	statusbar = {
		['color']		= {0, 1, 0, 1},				-- Addon.default.statusbar.color
		['texture']	= Addon.media.statusbar.flat,		-- Addon.default.statusbar.texture
	},
}


Addon.default = default
