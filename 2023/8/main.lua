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

local function compile(map)
	local str = ""
	str = str .. map.dirs:reduce(concat) .. "\n"
	str = str .. "\n"
	for k, v in pairs(map.paths) do
		str = str .. string.format("%s = (%s, %s)\n", k, v.left, v.right)
	end
	return str
end

local function part1(f)
	local lines = List.from_iter(io.lines(f))
	local map = parse(lines)
	print(compile(map))

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

test({
	{ func = part1, input = "example1", output = 2 },
	{ func = part1, input = "example2", output = 6 },
	{ func = part1, input = "input" }
})
