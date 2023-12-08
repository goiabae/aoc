local function map_seq(f, xs)
	local acc = {}
	for i = 1, #xs do
		table.insert(acc, f(xs[i]))
	end
	return acc
end

local function map_it(f, it)
	local acc = {}
	while true do
		local v = it()
		if v then
			table.insert(acc, f(v))
		else
			break
		end
	end
	return acc
end

local function reduce(f, xs)
	local acc = xs[1]
	for i = 2, #xs do
		acc = f(acc, xs[i])
	end
	return acc
end

local function iter(it)
	local acc = {}
	while true do
		local v = it()
		if v then
			table.insert(acc, v)
		end
	end
	return acc
end

local function filter_seq(pred, xs)
	local acc = {}
	for i = 1, #xs do
		if pred(xs[i]) then
			table.insert(acc, xs[i])
		end
	end
	return acc
end

local function max(x, y)
	if x > y then return x else return y end
end

local function id(x)
	return x
end

local function plus(x, y)
	return x + y
end
require("aoc")

local cubes = {
	red = 12,
	green = 13,
	blue = 14,
}

local function is_valid(game)
	return (game.cubes.red <= cubes.red) and (game.cubes.blue <= cubes.blue) and (game.cubes.green <= cubes.green)
end

local function find_char(c, str)
	for i = 1, #str do
		if str:sub(i, i) == c then
			return i
		end
	end
	return nil
end

local function parse(str)
	str = str:sub(6, #str) -- skip "Game " prefix
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

local function get(col, xs)
	local acc = {}
	for i = 1, #xs do
		table.insert(acc, xs[i][col])
	end
	return acc
end

local function part1(f)
	local lines = map_it(id, io.lines(f))
	local games = map_seq(parse, lines)
	local valid = filter_seq(is_valid, games)
	return reduce(function(acc, x) return acc + x end, get("id", valid))
end

local function part2(f)
	local lines = map_it(id, io.lines(f))
	local games = map_seq(parse, lines)
	local colors = get("cubes", games)
	local powers = map_seq(function(g) return g.red * g.blue * g.green end, colors)
	return reduce(plus, powers)
end

test({
	{ func = part1, input = "./example",   output = 8 },
	{ func = part1, input = "./input", output = 2169 },
	{ func = part2, input = "./example",   output = 2286 },
	{ func = part2, input = "./input", output = 60948 }
})
