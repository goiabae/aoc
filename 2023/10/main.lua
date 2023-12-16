require("aoc")

local function find_start(mat)
	for i = 1, #mat do
		for j = 1, #mat[i] do
			if mat[i][j] == "S" then return { i, j } end
		end
	end
end

local function are_connected(a, b, off)
	if a == nil or b == nil then return false end

	-- b
	-- a
	if off[1] == -1 and off[2] == 0 then
		if (a == "|" or a == "L" or a == "J" or a == "S") and (b == "|" or b == "7" or b == "F") then
			return true
		end
	end

	-- a
	-- b
	if off[1] == 1 and off[2] == 0 then
		if (a == "|" or a == "7" or a == "F" or a == "S") and (b == "|" or b == "L" or b == "J") then
			return true
		end
	end

	-- b a
	if off[1] == 0 and off[2] == -1 then
		if (a == "-" or a == "J" or a == "7" or a == "S") and (b == "-" or b == "L" or b == "F") then
			return true
		end
	end

	-- a b
	if off[1] == 0 and off[2] == 1 then
		if (a == "-" or a == "L" or a == "F" or a == "S") and (b == "-" or b == "J" or b == "7") then
			return true
		end
	end

	return false
end

local function adj_vec(mat, coord, prev)
	for i = -1, 1 do
		for j = -1, 1 do
			if i == 0 and j == 0 then goto continue end
			if are_connected(mat:at(coord), mat:at({ coord[1]+i, coord[2]+j }), { i, j }) and not (i == -prev[1] and j == -prev[2]) then
				return { i, j }
			end
			::continue::
		end
	end
end

local function part1(f)
	local mat = List.from_iter(io.lines(f)):map(split_chars)
	local path = List()

	local vec = { 0, 0 }
	local coord = find_start(mat)

	while vec ~= nil do
		coord = { coord[1] + vec[1], coord[2] + vec[2] }
		table.insert(path, coord)
		vec = adj_vec(mat, coord, vec)
	end

	return #path / 2
end

test({
	{ func = part1, input = "example", output = 4 },
	{ func = part1, input = "example2", output = 8 },
	{ func = part1, input = "input", output = 6831 },
})
