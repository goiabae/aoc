local aoc = require("aoc")

local function winning_nums(str)
	local colon = aoc.find_char(":", str)
	local pipe = aoc.find_char("|", str)

	local winning = aoc.split_with(str:sub(colon+2, pipe-2), " ", tonumber)
	local scratch = aoc.split_with(str:sub(pipe+2, #str), " ", tonumber)

	local s = 0
	for i = 1, #winning do
		for j = 1, #scratch do
			if scratch[j] == winning[i] then
				s = s + 1
			end
		end
	end
	return s
end

---@type solver
local function solve (filename)
	local wins = aoc.list.map(aoc.collect(io.lines(filename)), winning_nums)

	local p1 = aoc.list.sum(wins, function(_, count)
		if count > 0 then return 2 ^ (count-1) else return 0 end
	end)

	local counts = aoc.list.init(aoc.len(wins), 1)
	local p2 = 0
	for i = 1, #wins do
		p2 = p2 + counts[i]
		for j = 1, math.min(wins[i], #wins - i) do
			counts[i+j] = counts[i+j] + counts[i]
		end
	end

	return p1, p2
end

aoc.verify(solve, "example", 13, 30)
aoc.verify(solve, "input", 26218, 9997537)
