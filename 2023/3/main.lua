local aoc = require("aoc")

---@param char string?
---@return boolean
local function is_symbol(char)
	return char and char ~= '.' and not aoc.is_digit(char) or false
end

---@param mat string[][]
local function adjacent(mat, num)
	local adj = {
		{ num.i-1, num.from-1 },
		{ num.i  , num.from-1 },
		{ num.i+1, num.from-1 },
		{ num.i-1, num.to+1   },
		{ num.i  , num.to+1   },
		{ num.i+1, num.to+1   }
	}

	for j = num.from, num.to do
		table.insert(adj, { num.i-1, j })
		table.insert(adj, { num.i+1, j })
	end

	return aoc.list.filter(adj, function(coord) return is_symbol(aoc.matrix_at(mat, coord)) end)
end

---@param filename string
---@return { i: integer, from: integer, to: integer }[]
local function find_nums(filename)
	local nums = {}
	local i = 1
	for line in io.lines(filename) do
		local s, e, _ = string.find(line, "[%d]+", 1)
		while s do
			table.insert(nums, { i = i, from = s, to = e })
			s, e, _ = string.find(line, "[%d]+", e + 1)
		end
		i = i + 1
	end
	return nums
end

---@return integer
local function to_number(mat, row, from, to)
	local s = ""
	for i = from, to do
		s = s .. mat[row][i]
	end
	return assert(tonumber(s))
end

---@param mat string[][]
local function sum_parts(mat, nums)
	return aoc.list.sum(nums, function (_, part)
		for j = part.from, part.to do
			if aoc.exists_adjacent(mat, part.i, j, is_symbol) then
				return to_number(mat, part.i, part.from, part.to)
			end
		end
		return 0
	end)
end

---@param mat string[][]
---@return integer
local function sum_gears(mat, nums)

	local gears = {}

	for num in aoc.list.iter(nums) do
		for adj in aoc.list.iter(adjacent(mat, num)) do
			local a = adj[1]
			local b = adj[2]
			gears[a] = gears[a] or {}
			gears[a][b] = gears[a][b] or {}
			table.insert(gears[a][b], to_number(mat, num.i, num.from, num.to))
		end
	end

	local s = 0

	for _, x in pairs(gears) do
		for _, v in pairs(x) do
			if #v == 2 then
				s = s + v[1] * v[2]
			end
		end
	end

	return s
end

---@type solver
local function solve (filename)
	local b = aoc.parse_char_mat(aoc.read_file(filename))
	local nums = find_nums(filename)
	return sum_parts(b, nums), sum_gears(b, nums)
end

aoc.verify(solve, "example", 4361, 467835)
aoc.verify(solve, "test1", 13112, 7435797)
aoc.verify(solve, "input", 543867, 79613331)
