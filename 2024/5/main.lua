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

		-- for every elt in befores/afters, if it exists in page then it appears before/after i
		local all_befores = function() return aoc.for_all(find_befores(ordering, page_nos[i]), function(before) return is_before(page_nos, i, before) end) end
		local all_afters = function() return aoc.for_all(find_afters(ordering, page_nos[i]), function(after) return is_after(page_nos, i, after) end) end

		if (not all_befores()) or (not all_afters()) then
			return false
		end
	end
	return true
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

---@type solver
local function solve (filename)
	local sections = aoc.split_empty(aoc.read_file(filename))
	local ordering = aoc.parse_number_mat(sections[1], "\n", "|")
	local to_produce = aoc.parse_number_mat(sections[2], "\n", ",")

	local correct = aoc.list.filter(to_produce, aoc.fix(in_right_order, ordering))
	local middles = aoc.list.map(correct, aoc.middle)
	local p1 = aoc.sum(middles)

	local incorrect = aoc.list.filter(to_produce, function(page_nos) return not in_right_order(ordering, page_nos) end)
	local corrected = aoc.list.map(incorrect, aoc.fix(order, ordering))
	local middles = aoc.list.map(corrected, aoc.middle)
	local p2 = aoc.sum(middles)

	return p1, p2
end

aoc.verify(solve, "example", 143, 123)
aoc.verify(solve, "input", 5639, 5273)
