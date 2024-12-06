local aoc = require("aoc")

local function find_pieces(mat, max_height, max_width)
	local obs = {}
	local start = nil
	for i = 1, max_height do
		for j = 1, max_width do
			local char = mat[i][j]
			local h = max_height - i + 1
			local w = j

			if char == '#' then
				table.insert(obs, { h = h, w = w })
			elseif char == '^' then
				start = { h = h, w = w }
			end
		end
	end
	return obs, start
end

local function in_bounds(guard, max_height, max_width)
	return guard.h <= max_height and guard.h >= 0 and guard.w <= max_width and guard.w >= 0
end

local function obstructed(guard, obs, speed)
	for obj in aoc.iter(obs) do
		if ((guard.h + speed.h) == obj.h) and ((guard.w + speed.w) == obj.w) then
			return true
		end
	end
	return false
end

local function part1(filename)
	local points = aoc.parse_char_mat(aoc.read_file(filename))
	local max_height = #points
	local max_width = #(points[1])
	local obs, guard = find_pieces(points, max_height, max_width)
	local speed = { h = 1, w = 0 }
	local passed = {}

	assert(guard ~= nil)

	while in_bounds(guard, max_height, max_width) do
		table.insert(passed, { h = guard.h, w = guard.w })
		if obstructed(guard, obs, speed) then
			if speed.h == 1 and speed.w == 0 then
				speed = { h = 0, w = 1 }
			elseif speed.h == 0 and speed.w == 1 then
				speed = { h = -1, w = 0 }
			elseif speed.h == -1 and speed.w == 0 then
				speed = { h = 0, w = -1 }
			elseif speed.h == 0 and speed.w == -1 then
				speed = { h = 1, w = 0 }
			end
		end
		guard = { h = guard.h + speed.h, w = guard.w + speed.w }
	end

	local uniq = aoc.unique(passed, function (a, b) return a.h == b.h and a.w == b.w end)
	return #uniq - 1
end

assert(part1("example") == 41)
assert(part1("input") == 4964)
