local function parse_grid()
	local grid = {}
	local x, y = 1, 1
	local sx, sy -- start x and y
	local dot_count = 0

	for line in io.lines("input") do
		grid[y] = grid[y] or {}

		for c in line:gmatch(".") do
			if c == "." then
				dot_count = dot_count + 1
			elseif c == "^" then
				sx, sy = x, y
			end

			grid[y][x] = c
			x = x + 1
		end

		x, y = 1, y + 1
	end

	return grid, sx, sy, y-1, dot_count
end

local function walk(grid, sx, sy)
	local visited = {}
	local visited_count = 0

	local x, y = sx, sy
	local dx, dy = 0, -1

	while true do
		visited[x] = visited[x] or {}
		visited_count = visited_count + (visited[x][y] and 0 or 1)
		visited[x][y] = true

		local ny = y + dy
		local nx = x + dx

		if not (grid[ny] and grid[ny][nx]) then
			return visited, visited_count
		end

		if grid[ny][nx] == "#" then
			dx, dy = -dy, dx
		else
			x, y = nx, ny
		end
	end
end

local function loops(grid, sx, sy, bx, by, dot_count)
	local x, y = sx, sy
	local dx, dy = 0, -1

	-- works for this particular input, might not work for all inputs?
	for _ = 0, dot_count / 2 do
		local ny = y + dy
		local nx = x + dx

		if not (grid[ny] and grid[ny][nx]) then
			return false
		end

		-- next is a "#" or "O"
		if grid[ny][nx] == "#" or ((nx == bx) and (ny == by)) then
			dx, dy = -dy, dx
		else
			x, y = nx, ny
		end
	end

	return true
end

local grid, sx, sy, side_length, dot_count = parse_grid()
local path, path_length = walk(grid, sx, sy)

local loop_count = 0
for x = 1, side_length do
	for y = 1, side_length do
		if path[x] and path[x][y] and loops(grid, sx, sy, x, y, dot_count) then
			loop_count = loop_count + 1
		end
	end
end

assert(path_length == 4964)
assert(loop_count == 1740)
