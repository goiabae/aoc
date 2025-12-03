local aoc = require("aoc")

local function max_seqer()
	local memo = {}

	---@param xs integer[]
	---@param n integer
	---@return integer
	local function max_seq(xs, s, n)
		if memo[s] and memo[s][n] then
			return memo[s][n]
		end
		local m = 0
		for i = s, #xs - n + 1 do
			local d = xs[i]
			local c = (10 ^ (n-1)) * d + (n == 1 and 0 or max_seq(xs, i+1, n-1))
			m = math.max(m, c)
		end

		memo[s] = memo[s] or {}
		memo[s][n] = m
		return m
	end

	return max_seq
end

---@param bank string
---@return integer
local function max_joltage(bank, digit_count)
	return max_seqer()(aoc.digits(bank), 1, digit_count)
end

---@param digit_count integer
---@param filename string
---@return integer
local function file_joltage_sums(digit_count, filename)
	local s = 0
	for line in io.lines(filename) do
		local m = max_joltage(line, digit_count)
		s = s + m
	end
	return s
end

local part1 = aoc.fix(file_joltage_sums, 2)
local part2 = aoc.fix(file_joltage_sums, 12)

aoc.assert_eq(max_seqer()({ 1, 2, 3 }, 1, 2), 23)
aoc.assert_eq(max_seqer()({ 1, 2, 3 }, 1, 3), 123)
aoc.assert_eq(max_seqer()(aoc.digits("987654321111111"), 1, 12), 987654321111)

assert(part1("example") == 357)
assert(part1("input") == 17311)

aoc.assert_eq(part2("example"), 3121910778619)
aoc.assert_eq(part2("input"), 171419245422055)
