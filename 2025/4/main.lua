local aoc = require("aoc")

local function part1(filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))

	local s = 0
	for i, row in ipairs(mat) do
		for j, c in ipairs(row) do
			if c == '@' and aoc.count_adjacent(mat, i, j, '@') < 4 then
				s = s + 1
			end
		end
	end
	return s
end

local function part2(filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))

	local to_remove = {}
	for i, row in ipairs(mat) do
		for j, c in ipairs(row) do
			if c == '@' then
				table.insert(to_remove , { i, j })
			end
		end
	end

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
	return s
end

aoc.assert_eq(part1("example"), 13)
aoc.assert_eq(part1("input"), 1540)

aoc.assert_eq(part2("example"), 43)
aoc.assert_eq(part2("input"), 8972)
