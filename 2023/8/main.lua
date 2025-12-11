local aoc = require("aoc")

local function parse2(lines)
	local dirs = aoc.split_chars(lines[1])
	local paths = {}
	local initials = {}
	for i = 3, #lines do
		if lines[i]:sub(3, 3) == "A" then
			table.insert(initials, lines[i]:sub(1, 3))
		end
		paths[lines[i]:sub(1, 3)] = {
			left = lines[i]:sub(8, 10),
			right = lines[i]:sub(13, 15)
		}
	end

	return { dirs = dirs, paths = paths, initials = initials }
end

local function part1(f)
	local lines = aoc.collect(io.lines(f))
	local map = parse2(lines)

	local cur = "AAA"
	local steps = 0
	while cur ~= "ZZZ" do
		for dir in aoc.list.iter(map.dirs) do
			if dir == "L" then
				cur = map.paths[cur].left
			elseif dir == "R" then
				cur = map.paths[cur].right
			end
			steps = steps + 1
		end
	end

	return steps
end

local function count_steps(map, initial)
	local cur = initial
	local steps = 0
	while string.sub(cur, 3, 3) ~= "Z" do
		for dir in aoc.list.iter(map.dirs) do
			if dir == "L" then
				cur = map.paths[cur].left
			elseif dir == "R" then
				cur = map.paths[cur].right
			end
			steps = steps + 1
		end
	end
	return steps
end

local function gcm(a, b)
	if a == b then return a end
	while a ~= 0 do
		a, b = a, b % a
		a, b = b, a
	end
	return b
end

local lcm = function(a, b) return (a * b) / gcm(a, b) end

local function part2(f)
	local lines = aoc.collect(io.lines(f))
	local map = parse2(lines)
	return aoc.list.reduce(aoc.list.map(map.initials, function(x) return count_steps(map, x) end), lcm)
end

local function solve (filename, fst)
	return (not fst) and part1(filename) or nil, part2(filename)
end

aoc.verify(solve, "example1", 2, 2)
aoc.verify(solve, "example2", 6, 6)
aoc.verify(function (f) return solve(f, true) end, "example3", nil, 6)
aoc.verify(solve, "input", 16697, 10668805667831)
