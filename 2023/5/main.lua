require("aoc")

local function parse(lines)
	local seeds = split_on_spaces(lines[1]:sub(find_char(" ", lines[1])+1, #(lines[1]))):map(tonumber)

	local i = 3
	local maps = List()
	while i <= #lines do
		if lines[i] ~= "" then
			local dash = find_char("-", lines[i])
			local space = find_char(" ", lines[i])
			local map = {
				from = lines[i]:sub(1, dash-1),
				to = lines[i]:sub(dash + #"to-" + 1, space-1),
				ranges = {}
			}

			local k = 1
			while lines[i+k] ~= "" and (i+k) <= #lines do
				table.insert(map.ranges, split_on_spaces(lines[i+k]):map(tonumber))
				k = k + 1
			end
			table.insert(maps, map)
			i = i + k
		end
		i = i + 1
	end

	return { seeds = seeds, maps = maps }
end

local function compile(input)
	local str = ""
	str = str .. "seeds: " .. input.seeds:reduce(function(x, y) return x .. " " .. y end) .. "\n"

	for i = 1, #input.maps do
		local map = input.maps[i]
		str = str .. "\n"
		str = str .. map.from .. "-to-" .. map.to .. " map:" .. "\n"
		for j = 1, #map.ranges do
			str = str .. map.ranges[j]:reduce(function(x, y) return x .. " " .. y end) .. "\n"
		end
	end

	return str
end

local function convert(num, map)
	for i = 1, #map.ranges do
		local range = map.ranges[i]
		local dest = range[1]
		local source = range[2]
		local length = range[3]

		if num >= source and num <= (source + length) then
			local offset = num - source
			return dest + offset
		end
	end

	return num
end

local function part1(f)
	local input = read_file(f)
	local almanac = List.from_iter(io.lines(f)):apply(parse)
	local compiled = compile(almanac)

	if input ~= compiled then
		print(input)
		print(compiled)
	end

	local acc = almanac.seeds

	for i = 1, #almanac.maps do
		local map = almanac.maps[i]
		acc = acc:map(function(num) return convert(num, map) end)
	end

	return acc:reduce(min)
end

test({
	{ func = part1, input = "example", output = 35 },
	{ func = part1, input = "input", output = 26273516 }
})
