require("aoc")

local cubes = {
	red = 12,
	green = 13,
	blue = 14,
}

local function is_valid(game)
	return (game.cubes.red <= cubes.red) and (game.cubes.blue <= cubes.blue) and (game.cubes.green <= cubes.green)
end

local function parse(str)
	str = str:sub(#"Game "+ 1, #str)
	local id = str:sub(1, find_char(":", str) - 1)
	str = str:sub(1 + 2 + #id, #str) -- skip ": " prefix

	local game = { red = 0, blue = 0, green = 0 }

	local function find_delim(str2)
		local comma = find_char(",", str2)
		local semicolon = find_char(";", str2)
		if (not comma) and (not semicolon) then
			return #str2 + 1
		end
		if not comma then return semicolon end
		if not semicolon then return comma end
		if comma < semicolon then return comma else return semicolon end
	end

	while (#str) > 0 do
		local space = find_char(" ", str)
		local amount = str:sub(1, space - 1)
		str = str:sub(1 + #amount + 1, #str)
		local delim = find_delim(str)
		local color = str:sub(1, delim - 1)
		str = str:sub(#color + 1 + 2, #str)

		if color == "red" then
			game.red = max(game.red, tonumber(amount))
		elseif color == "green" then
			game.green = max(game.green, tonumber(amount))
		elseif color == "blue" then
			game.blue = max(game.blue, tonumber(amount))
		end
	end

	return { id = tonumber(id), cubes = game }
end

local function part1(f)
	return List
		.from_iter(io.lines(f))
		:map(parse)
		:filter(is_valid)
		:get("id")
		:reduce(function(acc, x) return acc + x end)
end

local function part2(f)
	return List
		.from_iter(io.lines(f))
		:map(parse)
		:get("cubes")
		:map(function(g) return g.red * g.blue * g.green end)
		:reduce(plus)
end

test({
	{ func = part1, input = "./example",   output = 8 },
	{ func = part1, input = "./input", output = 2169 },
	{ func = part2, input = "./example",   output = 2286 },
	{ func = part2, input = "./input", output = 60948 }
})
