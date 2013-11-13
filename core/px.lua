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
local px = 768 / strmatch(GetCVar('gxResolution'), '%d+x(%d+)') / uiscale
_G[AddOn]["px"] = px

local scale = function(x)
	return px * floor(x / px + 0.5)
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
	[1]  =  1 * px,
	[2]  =  2 * px,
	[3]  =  3 * px,
	[4]  =  4 * px,
	[5]  =  5 * px,
	[6]  =  6 * px,
	[7]  =  7 * px,
	[8]  =  8 * px,				-- tiny
	[9]  =  9 * px,

	[10] = 10 * px,				-- small
	[11] = 11 * px,

	[12] = 12 * px,				-- medium (normal)
	[13] = 13 * px,
	[14] = 14 * px,				--[[ header ]]
	[15] = 15 * px,
	[16] = 16 * px,				-- large
	[17] = 17 * px,
	[18] = 18 * px,
	[19] = 19 * px,
	[20] = 20 * px,				-- huge / huge1

	[22] = 22 * px,
	[24] = 24 * px,				-- superhuge
	[26] = 26 * px,
	[28] = 28 * px,
	[30] = 30 * px,

	[32] = 32 * px,				-- gigantic
  -- [34] = 34 * px,
  -- [36] = 36 * px,
  -- [38] = 38 * px,
  -- [40] = 40 * px,

  -- [42] = 42 * px,
  -- [44] = 44 * px,
  -- [46] = 46 * px,
  -- [48] = 48 * px,
  -- [50] = 50 * px,
}

--==============================================--
--	Interface
--==============================================--
module.P = P
module.px = px
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
