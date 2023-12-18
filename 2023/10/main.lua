require("aoc")

local eq = vec2_eq

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

local function find_loop(mat, start)
	local path = List()
	local coord = start

	local vec = { 0, 0 }
	while vec ~= nil do
		coord = { coord[1] + vec[1], coord[2] + vec[2] }
		table.insert(path, coord)
		vec = adj_vec(mat, coord, vec)
	end

	return path
end

local function start_equiv(path)
	local prev = path[#path]
	local start = path[1]
	local next = path[2]

	local d1 = { start[1] - prev[1], start[2] - prev[2] }
	local d2 = { next[1] - start[1], next[2] - start[2] }

	-- | -
	if eq(d1, d2) then
		if d1[1] ~= 0 then return "|" else return "-" end
	end

	-- F 7
	if eq(d1, { -1, 0 }) then
		if eq(d2, { 0, 1 }) then
			return "F"
		else
			return "7"
		end
	end

	-- L J
	if eq(d1, { 1, 0 }) then
		if eq(d2, { 0, 1}) then
			return "L"
		else
			return " J"
		end
	end
end

local function part2(f)
	local mat = List.from_iter(io.lines(f)):map(split_chars)

	local start = find_start(mat)
	local path = find_loop(mat, start)

	mat[start[1]][start[2]] = start_equiv(path)

	for i = 1, #mat do
		for j = 1, #mat[i] do
			if not belongs_to({i, j}, path, eq) then
				mat[i][j] = "."
			end
		end
	end

	local total = 0
	for i = 1, #mat do
		local inside = false
		local j = 1
		while j <= #mat[i] do
			local c = mat[i][j]
			if c == "." then
				if inside then
					total = total + 1
				end
				goto continue
			end

			if c == "|" then
				inside = not inside
				goto continue
			end

			if belongs_to({i, j}, path, eq) then
				local orient = mat[i][j] == "F" or mat[i][j] == "7"
				local k = 1
				while mat[i][j+k] == "-" do
					k = k + 1
				end
				if (mat[i][j+k] == "F" or mat[i][j+k] == "7") == not orient then
					inside = not inside
				end
				j = j + k
			end

			::continue::
			j = j + 1
		end
	end

	return total
end

test({
	{ func = part1, input = "example", output = 4 },
	{ func = part1, input = "example2", output = 8 },
	{ func = part1, input = "input", output = 6831 },
	{ func = part2, input = "example3", output = 4 },
	{ func = part2, input = "example4", output = 8 },
	{ func = part2, input = "input", output = 305 },
})
