local aoc = require("aoc")

local function get_area(a, b)
	return (math.abs(a[1] - b[1]) + 1) * (math.abs(a[2] - b[2]) + 1)
end

local function combinations (xs)
	local ys = {}
	for i = 1, aoc.len(xs) do
		for j = i+1, aoc.len(xs) do
			table.insert(ys, { xs[i], xs[j], get_area(xs[i], xs[j]) })
		end
	end
	return ys
end

local function circular_tuple_windows(xs)
	local function f (a, b)
		return { math.min(a[1], b[1]), math.max(a[1], b[1]), math.min(a[2], b[2]), math.max(a[2], b[2])}
	end
	local ys = {}
	for i = 1, aoc.len(xs)-1 do
		table.insert(ys, f(xs[i], xs[i+1]))
	end
	table.insert(ys, f(xs[aoc.len(xs)], xs[1]))
	return ys
end

local function solve (filename)
	local points = {}
	for line in io.lines(filename) do
		table.insert(points, aoc.split_with(line, ",", tonumber))
	end

	local m = 0
	for i = 1, aoc.len(points) do
		local p1 = points[i]
		for j = i+1, aoc.len(points) do
			local p2 = points[j]
			if p1[1] ~= p2[1] and p1[2] ~= p2[2] then
				local h = (math.abs(p1[1] - p2[1]) + 1)
				local w = (math.abs(p1[2] - p2[2]) + 1)
				local a = h * w
				m = math.max(m, a)
			end
		end
	end

	local p2 = (function()
		local lines = circular_tuple_windows(points)
		local xs = combinations(points)
		aoc.sort(xs, function (a, b) return a[3] > b[3] end)
		local i = aoc.list.find_where(xs, function (_, p)
			local a, b = table.unpack(p)
			local t1 = math.max(a[1], b[1])
			local t2 = math.min(a[1], b[1])
			local t3 = math.max(a[2], b[2])
			local t4 = math.min(a[2], b[2])
			return aoc.list.for_all(lines, function (p)
				return t1 <= p[1]
					or t2 >= p[2]
					or t3 <= p[3]
					or t4 >= p[4]
			end)
		end)
		return xs[i][3]
	end)()

	return m, p2
end

aoc.verify(solve, "example", 50, 24)
aoc.verify(solve, "input", 4733727792, 1566346198)
