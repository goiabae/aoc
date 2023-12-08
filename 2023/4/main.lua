require("aoc")

local function split_on_spaces(str)
	local acc = List()
	local i = 1
	while i < #str + 1 do
		if is_digit(str:sub(i, i)) then
			local k = 0
			while is_digit(str:sub(i+k, i+k)) do
				k = k + 1
			end
			table.insert(acc, str:sub(i, i+k))
			i = i + k
		end
		i = i + 1
	end
	return acc
end

local function parse(str)
	local colon = find_char(":", str)
	local pipe = find_char("|", str)

	return List.from_table({
		winning = split_on_spaces(str:sub(colon+2, pipe-2)):map(tonumber),
		scratch = split_on_spaces(str:sub(pipe+2, #str)):map(tonumber)
	})
end

local function winning_nums(game)
	local present = List()
	for i = 1, #game.winning do
		for j = 1, #game.scratch do
			if game.scratch[j] == game.winning[i] then
				table.insert(present, game.winning[i])
			end
		end
	end
	return present
end

local function pow(b, e)
	local acc = 1
	for _ = 1, e do
		acc = acc * b
	end
	return acc
end

local function part1(f)
	return List
		.from_iter(io.lines(f))
		:map(parse)
		:map(winning_nums)
		:map(function(nums) return #nums end)
		:map(function(count) if count > 0 then return pow(2, count-1) else return 0 end end)
		:reduce(plus)
end

local function part2(f)
	local games = List.from_iter(io.lines(f)):map(parse):map(function(game) game.count = 1; return game end)
	local total = 0
	for i = 1, #games do
		total = total + games[i].count
		local won = #(winning_nums(games[i]))
		for j = 1, won do
			if (i + j) > #games then break end
			games[i+j].count = games[i+j].count + games[i].count
		end
	end
	return total
end

test({
	{ func = part1, input = 'example', output = 13 },
	{ func = part1, input = "input",   output = 26218 },
	{ func = part2, input = "example", output = 30 },
	{ func = part2, input = "input",   output = 9997537 },
})
