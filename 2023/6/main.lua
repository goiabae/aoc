require("aoc")

local function parse(lines)
	local time = split_on_spaces(lines[1]:sub(#"Time:", #lines[1])):map(tonumber)
	local dist = split_on_spaces(lines[2]:sub(#"Distandce:", #lines[2])):map(tonumber)

	return { time = time, dist = dist }
end

local function count_wins(race)
	local wins = 0

	for t = 0, race.time do
		if ((race.time - t) * t) > race.dist then
			wins = wins + 1
		end
	end

	return wins
end

local function part1(f)
	local program = List.from_iter(io.lines(f)):apply(parse)

	local winning = 1
	for i = 1, #program.time do
		local race = { time = program.time[i], dist = program.dist[i] }
		winning = winning * count_wins(race)
	end
	return winning
end

test({
		{ func = part1, input = "example", output = 288 },
		{ func = part1, input = "input" }
})
