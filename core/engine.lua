local AddOn, Engine = ...

Engine[1] = {}	-- A, Addon
Engine[2] = {}	-- C, Configuration
Engine[3] = {}	-- T, Functions
Engine[4] = {}	-- L, Localization

function Engine:Unpack()
	return self[1], self[2], self[3], self[4]
end

_G[AddOn] = Engine





--==============================================--
--	Asphyxia\Handler\Engine.lua
--==============================================--
--[[
	local AddOn, Engine = ...

	Engine[1] = {} -- A, Functions
	Engine[2] = {} -- C, Configuration
	Engine[3] = {} -- L, localization
	Engine[4] = {} -- U, UnitFrames
	Engine[5] = {} -- M, Modules
	Engine[6] = {} -- P, PlugIns

	function Engine:Unpack()
		return self[1], self[2], self[3], self[4], self[5], self[6]
	end

	_G.AsphyxiaUI = Engine
--]]



--==============================================--
--	Database
--==============================================--
--[[	DB Defaults

	local db

	local Defaults = {
		Time = {
			['Login'] = date(),
			['Logout'] = time(),
		},
		Reputation = {
			['EventCounter'] = 0,
			['EventTimestamp'] = date('*t'),
			['EventAnnouncements'] = true,
		},
	}
--]]

--==============================================--
--	DB
--==============================================--
--[[ Database

	source: 	 Wowpedia Tutorial
	title:	'Saving variables between game sessions'
	link:	 http://wowpedia.org/Saving_variables_between_game_sessions
--]]

--[[ Database Init

	local f = CreateFrame('Frame')
	f:RegisterEvent('ADDON_LOADED')
	f:RegisterEvent('PLAYER_LOGOUT')
	f:SetScript('OnEvent', function(self, event, database)
		if (event == 'ADDON_LOADED') then self:UnregisterEvent('ADDON_LOADED') -- self.ADDON_LOADED = nil
			if (TruthDB == nil) then
				TruthDB = {
					Time = {
						['Login'] = time(),
						['Logout'] = '',
					},
					Reputation = {
						['EVENT_COUNTER'] = 0,
						['EVENT_TIMESTAMP'] = '',
						['EVENT_ANNOUNCEMENTS'] = true,
					},
				}
			else
				TruthDB.Time.LOGIN = time()
			end
		elseif (event == 'PLAYER_LOGOUT') then
			TruthDB.Time.LOGOUT = time()								-- Final save occurs when the character logs out
		end
	end)
--]]

--==============================================--
--	Macros
--==============================================--
--[[ Framestack (adds border to frame)

	/framestack
	/script MN=GetMouseFocus():GetName()DEFAULT_CHAT_FRAME:AddMessage(MN)
	/run MF=_G[MN] MFB=CreateFrame('Frame',nil,MF )MFB:SetAllPoints()MFB:SetBackdrop({edgeFile='Interface\\BUTTONS\\WHITE8X8',edgeSize=5})MFB:SetBackdropBorderColor(1,0,0,1)
 --]]

--==============================================--
--	Backup
--==============================================--
--[[ local Addon, engine = ...

	engine[1] = {}					-- T, functions, constants, variables
	engine[2] = {}					-- C, config
	engine[3] = {}					-- L, localization
	engine[4] = {}					-- G, globals (Optional)
	engine[5] = {}					-- F, file access (addon UI only)

	_G[Addon] = engine				-- Auto-named same as root folder

	-- alt version
	engine = {[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}} --T, C, L, G, F
--]]
--==============================================--
--	Resources
--==============================================--
--[[ Toc

	local DEFAULT_PROFILE_NAME 		= 'Default'
	local SAVED_VARS_NAME			= 'TruthDB'
	local SAVED_MEDIA_NAME			= 'TruthDBM'
	local SAVED_VARS_PER_CHAR_NAME	= 'TruthDBPC'
--]]

--[[	Important

	●	WoW Constants
		http://www.wowwiki.com/Talk:WoW_constants
		Regex Instructions for parsing GlobalStrings.lua
     ●

--]]

--==============================================--
--	Backup
--==============================================--
--[[ C.chat_channel_aliases = {
	--   [pattern to look for] 			= '[what to replace it with]',
		[CHAT_MSG_GUILD]				= '[G]',
		[CHAT_MSG_PARTY]				= '[P]',
		[CHAT_MSG_PARTY_LEADER]			= '[PL]',
		[CHAT_MSG_RAID]				= '[R]',
		[CHAT_MSG_RAID_LEADER]			= '[RL]',
		[CHAT_MSG_RAID_WARNING]			= '[RW]',
		[CHAT_MSG_OFFICER]				= '[O]',
		[INSTANCE_CHAT]				= '[I]',
		[INSTANCE_CHAT_LEADER]			= '[IL]',
	}

	C.chat_channel_global_aliases = {
	  -- General						[1. General - Orgrimar]
		['(%d+)%. ' .. GENERAL]			= '%[%1%]',		-- [1]	<working>
	  -- Trade 						[2. Trade - City]
		['(%d+)%. ' .. TRADE]			= '%[%1%]',		-- [2]	<working>
	  -- LocalDefense 					[3. LocalDefense - Orgrimar]
		['(%d+)%. LocalDefense']			= '%[%1%]',		-- [3]
	  -- LookingForGroup 				[4. LookingForGroup]
		['(%d+)%. ' .. LOOKING]			= '%[%1%]',		-- [4]
	  -- WorldDefense 					[5. WorldDefense]
	  -- ['(%d+)%. WorldDefense']			= '%[%1%]',		-- [5]	<working>
	  -- GuildRecruitment 				[5. GuildRecruitment]
	  -- ['(%d+)%. GuildRecruitment']		= '%[%1%.GR%]',	-- [GR]
	  -- Custom Channels 				[6. iKorgath]
	  -- ['(%d+)%. .-']					= '%[%1%.%]',
	}
--]]

--[[ Pixel Pefect (unused functions)

	local gxResolution			= GetCVar('gxResolution')
	T.resolution				= gxResolution
	T.screenwidth				= tonumber(match(gxResolution, '(%d+)x+%d'))
	T.screenheight				= tonumber(match(gxResolution, '%d+x(%d+)'))

	T.SetOutside = function(obj, f, x, y)
		local anchor = f and f or obj:GetParent()
		if (obj:GetPoint()) then obj:ClearAllPoints() end
		x = (type(x) == 'number') and scale(x) or 2
		y = (type(y) == 'number') and scale(y) or 2
		obj:SetPoint('TOPLEFT', anchor, -x,  y)
		obj:SetPoint('BOTTOMRIGHT', anchor,  x, -y)
	end

	T.SetInside = function(obj, f, x, y)
		local anchor = f and f or obj:GetParent()
		if (obj:GetPoint()) then obj:ClearAllPoints() end
		x = (type(x) == 'number') and scale(x) or 2
		y = (type(y) == 'number') and scale(y) or 2
		obj:SetPoint('TOPLEFT', anchor,  x, -y)
		obj:SetPoint('BOTTOMRIGHT', anchor, -x,  y)
	end

	T.mult = X
--]]

--[[ Slash Reload
	Addon.Reload = _G.ReloadUI
	_G.SLASH_RELOADMYUI1 = '/tru'
	_G.SlashCmdList['RELOADMYUI'] = Addon.Reload
--]]

--[[ Character Data
	T.myname 			= UnitName('player')
	T.myrealm 		= GetRealmName()
	T.mylevel 		= UnitLevel('player')
	T.myfaction		= UnitFactionGroup('player')
	_,T.myrace 		= UnitRace('player')
	_,T.myclass		= UnitClass('player')
	local classcolor 	= RAID_CLASS_COLORS[T.myclass]
	T.mycolor 		= {classcolor.r, classcolor.g, classcolor.b}
--]]

--[[ Client Data
	T.client 			= GetLocale()
	T.version 		= GetAddOnMetadata('addon', 'Version')
	T.versionnumber 	= tonumber(T.version)
	T.patch, T.buildtext, T.releasedate, T.toc = GetBuildInfo()
	T.build 			= tonumber(T.buildtext)

	-- Credit
	T.credits			= {'Tulla','P3lim','Phanx','Roth','Tekkub','Shestak','Elv', 'Haste'}
--]]