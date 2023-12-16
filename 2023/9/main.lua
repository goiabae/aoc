require("aoc")

local function make_triangle(seq)
	local tri = List.from_list({ seq })
	while not tri[#tri]:map(function(x) return x == 0 end):reduce(log_and) do
		table.insert(tri, slide_map(tri[#tri], 2, call2(swap(sub))))
	end

	return tri
end

local function find_next(tri)
	table.insert(tri[#tri], 0)
	for i = #tri - 1, 1, -1 do
		table.insert(tri[i], tri[i][#tri[i]] + tri[i+1][#tri[i+1]])
	end
	return tri[1][#tri[1]]
end

local function find_prev(tri)
	table.insert(tri[#tri], 1, 0)
	for i = #tri - 1, 1, -1 do
		table.insert(tri[i], 1, tri[i][1] - tri[i+1][1])
	end
	return tri[1][1]
end

local function part1(f)
	local hists = List
		.from_iter(io.lines(f))
		:map(function(line) return split_on_spaces(line):map(tonumber) end)
	local tris = hists:map(make_triangle)
	local next = tris:map(find_next)
	return next:reduce(plus)
end

local function part2(f)
	local hists = List
		.from_iter(io.lines(f))
		:map(function(line) return split_on_spaces(line):map(tonumber) end)
	local tris = hists:map(make_triangle)
	local next = tris:map(find_prev)
	return next:reduce(plus)
end

test({
	{ func = part1, input = "example", output = 114 },
	{ func = part1, input = "input", output = 1702218515 },
	{ func = part2, input = "example", output = 2 },
	{ func = part2, input = "input", output = 925 },
})
