if (not false) then return end


local AddOn, Addon = ...
local module = {}
local moduleName = "pixel"
_G[AddOn][moduleName] = module				--[[ _G.Truth.pixel = {} ]]


--[[	The word pixel is based on a contraction of..
		->  pix ("pictures") and
		->  el (for "element")
--]]

local type = type
local match, tonumber = string.match, tonumber
local floor, min, max = math.floor, math.min, math.max


--==============================================--
--	Constants
--==============================================--
local uiscale = min(2, max(0.64, 768 / match(GetCVar('gxResolution'), '%d+x(%d+)')))
local X = 768 / strmatch(GetCVar('gxResolution'), '%d+x(%d+)') / uiscale
_G[AddOn]["X"] = X

local scale = function(x)
	return X * floor(x / X + 0.5)
end
_G[AddOn]["scale"] = scale


local adjusted_uiscale = 0.64
if (uiscale < 0.64) then						-- number cleanup
	adjusted_uiscale = uiscale
end


--==============================================--
--	Pixelsizes
--==============================================--
local P = {
	[1]  =  1 * X,
	[2]  =  2 * X,
	[3]  =  3 * X,
	[4]  =  4 * X,
	[5]  =  5 * X,
	[6]  =  6 * X,
	[7]  =  7 * X,
	[8]  =  8 * X,				-- tiny
	[9]  =  9 * X,

	[10] = 10 * X,				-- small
	[11] = 11 * X,

	[12] = 12 * X,				-- medium (normal)
	[13] = 13 * X,
	[14] = 14 * X,				--[[ header ]]
	[15] = 15 * X,
	[16] = 16 * X,				-- large
	[17] = 17 * X,
	[18] = 18 * X,
	[19] = 19 * X,
	[20] = 20 * X,				-- huge / huge1

	[22] = 22 * X,
	[24] = 24 * X,				-- superhuge
	[26] = 26 * X,
	[28] = 28 * X,
	[30] = 30 * X,

	[32] = 32 * X,				-- gigantic
  -- [34] = 34 * X,
  -- [36] = 36 * X,
  -- [38] = 38 * X,
  -- [40] = 40 * X,

  -- [42] = 42 * X,
  -- [44] = 44 * X,
  -- [46] = 46 * X,
  -- [48] = 48 * X,
  -- [50] = 50 * X,
}

--==============================================--
--	Interface
--==============================================--
module.P = P
module.X = X
module.Scale = scale

-- module.uiscale = adjusted_uiscale

--[[ Moved Section -> core\api.lua

module.Scale = scale

module.Size = function(f, w, h)
	f:SetSize(scale(w), scale(h or w))
end

module.Width = function(f, w)
	f:SetWidth(scale(w))
end

module.Height = function(f, h)
	f:SetHeight(scale(h))
end

module.Point = function(o, a1, a2, a3, a4, a5)
	if (type(a1)=='number') then a1 = scale(a1) end
	if (type(a2)=='number') then a2 = scale(a2) end
	if (type(a3)=='number') then a3 = scale(a3) end
	if (type(a4)=='number') then a4 = scale(a4) end
	if (type(a5)=='number') then a5 = scale(a5) end

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint(a1, a2, a3, a4, a5)
end

module.SetInside = function(o, anchor, x, y)
	anchor = anchor or o:GetParent()
	x, y = x or 2, y or 2

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint('TOPLEFT', anchor, x, -y)
	o:SetPoint('BOTTOMRIGHT', anchor, -x, y)
end

module.SetOutside = function(o, anchor, x, y)
	anchor = anchor or o:GetParent()
	x, y = x or 2, y or 2

	if (o:GetPoint()) then
		o:ClearAllPoints()
	end

	o:SetPoint('TOPLEFT', anchor, -x, y)
	o:SetPoint('BOTTOMRIGHT', anchor, x, -y)
end

--]]


--==============================================--
--	Sandbox
--==============================================--
--[[ Screen Dimensions
	-- @ Shestak/PixelPerfect
	local screenwidth  = tonumber(strmatch(({GetScreenResolutions()})[GetCurrentResolution()], '(%d+)x+%d'))
	local screenheight = tonumber(strmatch(({GetScreenResolutions()})[GetCurrentResolution()], '%d+x(%d+)'))

	local Resolutions = GetScreenResolutions()
	local Resolution  = GetCurrentResolution()
--]]
