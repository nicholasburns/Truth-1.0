--[[	A simple module for complex numbers
	[src] Programming in Lua 5.3 (p.175)

	The simplest way to create a module in Lua is really simple: we create a table,
	put all functions we want to export inside it, and return this table. Listing 15.1
	illustrates this approach.
--]]

local M = {}


function M.new (r, i)
	return { r=r, i=i }
end


M.i = M.new(0, 1)							--~  Defines constant 'i'


function M.add (c1, c2)
	return M.new(c1.r + c2.r, c1.i + c2.i)
end


function M.sub (c1, c2)
	return M.new(c1.r - c2.r, c1.i - c2.i)
end


function M.mul (c1, c2)
	return M.new(c1.r*c2.r - c1.i*c2.i, c1.r*c2.i + c1.i*c2.r)
end


local function inv (c)
	local n = c.r^2 + c.i^2

	return M.new(c.r/n, -c.i/n)
end


function M.div (c1, c2)
	return M.mul(c1, inv(c2))
end


function M.tostring (c)
	return "(" .. c.r .. "," .. c.i .. ")"
end


return M