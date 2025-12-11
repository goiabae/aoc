local aoc = require("aoc")

---@type solver
local function solve (filename)
	local pos = 50
	return aoc.iter.sum2(aoc.iter.map(io.lines(filename), function (line)
		local sign = (string.sub(line, 1, 1) == "R" and 1 or -1)
		local diff = tonumber(string.sub(line, 2))

		local passes = math.floor(math.abs((pos + sign * diff) / 100))
			+ ((pos ~= 0 and sign == -1 and diff >= pos) and 1 or 0)
		pos = ((pos + sign * diff) % 100)
		local final_zero = (pos == 0 and 1 or 0)
		return final_zero, passes
	end))
end

aoc.verify(solve, "example", 3, 6)
aoc.verify(solve, "input", 1089, 6530)
