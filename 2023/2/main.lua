local aoc = require("aoc")

---@alias game { id: integer, red: integer, green: integer, blue: integer }

---@param game game
---@return boolean
local function is_valid(game)
	return (game.red <= 12)
		and (game.blue <= 14)
		and (game.green <= 13)
end

---@param str string
---@return game
local function parse(str)
	local i = 1
	i = i + #"Game "
	local id = str:sub(i, i + aoc.find_char(":", str:sub(i)) - 1 - 1)
	i = i + #id + #": "

	local red = 0
	local blue = 0
	local green = 0

	for r in aoc.split_sub(str:sub(i), "; ") do
		for s in aoc.split_sub(r, ", ") do
			local space = aoc.find_char(" ", s)
			local amount = tonumber(s:sub(1, space-1))
			local color = s:sub(space+1)
			if color == "red" then
				red = math.max(red, amount)
			elseif color == "green" then
				green = math.max(green, amount)
			elseif color == "blue" then
				blue = math.max(blue, amount)
			end
		end
	end

	return { id = tonumber(id), red = red, green = green, blue = blue }
end

---@type solver
local function solve (filename)
	return aoc.iter.sum2(aoc.iter.map(aoc.iter.map(io.lines(filename), parse), function (game)
		return aoc.b2i(is_valid(game)) * game.id, game.red * game.blue * game.green
	end))
end

aoc.verify(solve, "example", 8, 2286)
aoc.verify(solve, "input", 2169, 60948)
