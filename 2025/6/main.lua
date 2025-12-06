local aoc = require("aoc")

local function solve_problem (col, o)
	local l = #(col[1])
	local op = (o == "*") and aoc.mul or aoc.add
	local s = (o == "*") and 1 or 0

	for a = 1, l do
		local n = ""
		for j = 1, #col-1 do
			local m = string.sub(col[j], a, a)
			if m ~= " " then
				n = n .. m
			end
		end
		s = op(s, n)
	end

	return s
end

local function parse_separated_matrix (filename)
	local lines = aoc.collect(io.lines(filename))
	local l = aoc.foldi(lines, 0, function (acc, x, _) return math.max(acc, #x) end)
	local padded_lines = aoc.list.map(lines, function (x) return aoc.pad_right(x, l) end)
	local rows = aoc.list.map(padded_lines, function () return {} end)
	local beg = 1

	local function all_spaces (c)
		return aoc.for_all(padded_lines, function (line) return string.sub(line, c, c) == " " end)
	end

	local function f (s)
		for r = 1, #padded_lines do
			table.insert(rows[r], string.sub(padded_lines[r], beg, math.min(s-1, l)))
		end
		beg = s+1
	end

	for i = 2, l do
		if all_spaces(i) then f(i) end
	end
	f(l+1)

	return rows
end

local function solve (filename)
	local rows = parse_separated_matrix(filename)
	local trows = aoc.transpose_view(rows)

	local s, s2 = 0, 0

	for i = 1, #trows do
		local col = trows[i]
		local o = string.sub(col[#col], 1, 1)

		local op = (o == "*") and aoc.mul or aoc.add
		local p = (o == "*") and 1 or 0

		for j = 1, #col - 1 do
			local n = tonumber(col[j])
			p = op(p, n)
		end

		s = s + p
		s2 = s2 + solve_problem(trows[i], o)
	end

	return s, s2
end

aoc.verify(solve, "example", 4277556, 3263827)
aoc.verify(solve, "input", 6635273135233, 12542543681221)
