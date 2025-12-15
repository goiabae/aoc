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
	local nx = self.nodes[x] or self:make_node(x)
	local ny = self.nodes[y] or self:make_node(y)
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

---@class min_heap
---@field elements [string, string, number][]
---@field size integer
---@field cmp fun (x: [string, string, number], y: [string, string, number]): boolean
---@field count integer
local min_heap = {}
min_heap.__index = min_heap

---@param cmp? fun (x: point, y: point): boolean
---@return min_heap
function min_heap.make(count, cmp)
	return setmetatable({ elements = {}, size = 0, count = count, cmp = cmp or aoc.less_than }, min_heap)
end

function min_heap:push(x)
	local size = aoc.len(self.elements)

	if size < self.count then
		local i = size
		self.elements[i + 1] = x

		while i > 0 do
			local p = math.floor((i - 1) / 2)
			if not self.cmp(self.elements[p + 1], self.elements[i + 1]) then
				break
			end
			self.elements[p + 1], self.elements[i + 1] =
				self.elements[i + 1], self.elements[p + 1]
			i = p
		end

		return
	end

	if not self.cmp(self.elements[1], x) then
		self.elements[1] = x
		self:heapify_down(0)
	end
end

function min_heap:heapify_down(i)
	local size = aoc.len(self.elements)

	while true do
		local left  = 2*i + 1
		local right = 2*i + 2
		local smallest = i

		if left < size and not self.cmp(self.elements[left + 1],
                                    self.elements[smallest + 1]) then
			smallest = left
		end

		if right < size and not self.cmp(self.elements[right + 1],
                                     self.elements[smallest + 1]) then
			smallest = right
		end

		if smallest == i then
			break
		end

		self.elements[i + 1], self.elements[smallest + 1] =
			self.elements[smallest + 1], self.elements[i + 1]

		i = smallest
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

local function part1 (count, h)
	local s = 1
	local g = graph.make()
	for i = 1, count do
		local a = h.elements[i][1]
		local b = h.elements[i][2]
		g:connect(a, b)
	end
	local cs = g:components()
	table.sort(cs, function (x, y) return aoc.len(x) > aoc.len(y) end)
	for i = 1, 3 do
		local c = cs[i]
		s = s * aoc.len(c)
	end
	return s
end

local function map_is_empty (xm)
	for _, _ in pairs(xm) do
		return false
	end
	return true
end

local function part2 (junctions, box_strings)
	local g = graph.make()

	local unjoined = {}

	for _, b in pairs(box_strings) do
		unjoined[b] = true
	end

	do
		local a, b = junctions[1][1], junctions[1][2]
		g:connect(a, b)
		unjoined[a] = nil
		unjoined[b] = nil
	end

	while true do
		for _, j in ipairs(junctions) do
			local a, b = j[1], j[2]
			if not (unjoined[a] and unjoined[b]) and (unjoined[a] or unjoined[b]) then
				g:connect(a, b)
				unjoined[a] = nil
				unjoined[b] = nil
				if map_is_empty(unjoined) then
					return parse_point(a)[1] * parse_point(b)[1]
				end
				break
			end
		end
	end
end

local function solve (count, filename)
	local box_strings = aoc.collect(io.lines(filename))
	local junctions = {}
	local h = min_heap.make(count, function (x, y) return x[3] < y[3] end)

	for i = 1, aoc.len(box_strings) do
		local s1 = box_strings[i]
		for j = i+1, aoc.len(box_strings) do
			local s2 = box_strings[j]
			local p1 = parse_point(s1)
			local p2 = parse_point(s2)
			local d = dist(p1, p2)

			h:push({ s1, s2, d })

			table.insert(junctions, { s1, s2, d })
		end
	end

	table.sort(junctions, function (x, y) return x[3] < y[3] end)

	local s = part1(count, h)
	local s2 = part2(junctions, box_strings)

	return s, s2
end

aoc.verify(aoc.fix(solve, 10), "example", 40, 25272)
aoc.verify(aoc.fix(solve, 1000), "input", 112230, 2573952864)
