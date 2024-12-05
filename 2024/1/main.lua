local aoc = require("aoc")

local function compare(a, b) return a < b end

local function part1(filename)
	local mat = aoc.parse_number_mat(aoc.read_file(filename), "\n", " ")
	local rotated = aoc.transpose(mat)
	local sorted = aoc.map(rotated, function(seq) return aoc.sort(seq, compare) end)
	local unrotated = aoc.transpose(sorted)
	return aoc.sum(aoc.map(unrotated, function(row) return math.abs(row[1] - row[2]) end))
end

local function part2(filename)
	local mat = aoc.parse_number_mat(aoc.read_file(filename), "\n", " ")
	local rotated = aoc.transpose(mat)

	local fst = rotated[1]
	local freqs = aoc.make_bag(rotated[2])

	return aoc.sumi(fst, function(elt, _)
		return elt * freqs[elt]
	end)
end

assert(part1("input") == 2086478, "wrong solution for part1")
assert(part2("input") == 24941624, "wrong solution for part2")
