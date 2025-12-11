local aoc = require("aoc")
local list = aoc.list
local map = aoc.list.map

local function make_triangle(seq)
	local tri = { seq }
	while list.exists(list.last(tri), aoc.fix(aoc.neq, 0)) do
		table.insert(tri, aoc.slide_map(tri[#tri], 2, aoc.splat_into(aoc.swap(aoc.sub))))
	end

	return tri
end

local function find_next(tri)
	table.insert(tri[#tri], 0)
	for i = #tri - 1, 1, -1 do
		table.insert(tri[i], tri[i][#tri[i]] + tri[i+1][#tri[i+1]])
	end
	return tri[1][#tri[1]]
end

local function find_prev(tri)
	table.insert(tri[#tri], 1, 0)
	for i = #tri - 1, 1, -1 do
		table.insert(tri[i], 1, tri[i][1] - tri[i+1][1])
	end
	return tri[1][1]
end

---@type solver
local function solve (filename)
	local hists = map(aoc.collect(io.lines(filename)), function(line) return aoc.split_with(line, " ", tonumber) end)
	local tris = map(hists, make_triangle)
	local p1 = list.sum(tris, aoc.snd(find_next))
	local p2 = list.sum(tris, aoc.snd(find_prev))
	return p1, p2
end

aoc.verify(solve, "example", 114, 2)
aoc.verify(solve, "input", 1702218515, 925)
