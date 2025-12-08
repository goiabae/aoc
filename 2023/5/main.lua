local aoc = require("aoc")

local function parse(lines)
	local seeds = aoc.split_with(lines[1]:sub(#"seeds: "+1), " ", tonumber)
	local i = 2
	local maps = {}
	while i <= #lines do
		if lines[i] == "" then
			i = i + 1
		end

		local map = {}
		local k = 1
		while (i+k) <= #lines and lines[i+k] ~= "" do
			local ns = aoc.split_with(lines[i+k], " ", tonumber)
			table.insert(map, ns)
			k = k + 1
		end
		table.insert(maps, map)
		i = i + k
		i = i + 1
	end
	return { seeds = seeds, maps = maps }
end

local function convert(num, map)
	for range in aoc.list.iter(map) do
		local dest = range[1]
		local source = range[2]
		local length = range[3]
		if source <= num and num <= (source + length) then
			local offset = num - source
			return dest + offset
		end
	end
	return num
end

---@type solver
local function solve (filename)
	local almanac = parse(aoc.collect(io.lines(filename)))
	local acc = almanac.seeds
	almanac.seeds = aoc.group(almanac.seeds, 2)
	local ranges = aoc.list.map(almanac.seeds, function (s) return { s[1], s[1]+s[2]-1 } end)
	local set = aoc.range_set.from_range_list(ranges)
	for i = 1, #almanac.maps do
		local map = almanac.maps[i]
		set = aoc.range_set.slide_transform(set, map)
		acc = aoc.list.map(acc, function(num) return convert(num, map) end)
	end
	local p1 = aoc.list.reduce(acc, math.min)
	local p2 = aoc.range_set.min(set)
	return p1, p2
end

aoc.verify(solve, "example", 35, 46)
aoc.verify(solve, "input", 26273516, 34039469)
