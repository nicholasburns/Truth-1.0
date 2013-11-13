local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))


local P = _G[AddOn]['pixel']['P']
local px = _G[AddOn]['pixel']['px']


--==============================================--
--	C
--==============================================--
C["AOM"] = {
	["Enable"] = true,
}

C["Numbers"] = {
	["Enable"] = true,
}

C["Time"] = {
	["Enable"] = true,
	["UseLocal"] = true,
}

C["Announce"] = {
	["Enable"] = true,
	["Experience"] = {
		["Enable"] = true,
		["Counter"] = 0,
		["Timestamp"] = '',
		["Announces"] = '',
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
		["Counter"] = 0,
		["Timestamp"] = '',
		["Announcements"] = true,
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

C["Automation"] = {
	["Enable"] = true,
	["Merchant"] = {
		["Enable"] = true,
	},
	["Release"] = {
		["Enable"] = false,
	},
}

C["Bar"] = {
	["Enable"] = true,
	["Bags"] = {
		["Enable"] = true,
	},
	["Cooldown"] = {
		["Enable"] = true,
		["Font"] = {Addon.media.font.visitor, P[22], 'OUTLINE', P[1], { 0, 0, 0, .8 }},
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
	["Sounds"] = true,
	["Bags"]	= true,
	["Bubbles"] = true,
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
	["Tab"] = {
		["Enable"] = true,
		["Font"] = {Addon.media.font.myriad, P[20], 'OUTLINE', P[1]},
	},
	["Url"] = {
		["Enable"] = true,
	},
	['Font'] = {Addon.media.font.myriad, P[14], nil, P[1]},
	['Width'] = 520 * px,
	['Height'] = 250 * px,
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
		["Enable"] = false,
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
		["Enable"] = true,					-- Display tooltip text
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

C["Unit"] = {
	["Enable"] = true,
	["Status"] = {
		["Enable"] = true,
	},
}




--==============================================--
--	Unused
--==============================================--
--[[
C["Ampere"] = {
	["Enable"] = true,
}

C["Announce"]["Readycheck"] = {
	["Enable"] = false,
}


C["CombatStatus"] = {
	["Enable"] = false,
}
C["Slots"] = {
	["Enable"] = false,
}
C["RaidMarkers"] = {
	["Enable"] = false,
}
C["Chat"]["Armory"] = false
C["Chat"]["Filter"] = false
C["Chat"]["Scroll"] = false
C["Chat"]["Timestamp"] = {
	["Enable"] = true,
}

C["Tooltip"]["Anchor"] = false						-- Anchor tooltip to default position when appropriate (mousing over a unitframe, etc.)
--]]

--==============================================--
--	Backup
--==============================================--
--[[ Unused Settings

	C.tooltip = {
		enable = false,
		spellid = false,
		text = {
			enable = false,
			pvp = false,						-- Display player pvp status
			faction = false,					-- Dispaly player faction
			realms = false,					-- Display player realms
			level = false,						-- Dispaly player level
			ranks = false,						-- Display guild ranks if a unit is guilded
			spec = false,						-- Display the players talent spec in the tooltip
			titles = false,					-- Display player titles
			statusbar = false,					-- Display statusbar number values
			itemid = false,					-- Display the itemID in item mouseovers
			spellid = false,					-- Display the spellID in spell mouseovers
		},
		tot2 = false,							-- Adds ToT in green (displays < YOU > when something is targeting you)
		tot3 = false,							-- LookinAtMe
	}

--]]

--[[ Print Wrapper

	local print = function(prefix, amount)
		Addon.print('reputation', prefix, amount)
	end
--]]
