local aoc = require("aoc")

---@param str string
---@return boolean
local function is_invalid(str)
	for i = 2, #str do
		if #str % i == 0 then
			local l = #str / i
			local all_equal = true
			local fst = string.sub(str, 1, l)
			for j = 1, i-1 do
				local b = string.sub(str, j*l+1, (j+1)*l)
				if b ~= fst then
					all_equal = false
					break
				end
			end
			if all_equal then
				return true
			end
		end
	end
	return false
end

---@param filename string
---@return integer
local function part1(filename)
	local invalid = 0
	local mat = aoc.parse_number_mat(aoc.read_file(filename), ",", "-")
	for _, r in pairs(mat) do
		for i = r[1], r[2] do
			local s = tostring(i)
			if aoc.is_even(#s) then
				local a, b = aoc.cut_half(s)
				if a == b then
					invalid = invalid + i
				end
			end
		end
	end
	return invalid
end

---@param filename string
---@return integer
local function part2(filename)
	local invalid = 0
	local mat = aoc.parse_number_mat(aoc.read_file(filename), ",", "-")
	for _, r in pairs(mat) do
		for i = r[1], r[2] do
			local s = tostring(i)
			if is_invalid(s) then
				invalid = invalid + i
			end
		end
	end
	return invalid
end

assert(part1("example") == 1227775554)
assert(part1("input") == 13919717792)

assert(part2("example") == 4174379265)
assert(part2("input") == 14582313461)
