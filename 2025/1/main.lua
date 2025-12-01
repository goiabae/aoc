
local function euc(a, b)
	return (a < 0 and (((a % b) + b) % b) or (a % b))
end

---@param filename string
---@return integer
local function part1(filename)
	local pos = 50
	local zeroes = 0
	for line in io.lines(filename) do
		local sign = (string.sub(line, 1, 1) == "R" and 1 or -1)
		local diff = sign * tonumber(string.sub(line, 2))
		pos = (pos + diff) % 100
		if pos == 0 then
			zeroes = zeroes + 1
		end
	end
	return zeroes
end

---@param filename string
---@return integer
local function part2(filename)
	local pos = 50
	local zeroes = 0
	for line in io.lines(filename) do
		local sign = (string.sub(line, 1, 1) == "R" and 1 or -1)
		local diff = tonumber(string.sub(line, 2))

		local ndiff = diff
		local nzeroes = 0
		while ndiff > 0 do
			pos = (pos + sign) % 100
			if pos == 0 then
				nzeroes = nzeroes + 1
			end
			ndiff = ndiff - 1
		end
		zeroes = zeroes + nzeroes

	end
	return zeroes
end

assert(part1("example") == 3)
assert(part1("input") == 1089)

assert(part2("example") == 6)
assert(part2("input") == 6530)
