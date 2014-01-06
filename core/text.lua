local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('text', ...) end
if (not C["Addon"]["Text"]["Enable"]) then return end





--==============================================--
--	Shorten String
--==============================================--
T.ShortenString = function(string, numChars, dots)
	assert(string, 'A String (to shorten) is required. Usage: T:ShortenString(string, numChars, includeDots)')
	assert(numChars, 'A length (to shorten the string to) is required. Usage: E:ShortenString(string, numChars, includeDots)')

	local bytes = string:len()

	if (bytes <= numChars) then
		return string
	else
		local len = 0
		local pos = 1

		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)

			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end

			if (len == numChars) then break end
		end

		if (len == numChars and pos <= bytes) then
			return string:sub(1, pos - 1) .. (dots and '...' or '')
		else
			return string
		end
	end
end

T.Capitalize = function(str)
  -- Change the first character of a word to upper case

	return str:gsub('^%l', string.upper)
end

--==============================================--
--	Font
--==============================================--
T.FontString = function(parent, name, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(file, size, flag)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1, -1)
	fs:SetJustifyH('LEFT')

	if (not name) then
		parent.text = fs
	else
		parent[name] = fs
	end

	return fs
end

T.SetFontString = function(parent, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')

	local isValid = fs:SetFont(file, size, flag)
	if (fs and not isValid) then
		print('funcs @ T.SetFontString', 'Invalid font file', file)
		print('funcs', 'Parent', parent:GetName())										-- print('funcs', 'Invalid Font', fs:GetName())
	end

	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)

	return fs
end

local SetFontString = function(parent, file, size, flag)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(file, size, flag)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)

	parent.text = fs																-- parent.text:SetText(format("%s: %s", "Data Name", Value))

	return fs
end

