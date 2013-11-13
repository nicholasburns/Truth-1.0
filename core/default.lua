local AddOn, Addon = ...							-- _G[AddOn]['default'] = {}


local P = _G[AddOn]['pixel']['P']


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
		['texture']	= Addon.media.background.solid,	-- Addon.default.border.texture
		['textureAlt']	= Addon.media.background.solid,	-- Addon.default.border.textureAlt
	},

  -- Addon.default.font
	font = {
		['file']		= Addon.media.font.continuum,		-- Addon.default.font.file
		['size']		= P[14],						-- Addon.default.font.size
		['flag']		= '',						-- Addon.default.font.flag
		['shad']		= P[1],						-- Addon.default.font.shad
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


Addon.default = default								-- _G[AddOn]['default'] = default
