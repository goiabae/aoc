local function parse_map(filename)
	local map = {}
	local antennas = {}
	local i, j = 1, 1

	for line in io.lines(filename) do
		map[i] = map[i] or {}

		for c in string.gmatch(line, ".") do
			map[i][j] = c
			if c ~= '.' then
				-- use for determining whether there exists an antenna of frequency c at point (i, j)
				antennas[c] = antennas[c] or {}
				antennas[c][i] = antennas[c][i] or {}
				antennas[c][i][j] = true
			end
			j = j + 1
		end

		i = i + 1
		j = 1
	end
	return map, antennas
end

-- implace union
local function unite(a, b)
	for i, js in pairs(b) do
		for j, _ in pairs(js) do
			a[i] = a[i] or {}
			a[i][j] = true
		end
	end
end

local function find_antinodes(freq, map, points, any_dist)
	local antinodes = {}

	for i1, j1s in pairs(points) do
		for j1, _ in pairs(j1s) do

			for i2, j2s in pairs(points) do
				for j2, _ in pairs(j2s) do

					if i1 ~= i2 and j1 ~= j2 then

						local di = i2 - i1
						local dj = j2 - j1

						if any_dist then

							-- after
							local ia = i2
							local ja = j2
							while map[ia] and map[ia][ja] do
								antinodes[ia] = antinodes[ia] or {}
								antinodes[ia][ja] = true
								ia, ja = ia + di, ja + dj
							end

							-- before
							local ib = i1
							local jb = j1
							while map[ib] and map[ib][jb] do
								antinodes[ib] = antinodes[ib] or {}
								antinodes[ib][jb] = true
								ib, jb = ib - di, jb - dj
							end

						else

							-- after
							local ia = i2 + di
							local ja = j2 + dj
							if map[ia] and map[ia][ja] and map[ia][ja] ~= freq then
								antinodes[ia] = antinodes[ia] or {}
								antinodes[ia][ja] = true
							end

							-- before
							local ib = i1 - di
							local jb = j1 - dj
							if map[ib] and map[ib][jb] and map[ib][jb] ~= freq then
								antinodes[ib] = antinodes[ib] or {}
								antinodes[ib][jb] = true
							end

						end
					end
				end
			end
		end
	end

	return antinodes
end

local function partn(any_dist)
	return function (filename)
		local map, as = parse_map(filename)

		local result = {}
		for c, points in pairs(as) do
			local antinodes = find_antinodes(c, map, points, any_dist)
			unite(result, antinodes)
		end

		local total = 0
		for _, js in pairs(result) do
			for _, _ in pairs(js) do
				total = total + 1
			end
		end

		return total
	end
end

local part1 = partn(false)
local part2 = partn(true)

--assert(part1("example") == 14)
assert(part1("input") == 276)
--assert(part2("example") == 34)
assert(part2("input") == 991)
