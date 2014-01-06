local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
if ((not C["Aura"]["StealthFX"]["Enable"])) then return end
local print = function(...) Addon.print('stealthFX', ...) end
local tonumber = tonumber
local GetCVar = GetCVar
local SetCVar = SetCVar
local PlayMusic = PlayMusic
local StopMusic = StopMusic
local UnitBuff = UnitBuff
--~  PlayMusic(Addon.media.sound.affliction)
--~  PlayMusic(Addon.media.sound.failure)


-- Constants
local bassdrum  = Addon.media.sound.affliction	--~  Dong! .... Dong! .... Dong! ....	--> Deep Percussion Drum (slow / steady tempo)
local snaredrum = Addon.media.sound.failure		--~  Thud!.. Thud!.. Thud!			--> Snare Drumm-ish (medium / steady tempo)


-- Properties
local Toggle
local Volume


-- Addon Events
local soundFX = CreateFrame('Frame')
soundFX:RegisterEvent('ADDON_LOADED')
soundFX:SetScript("OnEvent", function(self, event, addon)

	if (event == "ADDON_LOADED") and (addon == AddOn) then	--~  Set Default Volume
		Volume = 0.5								--~  .1 = 10-th of the sound bar (0 = mute / 1 = max volume)
		self:UnregisterEvent(event)
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end

	if (event == "PLAYER_ENTERING_WORLD") then


		self:UnregisterEvent(event)
		self:RegisterEvent("UPDATE_STEALTH")
	end

	if (event == "UPDATE_STEALTH") then
		if ((T.PlayerIsRogue() or T.PlayerIsDruid()) and Volume ~= 0) then

			if (T.PlayerHasBuff("Stealth") or T.PlayerHasBuff("Vanish")) then

				Toggle = GetCVar("Sound_EnableMusic")
				SetCVar("Sound_EnableMusic", 1)

				PlayMusic(bassdrum)			--~  print("Stealthed", "Music Enabled")

			else

				StopMusic()				--~  print("Unstealthed", "Music Disabled")

			end
		end
	end
end)


-- Slashes
SlashCmdList["CS"] = function(str)
	local num = tonumber(str)

	if (num == nil or num > 1 or num < 0 or str == "") then
		print("Invalid Argument:", "Please enter a number inbetween 0 and 1. (/cs 0.1)")

	elseif (num == 0) then
		print("StealthFX disabled.", "To Re-Enable, enter a number between 0 and 1 (/cs 0.1)")
		SetCVar("Sound_MusicVolume", 0)

	else
		print("StealthFX: Volume set to "..num..".")
		SetCVar("Sound_MusicVolume", num)

		Volume = num
	end
end

SLASH_CS1 = "/cs"





--==============================================--
--	Cresit
--==============================================--
--[[ ## Interface: 50100
	## Version: 1.0
	## Author: Htaedeht
	## Title: CoolStealth
	## Notes: Play music while stealth
	## SavedVariables: CoolStealth
--]]

--==============================================--
--	Added to API (funcs.lua)
--==============================================--
--[[ local function PlayerHasBuff(buffname)
	--~  Checks current buffs for a buff that matches "buffname"

		for i = 1, 40 do
			local name = UnitBuff("player", i)

			if (name == nil) then return false end
			if (name == buffname) then return true end
		end

		return false
	end
--]]

--==============================================--
--	Backup
--==============================================--
--~  soundFX:RegisterEvent('PLAYER_LOGIN')		--~  self:RegisterEvent("PLAYER_LOGIN")
--~  soundFX:RegisterEvent('UPDATE_STEALTH')		--~  self:RegisterEvent("UPDATE_STEALTH")

--~  PlayMusic(Addon.media.sound.necrotic)		--~  AMG NO!! ZERP!ZERP!ZERP!ZERP!			--> Sound Effect-ish (fast / steady tempo)

--[[ local function ToggleMusic()					--~  Use the player's ingame music settings
		if (Toggle == "0") then					--~  DEFAULT_CHAT_FRAME:AddMessage("Toggle = 0")
			SetCVar("Sound_EnableMusic", 0)
		else									--~  DEFAULT_CHAT_FRAME:AddMessage("Toggle = 1")
			SetCVar("Sound_EnableMusic", 1)
		end
	end
--]]

--[[ if (Volume == nil or 0) then					--~  .1 = 10-th of the sound bar (0 = mute / 1 = max volume)
		Volume = 0.5
	end
--]]

--[[ local soundfile = Addon.media.sound.warn or 'Interface\\AddOns\\'.. AddOn ..'\\media\\sound\\warn.ogg'
	soundFX.soundfile = Addon.media.sound.warning or [=[Interface\AddOns\CoolStealth\Sounds\Mi-1.mp3]=]

--]]

--[[	local function OnEvent(self, event)			--~  Checks for Stealth/Vanish and Druid Prowl
	if ((T.PlayerIsRogue() or T.PlayerIsDruid()) and Volume ~= 0) then
		if (PlayerHasBuff("Stealth") or PlayerHasBuff("Vanish") or PlayerHasBuff("Prowl")) then

--~       ...

--~  Version 2
--~  if ((class == "ROGUE" or class == "DRUID") and Volume ~= 0) then
--]]

--[[ local function OnEvent(self, event)		--~  Checks for Stealth & Drives the Toggle Settings
		if ((T.PlayerIsRogue() or T.PlayerIsDruid()) and Volume ~= 0) then					--~  if ((class == "ROGUE" or class == "DRUID") and Volume ~= 0) then
			if (PlayerHasBuff("Stealth") or PlayerHasBuff("Vanish") or PlayerHasBuff("Prowl")) then
				Toggle = GetCVar("Sound_EnableMusic")
				SetCVar("Sound_EnableMusic", 1)
				PlayMusic(Addon.media.sound.warn)
			else
				StopMusic()
				ToggleMusic()
			end
		end
	end
--]]


--==============================================--
--	Unkown Variations of Existing Code
--==============================================--
--[[ local function SetVolStealth(vol)				--~  Sets the volume of the background sounds
		SetCVar("Sound_MusicVolume", vol)
	end
--]]

--[[ local function onEvent(self, event)		--~  Checks for Stealth & Sets the Volume
		if ((class == "ROGUE" or class == "DRUID") and Volume ~= 0) then
			if (PlayerHasBuff("Stealth") or PlayerHasBuff("Vanish") or PlayerHasBuff("Prowl")) then
				SetVolStealth(Volume)
			else
				SetVolStealth(Volume)
			end
		end
	end
--]]

