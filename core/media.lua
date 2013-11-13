-- credit: MSBT by Mikord
local AddOn, Addon = ...
local module = {}
local moduleName = "media"
_G[AddOn][moduleName] = module
--[[ _G.Truth.media = {} ]]



--==============================================--
--	Constants
--==============================================--
local ADDON_PATH		= 'Interface\\AddOns\\' .. AddOn .. '\\'
local MEDIA_PATH		= 'Interface\\AddOns\\' .. AddOn .. '\\media\\'
local BACKGROUND_PATH	= 'Interface\\AddOns\\' .. AddOn .. '\\media\\background\\'
local BORDER_PATH		= 'Interface\\AddOns\\' .. AddOn .. '\\media\\border\\'
local FONT_PATH		= 'Interface\\AddOns\\' .. AddOn .. '\\media\\font\\'
local STATUSBAR_PATH	= 'Interface\\AddOns\\' .. AddOn .. '\\media\\statusbar\\'
local SOUND_PATH		= 'Interface\\AddOns\\' .. AddOn .. '\\media\\sound\\'

-- LibSharedMedia
local LSM = LibStub('LibSharedMedia-3.0')
local LSM_LANG_MASK_ALL = 255


--==============================================--
--	Private Variables
--==============================================--
local media = {
	background = {
		['solid']		= BACKGROUND_PATH .. 'solid.tga',
		['tooltip']	= [=[Interface\Tooltips\UI-Tooltip-Background]=],
		['white8X8']	= [=[Interface\BUTTONS\WHITE8X8]=],
	},
	border = {
		['glow']		= BORDER_PATH .. 'glow.tga',
		['solid']		= BORDER_PATH .. 'solid.tga',
		['white']		= BORDER_PATH .. 'white.tga',
	},
	font = {
	  -- 'Interface\\AddOns\\Truth\\media\\font\\continuum.ttf'
		['continuum']	= FONT_PATH .. 'continuum.ttf',	-- NORMAL | Monospace
		['grunge']	= FONT_PATH .. 'grunge.ttf',		--		  Alerts
		['myriad']	= FONT_PATH .. 'myriad.ttf',		-- NUMBER | Condensed
		['visitor']	= FONT_PATH .. 'visitor.ttf',		-- COMBAT | Pixel
		['zekton']	= FONT_PATH .. 'zekton.ttf',		-- HEADER | Modern
	},
	statusbar = {
		['flat'] 		= STATUSBAR_PATH .. 'flat.tga',
		['glow'] 		= STATUSBAR_PATH .. 'glow.tga',
		['minimal'] 	= STATUSBAR_PATH .. 'minimal.tga',
		['rich']		= STATUSBAR_PATH .. 'rich.tga',
		['smooth']	= STATUSBAR_PATH .. 'smooth.tga',
	},
	sound = {
		['acquire']	= SOUND_PATH .. 'acquire.mp3',
		['electronic']	= SOUND_PATH .. 'estring.mp3',
		['error']		= SOUND_PATH .. 'error.mp3',
		['msn']		= SOUND_PATH .. 'msn.mp3',
		['warn']		= SOUND_PATH .. 'warn.ogg',
		['femalewarn']	= SOUND_PATH .. 'femalewarn.mp3',
		['whisper']	= SOUND_PATH .. 'whisper.mp3',	-- Addon.media.sound.whisper
		['yoshi']		= SOUND_PATH .. 'yoshi.mp3',
		['zelda']		= SOUND_PATH .. 'zelda.mp3',
	},
}


--==============================================--
--	Functions
--==============================================--
local function RegisterBackground(name, path)
	media.background[name] = path
	LSM:Register('background', name, path)
end
local function RegisterBorder(name, path)
	media.border[name] = path
	LSM:Register('border', name, path)
end
local function RegisterFont(name, path)
	media.font[name] = path
	LSM:Register('font', name, path, LSM_LANG_MASK_ALL)
end
local function RegisterStatusbar(name, path)
	media.statusbar[name] = path
	LSM:Register('statusbar', name, path)
end
local function RegisterSound(name, path)
	media.sound[name] = path
	LSM:Register('sound', name, path)
end


--==============================================--
--	Event Handlers
--==============================================--
local function LSMRegistered(event, mediatype, name)							-- called by SM when media is registered
	if (mediatype == "background") then
		media.background[name] = LSM:Fetch(mediatype, name)
	elseif (mediatype == "border") then
		media.border[name] = LSM:Fetch(mediatype, name)
	elseif (mediatype == "font") then
		media.font[name] = LSM:Fetch(mediatype, name)
	elseif (mediatype == "statusbar") then
		media.statusbar[name] = LSM:Fetch(mediatype, name)
	elseif (mediatype == "sound") then
		media.sound[name] = LSM:Fetch(mediatype, name)
	end
end

--==============================================--
--	Initialization:  Register default media
--==============================================--
for name, path in pairs(media.background) do RegisterBackground(name, path) end
for name, path in pairs(media.border)     do RegisterBorder(name, path)     end
for name, path in pairs(media.font)       do RegisterFont(name, path)       end
for name, path in pairs(media.statusbar)  do RegisterStatusbar(name, path)  end
for name, path in pairs(media.sound)      do RegisterSound(name, path)      end

-- Register a callback with SM to keep us synced
LSM.RegisterCallback("TruthSharedMedia", "LibSharedMedia_Registered", LSMRegistered)


--==============================================--
--	Media Interface
--==============================================--
-- media.path						= MEDIA_PATH
-- media.backgroundpath				= BACKGROUND_PATH
-- media.borderpath 				= BORDER_PATH
-- media.fontpath 					= FONT_PATH
-- media.statusbarpath				= STATUSBAR_PATH
-- media.soundpath 					= SOUND_PATH


Addon.media = media
-- _G[AddOn]['media'] = media

--[[Addon.RegisterBackground 			= RegisterBackground
Addon.RegisterBorder 				= RegisterBorder
Addon.RegisterFont 					= RegisterFont
Addon.RegisterStatusbar				= RegisterStatusbar
Addon.RegisterSound 				= RegisterSound
--]]

--================================================================================================--

--	Backup

--================================================================================================--
--[[ Iterators

	local function IterateBackgrounds()	return pairs(media.background) end
	local function IterateBorders()		return pairs(media.border) end
	local function IterateFonts() 		return pairs(media.font) end
	local function IterateStatusbars()		return pairs(media.statusbar) end
	local function IterateSounds()		return pairs(media.sound) end
--]]

--[[	LibSharedMedia Mediatypes

	lib.MediaType.BACKGROUND			= "background"
	lib.MediaType.BORDER			= "border"
	lib.MediaType.FONT				= "font"
	lib.MediaType.STATUSBAR			= "statusbar"
	lib.MediaType.SOUND				= "sound"
--]]

--[[ Paths

	local path = {
		['media']					= ADDON_PATH .. '\\media\\',
		['background']				= ADDON_PATH .. '\\media\\background\\',
		['border']				= ADDON_PATH .. '\\media\\border',
		['font']					= ADDON_PATH .. '\\media\\font\\',
		['statusbar']				= ADDON_PATH .. '\\media\\statusbar\\',
		['sound']					= ADDON_PATH .. '\\media\\sound\\',
	}
--]]
--[[ Media Table

	local media = {
		background = {
			['invisible']	= BACKGROUND_PATH .. 'invisible.tga',
			['solid']		= BACKGROUND_PATH .. 'solid.tga',
		},
		border = {
			['glow']		= BORDER_PATH .. 'glow.tga',
			['solid']		= BORDER_PATH .. 'solid.tga',
			['white']		= BORDER_PATH .. 'white.tga',
		},
		font = {
			['continuum']	= FONT_PATH .. 'continuum.ttf',	-- NORMAL | Monospace
			['grunge']	= FONT_PATH .. 'grunge.ttf',		--		  Alerts
			['myriad']	= FONT_PATH .. 'myriad.ttf',		-- NUMBER | Condensed
			['visitor']	= FONT_PATH .. 'visitor2.ttf',	-- COMBAT | Pixel
			['zekton']	= FONT_PATH .. 'zekton.ttf',		-- HEADER | Modern
		},
		statusbar = {
			['flat'] 		= STATUSBAR_PATH .. 'flat.tga',
			['glow'] 		= STATUSBAR_PATH .. 'glow.tga',
			['minimal'] 	= STATUSBAR_PATH .. 'minimal.tga',
			['rich']		= STATUSBAR_PATH .. 'rich.tga',
			['smooth']	= STATUSBAR_PATH .. 'smooth.tga',
		},
		sound = {
			['acquire']	= SOUND_PATH .. 'acquire.mp3',
			['electronic']	= SOUND_PATH .. 'estring.mp3',
			['error']		= SOUND_PATH .. 'error.mp3',
			['msn']		= SOUND_PATH .. 'msn.mp3',
			['warn']		= SOUND_PATH .. 'warn.ogg',
			['fwarn']		= SOUND_PATH .. 'fwarn.mp3',
			['whisper']	= SOUND_PATH .. 'whisper.mp3',
			['yoshi']		= SOUND_PATH .. 'yoshi.mp3',
			['zelda']		= SOUND_PATH .. 'zelda.mp3',
		},
	}
--]]
--==============================================--
--	Game Fonts
--==============================================--
--[[ local Fontlist = {
		GameFontNormal,
		GameFontHighlight,
		GameFontDisable,
		GameFontNormalSmall,
		GameFontHighlightExtraSmall,
		GameFontHighlightMedium,
		GameFontNormalLarge,
		GameFontNormalHuge,
		GameFont_Gigantic,
		BossEmoteNormalHuge,
		NumberFontNormal,
		NumberFontNormalSmall,
		NumberFontNormalLarge,
		NumberFontNormalHuge,
		ChatFontNormal,
		ChatFontSmall,
		DialogButtonNormalText,
		ZoneTextFont,
		SubZoneTextFont,
		PVPInfoTextFont,
		QuestFont_Super_Huge,
		QuestFont_Shadow_Small,
		ErrorFont,
		TextStatusBarText,
		CombatLogFont,
		GameTooltipText,
		GameTooltipTextSmall,
		GameTooltipHeaderText,
		WorldMapTextFont,
		CombatTextFont,
		MovieSubtitleFont,
		AchievementPointsFont,
		AchievementPointsFontSmall,
		AchievementDescriptionFont,
		AchievementCriteriaFont,
		AchievementDateFont,
		ReputationDetailFont,
		QuestTitleFont,
		QuestFont,
		QuestFontNormalSmall,
		QuestFontHighlight,
		ItemTextFontNormal,
		MailTextFontNormal,
		SubSpellFont,
		InvoiceTextFontNormal,
		InvoiceTextFontSmall,
	}
--]]
