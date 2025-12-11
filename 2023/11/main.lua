local aoc = require("aoc")
local transpose = aoc.matrix.transpose_view
local map = aoc.list.map

---@param space string[][]
local function expand(space)
	local expanded = {}
	for i = 1, aoc.len(space) do
		local empty = aoc.list.for_all(space[i], function (x) return x ~= "#" end)
		table.insert(expanded, space[i])
		if empty then
			table.insert(expanded, space[i])
		end
	end
	return expanded
end

local function dist(line)
	local a = line[1]
	local b = line[2]
	return math.abs(b[1] - a[1]) + math.abs(b[2] - a[2])
end

---@param space string[][]
local function find_galaxies(space)
	return aoc.iter.collect_many(aoc.iter.filter(aoc.matrix.iter(space), function (_, _, c) return c == "#" end))
end

---@param space string[][]
---@return { row: boolean[], cols: boolean[] }
local function find_empty(space)
	local rows = map(space, function (s)
		return aoc.list.for_all(s, function (x) return x ~= "#" end)
	end)
	local cols = map(aoc.matrix.transpose_view(space), function (s)
		return aoc.list.for_all(s, function (x) return x ~= "#" end)
	end)
	return { rows = rows, cols = cols }
end

local function expand2(gals, empty, rate)
	local row_exp = aoc.list.reductions(map(empty.rows, aoc.b2i), function (acc, s)
		return acc + s * (rate - 1)
	end)
	local col_exp = aoc.list.reductions(map(empty.cols, aoc.b2i), function (acc, s)
		return acc + s * (rate - 1)
	end)

	return map(gals, function(gal)
		return {
			gal[1] + row_exp[gal[1]],
			gal[2] + col_exp[gal[2]]
		}
	end)
end

local function part1(mat)
	local exp = transpose(expand(transpose(expand(mat))))
	local gals = find_galaxies(exp)
	return aoc.list.sum(aoc.list.pairs(gals), aoc.snd(dist))
end

---@param rate integer
---@param mat string[][]
---@return integer
local function part2(rate, mat)
	local empty = find_empty(mat)
	local gals = find_galaxies(mat)
	local exp = expand2(gals, empty, rate)
	return aoc.list.sum(aoc.list.pairs(exp), aoc.snd(dist))
end

local function solve (rate, filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))
	return part1(mat), part2(rate, mat)
end

aoc.verify(aoc.fix(solve, 100), "example", 374, 8410)
aoc.verify(aoc.fix(solve, 1000000), "input", 9609130, 702152204842)
