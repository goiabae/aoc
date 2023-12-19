require("aoc")

local function transpose(mat)
	local trans = List()
	for i = 1, #mat[1] do
		local row = List()
		for j = 1, #mat do
			table.insert(row, mat[j][i])
		end
		table.insert(trans, row)
	end
	return trans
end

local function expand(space)
	local expanded= List()
	for i = 1, #space do
		local empty = true
		for j = 1, #space[i] do
			if space[i][j] == "#" then empty = false end
		end
		table.insert(expanded, space[i])
		if empty then
			table.insert(expanded, space[i])
		end
	end
	return expanded
end

local function dist(line)
	local a = line[1]
	local b = line[2]
	return math.abs(b[1] - a[1]) + math.abs(b[2] - a[2])
end

local function find_galaxies(space)
	local gals = List()
	for i = 1, #space do
		for j = 1, #space[i] do
			if space[i][j] == "#" then table.insert(gals, {i, j}) end
		end
	end
	return gals
end

local function part1(f)
	local mat = List.from_iter(io.lines(f)):map(split_chars)
	local exp = transpose(expand(transpose(expand(mat))))
	local gals = find_galaxies(exp)
	return gals:pairs():map(dist):reduce(plus)
end

test({
	{ func = part1, input = "example", output = 374 },
	{ func = part1, input = "input" },
})
