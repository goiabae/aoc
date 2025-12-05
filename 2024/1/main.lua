local aoc = require("aoc")

-- FIXME: does not work with LuaJIT

---@type solver
local function solve (filename)
	local mat = aoc.parse_number_mat(aoc.read_file(filename), "\n", " ")
	local tmat = aoc.transpose_view(mat)
	local fst = tmat[1]
	local freqs = aoc.make_bag(tmat[2])
	local p2 = aoc.list.sum(fst, function(_, elt)
		return elt * freqs[elt]
	end)
	aoc.list.each(tmat, aoc.sort)
	local p1 = aoc.list.sum(mat, aoc.snd(aoc.distance))
	return p1, p2
end

aoc.verify(solve, "example", 11, 31)
aoc.verify(solve, "input", 2086478, 24941624)
