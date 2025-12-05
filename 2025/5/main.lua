local aoc = require("aoc")

local function solve (filename)
	local sections = aoc.split_empty(aoc.read_file(filename))
	local ingredient_ids = aoc.list.map(aoc.split_with(sections[2], "\n"), tonumber)
	local ranges = aoc.range_set.from_range_list(aoc.parse_number_mat(sections[1], "\n", "-"))

	local part1 = aoc.list.count(ingredient_ids, function (_, i)
		return aoc.range_set.contains(ranges, i)
	end)

	local part2 = aoc.range_set.count_elts(ranges)

	return part1, part2
end

aoc.verify(solve, "example", 3, 14)
aoc.verify(solve, "input", 868, 354143734113772)
