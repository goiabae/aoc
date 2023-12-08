require("aoc")

local function digit_prefix(str)
	for n = 0, 9 do
		if tostring(n) == str:sub(1, 1) then
			return { num = n, len = 1 }
		end
	end
	return { num = nil, len = 0 }
end

local function number_prefix(str)
	local words = { "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }
	for i = 1, 10 do
		local word = words[i]
		if word == str:sub(1, #word) then
			return { num = i - 1, len = #word }
		end
	end
	return { num = nil, len = 0 }
end

local function digit_chars(line)
	local acc = { it = {}, len = 0 }
	for i = 1, #line do
		local c = line:sub(i, i)
		local d = digit_prefix(c)
		if d.len > 0 then
			table.insert(acc.it, d.num)
			acc.len = acc.len + 1
		end
	end
	return acc
end

local function digit_words_and_chars(line)
	local acc = { it = {}, len = 0 }

	local function aux(str)
		local word = number_prefix(str)
		if word.len > 0 then
			return word
		end
		local digit = digit_prefix(str)
		if digit.len > 0 then
			return digit
		end
		return { num = nil, len = 0 }
	end

	while true do
		if #line <= 0 then
			break
		end
		local num = aux(line)
		line = line:sub(1+1, #line)
		if num.len > 0 then
			table.insert(acc.it, num.num)
			acc.len = acc.len + 1
		end
	end
	return acc
end

local function part1(f)
	local acc = 0
	for line in io.lines(f) do
		local ns = digit_chars(line)
		local n = ns.it[1] .. ns.it[ns.len]
		acc = acc + tonumber(n)
	end
	return acc
end

local function part2(f)
	local acc = 0
	for line in io.lines(f) do
		local ns = digit_words_and_chars(line)
		local n = ns.it[1] .. ns.it[ns.len]
		acc = acc + tonumber(n)
	end
	return acc
end


test({
	{ func = part1, input = "./ex1",   output = 142 },
	{ func = part2, input = "./ex2",   output = 281 },
	{ func = part1, input = "./input", output = 54634 },
	{ func = part2, input = "./input", output = 53855 }
})
