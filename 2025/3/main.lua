local aoc = require("aoc")

---@param memo table<integer, table<integer, integer>>
---@param xs integer[]
---@param s integer
---@param n integer
---@return integer
local function max_seq(memo, xs, s, n)
	if memo[s] and memo[s][n] then
		return memo[s][n]
	end
	local m = 0
	for i = s, #xs - n + 1 do
		local d = xs[i]
		local c = (10 ^ (n-1)) * d + (n == 1 and 0 or max_seq(memo, xs, i+1, n-1))
		m = math.max(m, c)
	end

	memo[s] = memo[s] or {}
	memo[s][n] = m
	return m
end

---@param memo table<integer, table<integer, integer>>
---@param digit_count integer
---@param digits integer[]
---@return integer
local function max_joltage(memo, digit_count, digits)
	return max_seq(memo, digits, 1, digit_count)
end

---@type solver
local function solve(filename)
	local s1, s2 = 0, 0
	for bank in io.lines(filename) do
		local memo = {}
		local digits = aoc.digits(bank)
		local p1, p2 = max_joltage(memo, 2, digits), max_joltage(memo, 12, digits)
		s1, s2 = s1 + p1, s2 + p2
	end
	return s1, s2
end

aoc.verify(solve, "example", 357, 3121910778619)
aoc.verify(solve, "input", 17311, 171419245422055)
