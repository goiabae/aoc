local aoc = require("aoc")

local function eq (a, b) return a[1] == b[1] and a[2] == b[2] end

---@param mat string[][]
---@return [integer, integer]?
local function find_start(mat)
	for i, j, c in aoc.matrix.iter(mat) do
		if c == "S" then
			return { i, j }
		end
	end
end

local function are_connected(a, b, off)
	if a == nil or b == nil then return false end
	return ((off[1] == -1 and off[2] == 0 and (a == "|" or a == "L" or a == "J" or a == "S") and (b == "|" or b == "7" or b == "F")))
		or (off[1] == 1 and off[2] == 0 and (a == "|" or a == "7" or a == "F" or a == "S") and (b == "|" or b == "L" or b == "J"))
		or (off[1] == 0 and off[2] == -1 and (a == "-" or a == "J" or a == "7" or a == "S") and (b == "-" or b == "L" or b == "F"))
		or (off[1] == 0 and off[2] == 1 and (a == "-" or a == "L" or a == "F" or a == "S") and (b == "-" or b == "J" or b == "7"))
end

local function adj_vec(mat, coord, prev)
	local x = aoc.matrix.at(mat, coord)
	for i = -1, 1 do
		for j = -1, 1 do
			if not (i == 0 and j == 0) and not (i == -prev[1] and j == -prev[2]) and are_connected(x, aoc.matrix.at(mat, { coord[1]+i, coord[2]+j }), { i, j }) then
				return { i, j }
			end
		end
	end
end

---@param start [integer, integer]
local function part1(mat, start)
	local coord = start

	local path_len = 0
	local vec = { 0, 0 }

	while vec ~= nil do
		coord = { coord[1] + vec[1], coord[2] + vec[2] }
		path_len = path_len + 1
		vec = adj_vec(mat, coord, vec)
	end

	return path_len / 2
end

---@param mat string[][]
---@param start [integer, integer]
---@return [integer, integer][]
local function find_loop(mat, start)
	local path = {}
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

	return eq(d1, d2) and (d1[1] ~= 0 and "|" or "-")
		or eq(d1, { -1, 0 }) and (eq(d2, { 0, 1 }) and "F" or "7")
		or (eq(d1, { 1, 0 }) and (eq(d2, { 0, 1}) and "L" or "J") or nil)
end

---@param mat string[][]
---@param start [integer, integer]
local function part2(mat, start)
	local path = find_loop(mat, start)

	mat[start[1]][start[2]] = start_equiv(path)

	local set = {}
	for i = 1, #path do
		local a = path[i][1]
		local b = path[i][2]
		set[a] = set[a] or {}
		set[a][b] = set[a][b] or true
	end

	for i = 1, #mat do
		for j = 1, #mat[i] do
			if not aoc.matrix.at(set, {i, j}) then
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

			if aoc.matrix.at(set, {i, j}) then
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

local function solve (filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))
	local start = assert(find_start(mat))
	return part1(mat, start), part2(mat, start)
end

--aoc.assert_eq(part1("example"), 4)
--aoc.assert_eq(part1("example2"), 8)
--aoc.assert_eq(part2("example3"), 4)
--aoc.assert_eq(part2("example4"), 8)

aoc.verify(solve, "input", 6831, 305)
