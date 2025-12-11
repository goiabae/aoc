local aoc = require("aoc")

---@type solver
local function solve (filename)
	local rows = aoc.parse_separated_matrix(filename, aoc.fix(aoc.eq, " "))
	local trows = aoc.matrix.transpose_view(rows)

	local s, s2 = 0, 0

	for i = 1, aoc.len(trows) do
		local col = trows[i]
		local o = assert(aoc.list.last(col)):sub(1, 1)
		local op = (o == "*") and aoc.mul or aoc.add
		local init = (o == "*") and 1 or 0

		local p = aoc.foldi(aoc.list.slice(col, 1, aoc.len(col)-1), init, function (acc, x, _) return op(acc, x) end)

		local p2 = init
		for j = 1, aoc.len(col[1]) do
			local n = ""
			for k = 1, aoc.len(col)-1 do
				local m = string.sub(col[k], j, j)
				n = n .. ((m == " ") and "" or m)
			end
			p2 = op(p2, assert(tonumber(n)))
		end

		s, s2 = s + p, s2 + p2
	end

	return s, s2
end

aoc.verify(solve, "example", 4277556, 3263827)
aoc.verify(solve, "input", 6635273135233, 12542543681221)
