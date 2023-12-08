require("aoc")

local function is_symbol(char)
	return char ~= '.' and not is_digit(char) and char ~= nil
end

local function has_adjacent_symbol(lines, cell)
	return List.from_list({
		{-1, -1}, {-1, 0}, {-1, 1},
		{ 0, -1},          { 0, 1},
		{ 1, -1}, { 1, 0}, { 1, 1}
	})
		:map(function(x) return is_symbol(lines:at(cell + x)) end)
		:reduce(log_or)
end

local function adjacent(mat, num)
	local adj = List.from_list({
		{ num.i-1, num.j.from-1 },
		{ num.i  , num.j.from-1 },
		{ num.i+1, num.j.from-1 },
		{ num.i-1, num.j.to+1   },
		{ num.i  , num.j.to+1   },
		{ num.i+1, num.j.to+1   }
	})

	for j = num.j.from, num.j.to do
		table.insert(adj, { num.i-1, j })
		table.insert(adj, { num.i+1, j })
	end

	adj = adj:filter(function(coord) return is_symbol(mat:at(coord)) end)
	return { num = num, adj = adj }
end

local function find_nums(mat)
	local nums = List()
	for i = 1, #mat do
		local j = 1
		while j <= #(mat[i]) do
			if is_digit(mat[i][j]) then
				local k = j
				local num = { i = i, j = { from = j, to = j } }
				while is_digit(mat[i][k+1]) do
					num.j.to = num.j.to + 1
					k = k + 1
				end
				j = k + 1
				table.insert(nums, num)
			else
				j = j + 1
			end
		end
	end

	return nums
end

local function find_parts(mat)
	local function is_part(num)
		for j = num.j.from, num.j.to do
			if has_adjacent_symbol(mat, List.from_list({ num.i, j })) then
				return true
			end
		end
		return false
	end

	return find_nums(mat)
		:filter(is_part)
		:map(
			function(part)
				return tonumber(reduce(concat, slice(mat[part.i], part.j.from, part.j.to)))
			end
		)
end

local function find_gears(mat)
	local function to_number(num)
		return tonumber(reduce(concat, slice(mat[num.i], num.j.from, num.j.to)))
	end

	local num_adjs = find_nums(mat):map(function(num) return adjacent(mat, num) end)

	local gears = {}

	for i = 1, #num_adjs do
		local num = num_adjs[i].num

		for j = 1, #(num_adjs[i].adj) do
			local adj = num_adjs[i].adj[j]

			if not gears[adj[1]] then
				gears[adj[1]] = {}
			end

			if not gears[adj[1]][adj[2]] then
				gears[adj[1]][adj[2]] = {}
			end

			table.insert(gears[adj[1]][adj[2]], to_number(num))
		end
	end

	local res = List()

	for i, _ in pairs(gears) do
		for j, v in pairs(gears[i]) do
			table.insert(res, { coord = { i, j }, parts = v })
		end
	end

	return res
end

local function part1(f)
	return List
		.from_iter(io.lines(f))
		:map(split_chars)
		:apply(find_parts)
		:reduce(plus)
end

local function part2(f)
	return List
		.from_iter(io.lines(f))
		:map(split_chars)
		:apply(find_gears)
		:get("parts")
		:filter(function(parts) return #parts == 2 end)
		:map(function(parts) return parts[1] * parts[2] end)
		:reduce(plus)
end

test({
	{ func = part1, input = 'example',   output = 4361   },
	{ func = part1, input = 'test1', output = 13112  },
	{ func = part1, input = "input", output = 543867 },
	{ func = part2, input = "example"  , output = 467835 },
	{ func = part2, input = "input", output = 79613331 },
})
