local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local P = A["PixelSizer"]
local X = A["PixelSize"]

-- FolderLocation = _G.debugstack():match("Truth\\(.-)\\")


--==============================================--
--	C
--==============================================--
C["Addon"] = {
	["Enable"] = true,
	["Numbers"] = {
		["Enable"] = true,
	},
	["SV"] = {
		["Enable"] = false,
	},
	["Text"] = {
		["Enable"] = true,
	},
	["Time"] = {
		["Enable"] = true,
		["UseLocal"] = true,
	},
}

C["Debug"] = {
	["Enable"] = true,
	["Dump"] = {
		["Enable"] = true,
		["Font"] = {Addon.media.font.myriad, P[14], nil, P[1]},
		["ButtonNormal"] = [=[Interface\BUTTONS\UI-Panel-CollapseButton-Disabled]=],
		["ButtonHighlight"] = [=[Interface\BUTTONS\UI-Panel-CollapseButton-Up]=],
	  -- ["ButtonDisabled"] = [=[Interface\BUTTONS\UI-Panel-CollapseButton-Disabled]=],
	  -- ["ButtonHighlight"] = [=[Interface\BUTTONS\UI-Panel-CollapseButton-Down]=],
	},
}

C["AOM"] = {
	["Enable"] = true,
}

C["Announce"] = {
	["Enable"] = true,
	["Experience"] = {
		["Enable"] = true,
		["Announcements"] = true,
		["EventCounter"] = 0,
		["RunningTotal"] = 0,
		["Timestamp"] = "",
	},
	["Interrupts"] = {
		["Enable"] = true,
	},
	["Lowhealth"] = {
		["Enable"] = true,
		["Threshold"] = 50,
		["Message"] = '- LOW HEALTH -',
		["Sound"] = Addon.media.sound.warn,
		["Font"] = {Addon.media.font.grunge, P[30], 'THICKOUTLINE'},
	},
	["Reputation"] = {
		["Enable"] = true,
		["Announcements"] = true,
		["EventCounter"] = 0,
		["RunningTotal"] = 0,
		["Timestamp"] = "",
	},
	["Spells"] = {
		["Enable"] = true,
		["AllSources"] = true,
		["MessageFormat"] = '%s used %s',
		["Playername"] = A["MyName"],
		["SpellIDs"] = {
			34477,	-- Misdirection
			19801,	-- Tranquilizing Shot
			57934,	-- Tricks of the Trade
			633,		-- Lay on Hands
			20484,	-- Rebirth
			113269,	-- Rebirth (Symbiosis)
			61999,	-- Raise Ally
			20707,	-- Soulstone
			2908,	-- Soothe
			120668,	-- Stormlash Totem
			16190,	-- Mana Tide Totem
			64901,	-- Hymn of Hope
			108968,	-- Void Shift
		},
	},
}

C["Aura"] = {
	["Enable"] = true,
--~  ["Lib"] = {},							--~  Currently a stand-alone Lib
	["CP"] = {
		["Enable"] = false,
		["Size"] = P[30],
		["Scale"] = P[2],
		["Pad"] = P[3],
		["Point"] = {"CENTER", UIParent, "CENTER", 0, 0},
		["Backdrop"] = {Addon.template.backdrop},
	},
	["Status"] = {
		["Enable"] = false,
		["IconTexture"] = [=[Interface\BUTTONS\Spell-Reset]=],		-- sword
	  -- ["IconTexture"] = [=[Interface\Icons\ABILITY_DUALWIELD]=],	-- dualwield
	},
	["StealthFX"] = {
		["Enable"] = false,
	},
	["UNIT_AURA"] = {
		["Enable"] = true,
	},
}

C["Automation"] = {
	["Enable"] = true,
	["Merchant"] = {
		["Enable"] = true,
	},
	["Release"] = {
		["Enable"] = true,
	},
}

C["Bar"] = {
	["Enable"] = true,
	["Bags"] = {
		["Enable"] = true,
	},
	["Cooldown"] = {
		["Enable"] = false,
		["Font"] = {Addon.media.font.visitor, P[18], 'OUTLINE', P[1], { 0, 0, 0, .8 }},
	},
}

C["Character"] = {
	["Enable"] = true,
	["Slots"] = {
		["Enable"] = true,
	},
}

C["Chat"] = {
	["Enable"] = true,
	["Armory"] = {
		["Enable"] = true,
	},
	["Bubble"] = {
		["Enable"] = true,
	},
	["Channels"] = {
		["Enable"] = true,
		["Default"] = "%s|| ",
		["FormatString"] = "%s ",
		["ChannelFormat"] = "%s ",
	},
	["Copy"] = {
		["Enable"] = true,
		["ButtonNormal"] = [=[Interface\BUTTONS\UI-GuildButton-PublicNote-Disabled]=],
		["ButtonHighlight"] = [=[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]=],
	},
	["Icon"] = {
		["Enable"] = true,
	},
	["Sounds"] = {
		["Enable"] = true,
	},
	["Tab"] = {
		["Enable"] = true,
		["Font"] = {Addon.media.font.myriad, P[20], 'OUTLINE', P[1]},
	},
	["Url"] = {
		["Enable"] = true,
	},
	['Font'] = {Addon.media.font.myriad, P[14], nil, P[1]},
	['Width'] = 520 * X,
	['Height'] = 250 * X,
	['Point'] = {'BOTTOMLEFT',  UIParent,  5, 5},
	['Point4'] = {'BOTTOMRIGHT', UIParent, -5, 5},
	['Windows'] = 4,
}

C["Map"] = {
	["Enable"] = true,
	["Worldmap"] = {
		["Enable"] = false,
		["Scale"] = 0.8,
		["Font"] = {Addon.default.font.file, P[20], 'OUTLINE', P[2]},
	},
}

C["Quest"] = {
	["Enable"] = true,
	["Wowhead"] = {
		["Enable"] = true,
	},
}

C["Skin"] = {
	["Enable"] = true,
	["Auction"] = {
		["Enable"] = true,
	},
	["DebugTools"] = {
		["Enable"] = true,
	},
}

C["Tooltip"] = {
	["Enable"] = true,
	["Compare"] = true,						--
	["Cursor"] = {							-- Anchor tooltip to cursor
		["Enable"] = false,
	},
	["Journal"] = true,
	["Icon"] = {
		["Enable"] = false,
		["Size"] = 24,
	},
	["Text"] = {
		["Enable"] = false,					-- Display tooltip text
		["PvP"] = false,
		["Realms"] = false,
	},
	["ToT"] = {
		["Enable"] = true,
		["PvP"] = false,					-- Display player pvp status
		["Faction"] = false,				-- Dispaly player faction
		["Realms"] = false,					-- Display player realm names
		["GreenTip"] = false,
		["LookingAtMe"] = false,
	},
	["Statusbar"] = {
		["Enable"] = true,
		["Font"]   = {Addon.media.font.continuum, P[12]},
		["Statusbar"] = {
			["Enable"]  = true,
			["Texture"] = Addon.media.statusbar.flat,
			["Width"]   = 200,
			["Height"]  = 6,
			["Inset"]   = 2,
		},
	},
}





--==============================================--
--	Backup
--==============================================--
--[[ Print Wrapper

	local print = function(prefix, amount)
		Addon.print('reputation', prefix, amount)
	end
--]]
