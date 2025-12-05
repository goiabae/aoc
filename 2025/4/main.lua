local aoc = require("aoc")

---@type solver
local function solve (filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))
	local p1 = aoc.iter.count(aoc.iter.filter3(aoc.matrix_iter(mat), function(i, j, c) return c == '@' and aoc.count_adjacent(mat, i, j, '@') < 4 end))

	local to_remove = aoc.collect3(aoc.iter.filter3(aoc.matrix_iter(mat), aoc.equals3('@')))

	local s = 0
	repeat
		local removed = 0
		for i, p in pairs(to_remove) do
			if aoc.count_adjacent(mat, p[1], p[2], '@') < 4 then
				mat[p[1]][p[2]] = '.'
				removed = removed + 1
				table.remove(to_remove, i)
			end
		end
		s = s + removed
	until removed == 0

	return p1, s
end

aoc.verify(solve, "example", 13, 43)
aoc.verify(solve, "input", 1540, 8972)
