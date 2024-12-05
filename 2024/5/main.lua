local aoc = require("aoc")

-- find all page numbers which come after page_no
local function find_afters(ordering, page_no)
	return aoc.filter_map(ordering, function(pair)
		return (pair[1] == page_no) and pair[2] or nil
	end)
end

-- find all page numbers which come before page_no
local function find_befores(ordering, page_no)
	return aoc.filter_map(ordering, function(pair)
		return (pair[2] == page_no) and pair[1] or nil
	end)
end

-- false if after appears before i in page_nos. if after is not in page_nos return true
local function is_after(page_nos, i, after)
	for j = 1, i do
		if page_nos[j] == after and not (j > i) then
			return false
		end
	end
	return true
end

-- false if after appears after i in page_nos. if before is not in page_nos return true
local function is_before(page_nos, i, before)
	for j = i, #page_nos do
		if page_nos[j] == before and not (j < i) then
			return false
		end
	end
	return true
end

local function in_right_order(ordering, page_nos)
	for i = 1, #page_nos do
		local befores = find_befores(ordering, page_nos[i])
		local afters = find_afters(ordering, page_nos[i])

		-- for every elt in befores/afters, if it exists in page then it appears before/after i
		local all_befores = function() return aoc.for_all(befores, function(before) return is_before(page_nos, i, before) end) end
		local all_afters = function() return aoc.for_all(afters, function(after) return is_after(page_nos, i, after) end) end

		if (not all_befores()) or (not all_afters()) then
			return false
		end
	end
	return true
end

local function part1(filename)
	local sections = aoc.split_empty(aoc.read_file(filename))
	local ordering = aoc.parse_number_mat(sections[1], "\n", "|")
	local to_produce = aoc.parse_number_mat(sections[2], "\n", ",")

	local correct = aoc.filter(to_produce, aoc.fix(in_right_order, ordering))
	local middles = aoc.map(correct, aoc.middle)
	return aoc.sum(middles)
end

-- whether a should come before b or not given an ordering
local function compare(ordering, a, b)
	local aft = function() return aoc.exists(find_afters(ordering, a), function (after) return after == b end) end
	local bfr = function() return aoc.exists(find_befores(ordering, b), function (before) return before == a end) end
	return aft() or bfr()
end

local function order(ordering, page_nos)
	return aoc.sort(page_nos, aoc.fix(compare, ordering))
end

local function part2(filename)
	local sections = aoc.split_empty(aoc.read_file(filename))
	local ordering = aoc.parse_number_mat(sections[1], "\n", "|")
	local to_produce = aoc.parse_number_mat(sections[2], "\n", ",")

	local incorrect = aoc.filter(to_produce, function(page_nos) return not in_right_order(ordering, page_nos) end)
	local corrected = aoc.map(incorrect, aoc.fix(order, ordering))
	local middles = aoc.map(corrected, aoc.middle)
	return aoc.sum(middles)
end

assert(part1("example") == 143, "wrong solution for part1 example")
assert(part1("input") == 5639, "wrong solution for part1")
assert(part2("example") == 123, "wrong solution for part2 example")
assert(part2("input") == 5273, "wrong solution for part2")
