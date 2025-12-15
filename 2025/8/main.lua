local aoc = require("aoc")

---@class node<T>: { value: T, neighbours: table<T, node<T>> }

---@class graph
---@field nodes table<string, node<string>>
local graph = {}
graph.__index = graph

function graph.make()
	return setmetatable({ nodes = {} }, graph)
end

---@return node<string>
function graph:make_node(x)
	local node = { value = x, neighbours = {} }
	self.nodes[x] = node
	return node
end

function graph:connect(x, y)
	local nx = self.nodes[x] or self:make_node(x) ---@type node<string>
	local ny = self.nodes[y] or self:make_node(y) ---@type node<string>

	ny.neighbours[x] = nx
	nx.neighbours[y] = ny
end

---@return any[][]
function graph:components()
	---@type table<string, boolean>
	local not_visited = {}
	for k, _ in pairs(self.nodes) do
		not_visited[k] = true
	end

	local q = {} ---@type string[]
	local components = {} ---@type string[][]
	local component = {} ---@type string[]

	while true do

		local a, _ = aoc.iter.first(aoc.map.iter(not_visited))
		if not a then
			return components
		end
		table.insert(q, a)

		while aoc.len(q) > 0 do
			local k = table.remove(q)
			if not_visited[k] == true then
				local node = self.nodes[k]

				not_visited[k] = nil
				table.insert(component, k)

				for kn, _ in pairs(node.neighbours) do
					if not_visited[kn] then
						table.insert(q, kn)
					end
				end
			end
		end

		table.insert(components, component)
		component = {}
	end
end

---@alias point [integer, integer, integer]

---@param str string
---@return point
local function parse_point (str)
	return aoc.split_with(str, ",", tonumber)
end

---@param p1 point
---@param p2 point
---@return integer
local function dist (p1, p2)
	local a = p2[1] - p1[1]
	local b = p2[2] - p1[2]
	local c = p2[3] - p1[3]
	return math.sqrt(a*a + b*b + c*c)
end

local function solve (count, filename)
	local box_strings = aoc.collect(io.lines(filename))

	---@type [string, string, integer][]
	local junctions = {}

	for i = 1, aoc.len(box_strings) do
		local s1 = box_strings[i]
		for j = i+1, aoc.len(box_strings) do
			local s2 = box_strings[j]
			if s1 ~= s2 then
				local p1 = parse_point(s1)
				local p2 = parse_point(s2)
				local d = dist(p1, p2)
				table.insert(junctions, { s1, s2, d })
			end
		end
	end

	aoc.sort(junctions, function (x, y) return x[3] < y[3] end)

	local s = 1
	do
		local g = graph.make()
		for i = 1, count do
			local a = junctions[i][1]
			local b = junctions[i][2]
			local d = junctions[i][3]
			g:connect(a, b)
		end
		local cs = g:components()
		table.sort(cs, function (x, y) return aoc.len(x) > aoc.len(y) end)
		for i = 1, 3 do
			local c = cs[i]
			s = s * aoc.len(c)
		end
	end

	local s2 = 1
	do
		local joined = {}
		local g = graph.make()
		g:connect(junctions[1][1], junctions[1][2])
		joined[junctions[1][1]] = true
		joined[junctions[1][2]] = true
		while true do
			if aoc.list.for_all(box_strings, function (boxd) return joined[boxd] == true end) then
				break
			end
			for i = 2, aoc.len(junctions) do
				local junc = junctions[i]
				local a = junc[1]
				local b = junc[2]
				if not (joined[a] and joined[b]) and (joined[a] or joined[b]) then
					g:connect(a, b)
					joined[a] = true
					joined[b] = true
					if aoc.list.for_all(box_strings, function (boxd) return joined[boxd] == true end) then
						s2 = parse_point(a)[1] * parse_point(b)[1]
						break
					end
					break
				end
			end
		end
	end

	return s, s2
end

aoc.verify(aoc.fix(solve, 10), "example", 40, 25272)
aoc.verify(aoc.fix(solve, 1000), "input", 112230, 2573952864)
