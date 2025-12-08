local aoc = require("aoc")

local function parse(lines)
	local time = aoc.split_with(lines[1]:sub(#"Time: ", #lines[1]), " ")
	local dist = aoc.split_with(lines[2]:sub(#"Distandce:", #lines[2]), " ")
	return { time = time, dist = dist }
end

---@param time integer
---@param dist integer
local function count_wins(time, dist)
	local wins = 0
	for t = 2, time do
		if ((time - t) * t) > dist then
			wins = wins + 1
		end
	end
	return wins
end

---@type solver
local function solve (filename)
	local program = parse(aoc.collect(io.lines(filename)))
	local winning = 1
	for i = 1, #program.time do
		local time = tonumber(program.time[i])
		local dist = tonumber(program.dist[i])
		winning = winning * count_wins(time, dist)
	end
	local p1 = winning
	local time = tonumber(aoc.list.reduce(program.time, aoc.concat))
	local dist = tonumber(aoc.list.reduce(program.dist, aoc.concat))
	local p2 = count_wins(time, dist)
	return p1, p2
end

aoc.verify(solve, "example", 288, 71503)
aoc.verify(solve, "input", 160816, 46561107)
