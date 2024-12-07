local aoc = require("aoc")

local function is_equatable(nums, op_count, ops)
	local operation_count = (#nums - 1) - 1
	local combination_count = math.floor(op_count ^ operation_count)
	local calibration_result = nums[1]

	for i = 0, combination_count-1 do
		local result = nums[2]
		for j = 0, operation_count-1 do
			local it = nums[j + 3]
			local op = (math.floor(i / (op_count ^ j)) % op_count) + 1
			result = ops[op](result, it)
		end
		if result == calibration_result then
			return true
		end
	end
	return false
end

local function partn(filename, ops)
	local total = 0
	for line in io.lines(filename) do
		local nums = aoc.map(aoc.split_with(line, ": "), tonumber)
		if is_equatable(nums, #ops, ops) then
			total = total + nums[1]
		end
	end
	return total
end

local function concat(x, y) return tonumber(x .. y) end

local function part1(filename) return partn(filename, { aoc.add, aoc.mul }) end
local function part2(filename) return partn(filename, { aoc.add, aoc.mul, concat }) end

assert(part1("example") == 3749)
assert(part1("input") == 4364915411363)
assert(part2("example") == 11387)
assert(part2("input") == 38322057216320)
