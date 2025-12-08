local aoc = require("aoc")

local word_patterns = {
	["^zero"] = "0",
	["^one"] = "1",
	["^two"] = "2",
	["^three"] = "3",
	["^four"] = "4",
	["^five"] = "5",
	["^six"] = "6",
	["^seven"] = "7",
	["^eight"] = "8",
	["^nine"] = "9"
}

---@param str string
---@return integer?
local function find_number_word_prefix(str)
	local f = function (w, _) return str:match(w) end
	return aoc.snd(aoc.id)(aoc.iter.find2(aoc.map.iter(word_patterns), f))
end

---@param line string
---@return iterator<string>
local function digit_words_and_chars(line)
	local i = 1
	return function ()
		while i <= #line do
			local num = line:match("^%d", i) or find_number_word_prefix(line:sub(i))
			i = i + (num and #num or 1)
			if num then
				return num
			end
		end
		return nil
	end
end

---@type solver
local function solve (filename)

	-- I've given myself the liberty of allowing empty sequences (for part1("ex2")
	-- in particular), but the puzzle only specifies sequences of 1 or more
	-- elements.
	---@param it iterator<string>
	---@return integer
	local function g (it)
		local i = it()
		return i and tonumber(i .. (aoc.iter.last(it) or i)) or 0
	end

	return aoc.iter.unzip2_sum(io.lines(filename), function (line)
		return g(string.gmatch(line, "%d")), g(digit_words_and_chars(line))
	end)
end

aoc.verify(solve, "ex1", 142, 142)
aoc.verify(solve, "ex2", 209, 281)
aoc.verify(solve, "input", 54634, 53855)
