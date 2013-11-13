local LIBHUB_MAJOR = 'LibHub'

local LibHub = _G[LIBHUB_MAJOR]


LibHub = {}						-- local
LibHub.libs = {}					-- local

_G[LIBHUB_MAJOR] = LibHub			-- _G['LibHub'] = LibHub  LibHub = {libs = {}}



function LibHub:NewLibrary(major, minor)

	assert(type(major) == 'string', 'Bad argument #2 to 'NewLibrary' (string expected)')

	minor = assert(tonumber(strmatch(minor, '%d+')), 'Minor version must either be a number or contain a number.')

	local oldminor = self.minors[major]

	if (oldminor and oldminor >= minor) then return nil end

	self.minors[major], self.libs[major] = minor, self.libs[major] or {}

	return self.libs[major], oldminor
end


function LibHub:GetLibrary(major, silent)
	if (not self.libs[major] and not silent) then
		error(('Cannot find a library instance of %q.'):format(tostring(major)), 2)
	end

	return self.libs[major], self.minors[major]
end


function LibHub:IterateLibraries() return pairs(self.libs) end
setmetatable(LibHub, {__call = LibHub.GetLibrary})
