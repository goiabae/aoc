local aoc = require("aoc")

---@param nums integer[]
---@param ops (fun (x: integer, y: integer): integer)[]
local function is_equatable(nums, ops)
	local op_count = #ops
	local operation_count = (#nums - 1) - 1
	local calibration_result = nums[1]

	---@type integer[]
	local set = { nums[2] }

	for i = 1, operation_count-1 do
		local cur = {}
		local num =  nums[i+2]
		for _, acc in pairs(set) do
			for j = 1, op_count do
				local value = ops[j](acc, num)
				if value <= calibration_result then
					table.insert(cur, value)
				end
			end
		end
		set = cur
	end

	local num =  nums[#nums]
	for _, acc in pairs(set) do
		for j = 1, op_count do
			if ops[j](acc, num) == calibration_result then
				return true
			end
		end
	end

	return false
end

---@param x integer
---@param y integer
---@return integer
local function concat_int(x, y)
	return x * 10 * (10 ^ (math.floor(math.log(y, 10)))) + y
end

local o1 = { aoc.add, aoc.mul }
local o2 = { aoc.add, aoc.mul, concat_int }

---@type solver
local function solve (filename)
	local s1 = 0
	local s2 = 0
	for line in io.lines(filename) do
		local nums = aoc.list.map(aoc.split_with(line, ": "), tonumber)
		s1 = s1 + aoc.b2i(is_equatable(nums, o1)) * nums[1]
		s2 = s2 + aoc.b2i(is_equatable(nums, o2)) * nums[1]
	end

	return s1, s2
end

aoc.verify(solve, "example", 3749, 11387)
aoc.verify(solve, "input", 4364915411363, 38322057216320)
