require("aoc")

local function parse(lines)
	local dirs = split_chars(lines[1])
	local paths = {}
	for i = 3, #lines do
		paths[lines[i]:sub(1, 3)] = {
			left = lines[i]:sub(8, 10),
			right = lines[i]:sub(13, 15)
		}
	end
	return { dirs = dirs, paths = paths }
end

local function part1(f)
	local lines = List.from_iter(io.lines(f))
	local map = parse(lines)

	local cur = "AAA"
	local steps = 0
	while cur ~= "ZZZ" do
		for dir in map.dirs:iter() do
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

local function parse2(lines)
	local dirs = split_chars(lines[1])

	local initials = List()
	local paths = {}
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

local function count_steps(map, initial)
	local cur = initial
	local steps = 0
	while string.sub(cur, 3, 3) ~= "Z" do
		for dir in map.dirs:iter() do
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
	local lines = List.from_iter(io.lines(f))
	local map = parse2(lines)
	return map.initials:map(function(x) return count_steps(map, x) end):reduce(lcm)
end

test({
	{ func = part1, input = "example1", output = 2 },
	{ func = part1, input = "example2", output = 6 },
	{ func = part1, input = "input", output = 16697 },
	{ func = part2, input = "example3", output = 6 },
	{ func = part2, input = "input" , output = 10668805667831},
})
