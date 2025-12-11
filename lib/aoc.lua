---@class list
local list = {}

---@class iter
local iter = {}

---@class map
local map = {}

---@class matrix
local matrix = {}

---@class range_set
local range_set = {}

---@class aoc
---@field list list
---@field iter iter
---@field map map
---@field matrix matrix
---@field range_set range_set
local aoc = {
	list = list,
	iter = iter,
	map = map,
	matrix = matrix,
	range_set = range_set,
}

---@alias iterator<T...> fun (): T...?

function aoc.fdiv(x, y)
	return (x - (x % y)) / y
end

-- filter unique elements of seq
--@param seq any[]
--@param eq function
--@return any[]
function aoc.unique(seq, eq)
	local res = {}
	for j = 1, aoc.len(seq) do
		for i = 1, aoc.len(res) do
			if eq(seq[j], res[i]) then
				goto continue
			end
		end
		table.insert(res, seq[j])
		::continue::
	end
	return res
end

---@generic T
---@param seq T[]
---@param f fun (i: integer, x: T): integer
---@return integer
function list.sum(seq, f)
	local total = 0
	for i = 1, aoc.len(seq) do
		total = total + f(i, seq[i])
	end
	return total
end

---@generic T
---@param seq T[]
---@param pred fun (i: integer, x: T): boolean
---@return integer
function list.count(seq, pred)
	local total = 0
	for i = 1, aoc.len(seq) do
		if pred(i, seq[i]) then
			total = total + 1
		end
	end
	return total
end

-- keys are elements, values are the frequencies of each key in seq
-- if the key was not in seq, frequency is 0
---@generic T
---@param seq T[]
---@return table<T, integer>
function aoc.make_bag(seq)
	local bag = {}
	local meta = { __index = function() return 0 end }
	setmetatable(bag, meta)

	for elt in aoc.list.iter(seq) do
		if bag[elt] == nil then
			bag[elt] = 1
		else
			bag[elt] = bag[elt] + 1
		end
	end
	return bag
end

--@param seq any[]
--@param f function
--@return any[]
function aoc.filter_map(seq, f)
	local res = {}
	for elt in aoc.list.iter(seq) do
		local mapped = f(elt)
		if mapped ~= nil then
			table.insert(res, mapped)
		end
	end
	return res
end

---@generic T
---@param seq T[]
---@param pred fun (x: T): boolean
---@return boolean
function list.for_all(seq, pred)
	for elt in aoc.list.iter(seq) do
		if not pred(elt) then
			return false
		end
	end
	return true
end

---@generic T
---@param seq T[]
---@param pred fun (x: T): boolean
---@return boolean
function list.exists(seq, pred)
	for elt in aoc.list.iter(seq) do
		if pred(elt) then
			return true
		end
	end
	return false
end

--@param str string
--@return string[]
function aoc.split_empty(str)
	local tokens = {}
	local token = ""
	for i = 1, aoc.len(str) do
		if string.sub(str, i, i) == "\n" and string.sub(str, i+1, i+1) == "\n" then
			table.insert(tokens, token)
			token = ""
		else
			token = token .. string.sub(str, i, i)
		end
	end
	table.insert(tokens, token)
	return tokens
end

---@param str string
---@param row_sep string
---@param col_sep string
---@return integer[][]
function aoc.parse_number_mat(str, row_sep, col_sep)
	return aoc.list.map(aoc.split_with(str, row_sep), function (c) return aoc.list.map(aoc.split_with(c, col_sep), tonumber) end)
end

--@param str string
--@param row_sep string
--@param col_sep string
--@return integer[][]
function aoc.parse_char_mat(str)
	return aoc.list.map(aoc.split_with(str, "\n"), function (c) return aoc.split_chars(c) end)
end

---@param str string
---@param row_sep string
---@param col_sep string
---@return string[][]
function aoc.parse_string_mat(str, row_sep, col_sep)
	return aoc.list.map(aoc.split_with(str, row_sep), function (c) return aoc.split_with(c, col_sep) end)
end

--@param seq any[]
function aoc.middle(seq)
	assert(aoc.len(seq) % 2 == 1, "length " .. aoc.len(seq) .. " of sequence is not odd")
	return seq[(aoc.len(seq) + 1) / 2]
end

--@param seq integer[]
--@return integer
function aoc.sum(seq)
	local total = 0
	for num in aoc.list.iter(seq) do
		total = total + num
	end
	return total
end

-- collect an iterator into a list
---@generic T
---@param it iterator<T>
---@return T[]
function aoc.collect(it)
	local acc = {}
	while true do
		local v = it()
		if v then
			table.insert(acc, v)
		else
			break
		end
	end
	return acc
end

-- collect an iterator into a list
---@generic T, U
---@param it iterator<T, U>
---@return [T, U][]
function aoc.collect2(it)
	local acc = {}
	while true do
		local v1, v2 = it()
		if v1 and v2 then
			table.insert(acc, { v1, v2 })
		else
			break
		end
	end
	return acc
end

-- collect an iterator into a list
---@generic T, U, V
---@param it iterator<T, U, V>
---@return [T, U, V][]
function aoc.collect3(it)
	local acc = {}
	while true do
		local v1, v2, v3 = it()
		if v1 and v2 and v3 then
			table.insert(acc, { v1, v2, v3 })
		else
			break
		end
	end
	return acc
end

-- collect iterator values into a list of tuples
---@generic I...
---@param it iterator<I...>
---@return [I...][]
function iter.collect_many(it)
	local acc = {}
	while true do
		local t = { it() }
		if aoc.len(t) == 0 then
			break
		else
			table.insert(acc, t)
		end
	end
	return acc
end

---@generic T...
---@param ... T...
---@return T...
function aoc.id(...) return ... end

---@param str string
---@return string[]
function aoc.split_chars(str)
	local acc = {}
	for i = 1, aoc.len(str) do
		table.insert(acc, str:sub(i, i))
	end
	return acc
end

function aoc.add(x, y)
	return x + y
end

function aoc.mul(x, y)
	return x * y
end

function aoc.sub(x, y)
	return x - y
end

function aoc.max(x, y)
	if x > y then return x else return y end
end

function aoc.min(x, y)
	if x < y then return x else return y end
end

function aoc.is_digit(char)
	return string.match(char, "%d") ~= nil
end

function aoc.concat(x, y)
	return x .. y
end

function list.concat(xs, ys)
	local zs = {}
	for x in aoc.list.iter(xs) do
		table.insert(zs, x)
	end
	for y in aoc.list.iter(ys) do
		table.insert(zs, y)
	end
	return zs
end

-- given a table and a list on indexes returns the equivalent of tab[idxs[1]][idxs[2]]...[idxs[n]]
--@param tab table
--@param idxs table
function aoc.at(tab, idxs)
	local acc = tab
	for i = 1, aoc.len(idxs) do
		acc = acc[idxs[i]]
		if not acc then
			break
		end
	end
	return acc
end

function aoc.log_or(x, y)
	return x or y
end

function aoc.log_and(x, y)
	return x and y
end

-- B combinator
function aoc.compose(f, g)
	return function(x) return g(f(x)) end
end

function aoc.get(seq, col)
	local acc = {}
	for i = 1, aoc.len(seq) do
		table.insert(acc, seq[i][col])
	end
	return acc
end

function aoc.swap(f)
	return function(x, y)
		return f(y, x)
	end
end

function aoc.group(seq, n)
	local acc = {}
	local i = 1
	while i <= aoc.len(seq) do
		local group = {}
		for j = 0, n-1 do
			table.insert(group, seq[i+j])
		end
		table.insert(acc, group)
		i = i + n
	end
	return acc
end

function list.iter(seq)
	local i = 1
	return function()
		if i > aoc.len(seq) then return nil end
		i = i + 1
		return seq[i-1]
	end
end

---@generic K, V
---@param xm table<K, V>
---@return iterator<K, V>
function map.iter (xm)
	local f, t, k = pairs(xm)
	return function ()
		k = f(t, k)
		if k then
			return k, t[k]
		end
	end
end

---@generic K, V
---@param xm table<K, V>
---@param pred fun(k: K, v: V): boolean
---@return boolean
function map.exists (xm, pred)
	for k, v in pairs(xm) do
		if pred(k, v) then
			return true
		end
	end
	return false
end

function map.count (xm, pred)
	local s = 0
	for k, v in pairs(xm) do
		if pred(k, v) then
			s = s + 1
		end
	end
	return s
end

---@generic T
---@param mat T[][]
---@return iterator<integer, integer, T>
function matrix.iter(mat)
	return coroutine.wrap(function ()
		for i = 1, aoc.len(mat) do
			for j = 1, aoc.len(mat[i]) do
				coroutine.yield(i, j, mat[i][j])
			end
		end
	end)
end

---@param p [integer, integer]
function matrix.at (mat, p)
	return (mat and mat[p[1]] and mat[p[1]][p[2]]) or nil
end

local function is_custom_iterable(v)
	if type(v) ~= "table" then return false end
	local mt = getmetatable(v)
	return mt and mt.__index and mt.__len
end

---@generic T
---@param seq T[]
---@param cmp fun (x: T, y: T): boolean
---@return T[]
function aoc.sort(seq, cmp)
	cmp = cmp or aoc.less_than
	if is_custom_iterable(seq) then
		aoc.quick_sort(seq, cmp, 1, aoc.len(seq))
	else
		table.sort(seq, cmp)
	end
	return seq
end

function aoc.quick_sort(seq, cmp, init, final)
	local i, j, pivot
	i = init
	j = final
	local k = math.floor((init + final) / 2)
	pivot = seq[k]
	while i <= j do
		while seq[i] < pivot do
			i = i + 1
		end
		while seq[j] > pivot do
			j = j - 1
		end
		if i <= j then
			local aux = seq[i]
			seq[i] = seq[j]
			seq[j] = aux
			i = i + 1
			j = j - 1
		end
	end
	if init < j then
		aoc.quick_sort(seq, cmp, init, j)
	end
	if init < final then
		aoc.quick_sort(seq, cmp, i, final)
	end
end

function aoc.foldi(seq, initial, f)
	local acc = initial
	for i = 1, aoc.len(seq) do
		acc = f(acc, seq[i], i)
	end
	return acc
end

--@param seq any[]
--@param f function(any, integer)
function aoc.mapi(seq, f)
	local acc = {}
	for i = 1, aoc.len(seq) do
		table.insert(acc, f(seq[i], i))
	end
	return acc
end

function list.pairs(seq)
	local acc = {}
	for i = 1, aoc.len(seq) - 1 do
		for j = i+1, aoc.len(seq) do
			table.insert(acc, { seq[i], seq[j] })
		end
	end
	return acc
end

function aoc.find_char(c, str)
	for i = 1, aoc.len(str) do
		if str:sub(i, i) == c then
			return i
		end
	end
	return nil
end

---@generic T
---@param seq T[]
---@param elt T
---@return integer?
function list.find(seq, elt)
	for i = 1, aoc.len(seq) do
		if seq[i] == elt then
			return i
		end
	end
	return nil
end

---@param str string
---@return string[]
function aoc.split_on_spaces(str)
	return aoc.split_with(str, " ")
end

---@generic T
---@param str string
---@param sep string
---@param f? fun (x: string): T
---@return T
function aoc.split_with(str, sep, f)
	local tokens = {}
	for token in string.gmatch(str, "[^" .. sep .. "]+") do
		table.insert(tokens, f and f(token) or token)
	end
	return tokens
end

---@param f string
---@return string
function aoc.read_file(f)
	local fd = io.open(f, "r")
	if not fd then return "" end
	local txt = fd:read("*a")
	io.close(fd)
	return txt
end

---@generic T, U
---@param f fun (x: T, ...): U
---@param x T
---@return fun (...): U
function aoc.fix(f, x)
	return function(...)
		return f(x, ...)
	end
end

function aoc.inverse(seq)
	local ys = {}
	for i = 1, aoc.len(seq) do
		ys[seq[i]] = i
	end
	return ys
end

function aoc.sleep(t)
  os.execute("sleep " .. t)
end

function aoc.call2(f)
	return function(args)
		return f(args[1], args[2])
	end
end

---@generic T
---@param seq T[]
---@param printer? fun (x: T): string
function aoc.print_seq(seq, printer)
	if printer then
		print(aoc.list.reduce(aoc.list.map(seq, printer), function(acc, it)
			return acc .. " " .. it
		end))
	else
		print(aoc.list.reduce(seq, function(acc, it)
			return acc .. " " .. it
		end))
	end
end

-- apply f to each window of seq of length n and collect the results
--@param f function
function aoc.slide_map(seq, n, f)
	local acc = {}
	for i = 1, aoc.len(seq) - n + 1 do
		table.insert(acc, f(list.slice(seq, i, i + n - 1)))
	end
	return acc
end

function aoc.ring_map(seq, n, f)
	local acc = {}
	for i = 1, aoc.len(seq) do
		table.insert(acc, f(list.slice(seq, i, i + n - 1)))
	end
	return acc
end

---@generic T
---@param seq T[]
---@return T?
function list.last(seq)
	return seq[aoc.len(seq)]
end

-- filter sequence using a boolean mask
function aoc.filter_mask(seq, mask)
	assert(aoc.len(seq) == aoc.len(mask))
	local acc = {}
	for i = 1, aoc.len(seq) do
		if mask[i] then
			table.insert(acc, seq[i])
		end
	end
	return acc
end

function aoc.vec2_eq(v, w) return v[1] == w[1] and v[2] == w[2] end

---@generic X, Y, Z
---@param f fun (x: X, y: Y): Z
---@param xs X[]
---@param ys Y[]
---@return Z[]
function aoc.list.zip_with(f, xs, ys)
	local zs = {}
	assert(aoc.len(xs) == aoc.len(ys))
	for i = 1, aoc.len(xs) do
		table.insert(zs, f(xs[i], ys[i]))
	end
	return zs
end

-- whether it is contained in set
---@generic T
---@param elt T
---@param set T[]
---@param eq fun (x: T, y: T): boolean
---@return boolean
function list.belongs_to(elt, set, eq)
	for i = 1, aoc.len(set) do
		if eq(elt, set[i]) then return true end
	end
	return false
end

function aoc.eq(x, y)
	return x == y
end

function aoc.neq(x, y)
	return x ~= y
end

---@generic T
---@param seq T[]
---@param from integer
---@param to integer
---@return T[]
function list.slice(seq, from , to)
	local acc = {}
	if to > aoc.len(seq) then to = to % aoc.len(seq) end
	if to < from then
		for i = from, aoc.len(seq) do
			table.insert(acc, seq[i])
		end
		for i = 1, to do
			table.insert(acc, seq[i])
		end
	else
		for i = from, to do
			table.insert(acc, seq[i])
		end
	end
	return acc
end

---@generic T
---@param seq T[]
---@param f fun (x: T): nil
function list.each(seq, f)
	for i = 1, aoc.len(seq) do
		f(seq[i])
	end
end

---@generic T
---@param seq T[]
---@param f fun (acc: T, x: T): T
---@return T
function list.reduce(seq, f)
	local acc = seq[1]
	for i = 2, aoc.len(seq) do
		acc = f(acc, seq[i])
	end
	return acc
end

---@generic T, U
---@param seq T[]
---@param f fun (acc: U, x: T): U
---@return U[]
function list.reductions(seq, f)
	local acc = { seq[1] }
	for i = 2, aoc.len(seq) do
		table.insert(acc, f(aoc.list.last(acc), seq[i]))
	end
	return acc
end

---@generic T, U
---@param seq T[]
---@param f fun (x: T): U
---@return U[]
function list.map(seq, f)
	local acc = {}
	for i = 1, aoc.len(seq) do
		table.insert(acc, f(seq[i]))
	end
	return acc
end

---@generic T
---@param seq T[]
---@param pred fun (x: T): boolean
---@return T[]
function list.filter(seq, pred)
	local acc = {}
	for i = 1, aoc.len(seq) do
		if pred(seq[i]) then
			table.insert(acc, seq[i])
		end
	end
	return acc
end

function aoc.is_even(n)
	return n % 2 == 0
end

-- returns two strings, each representing one half of str. if str's length is odd, it fails
---@param str string
---@return string, string
function aoc.cut_half(str)
	assert(aoc.is_even(aoc.len(str)))
	return string.sub(str, 1, aoc.len(str) / 2), string.sub(str, aoc.len(str) / 2 + 1, aoc.len(str))
end

---@generic T
---@param xs T[]
---@param elt T
---@return T[][]
function aoc.cut_right_on(xs, elt)
	local rss = {}
	for i = 1, aoc.len(xs) do
		if i < aoc.len(xs) and xs[i] == elt then
			local rs = list.slice(xs, i+1, aoc.len(xs))
			if aoc.len(rs) > 0 then
				table.insert(rss, rs)
			end
		end
	end
	return rss
end

---@generic T
---@param xs T[]
---@return T?
function aoc.max_of(xs)
	if aoc.len(xs) == 0 then
		return nil
	end
	local max = xs[1]
	for i = 2, aoc.len(xs) do
		if xs[i] > max then
			max = xs[i]
		end
	end
	return max
end

---@param cs string[]
---@return string
function aoc.join(cs)
	local s = ""
	for i = 1, aoc.len(cs) do
		s = s .. cs[i]
	end
	return s
end

---@param cs string[]
---@return integer
function aoc.int_of_char_list(cs)
	local n = 0
	for i = 1, aoc.len(cs) do
		n = n*10 + cs[i]
	end
	return n
end

function aoc.assert_eq(actual, value)
	if actual ~= value then
		print(actual)
	end
	assert(actual == value)
end

---@param str string
---@return integer[]
function aoc.digits(str)
	local ds = {}
	for i = 1, aoc.len(str) do
		table.insert(ds, tonumber(string.sub(str, i, i)))
	end
	return ds
end

---@generic T..., U...
---@param it iterator<T...>
---@param f fun (T...): U...
---@return iterator<U...>
function iter.map(it, f)
	return function ()
		return (function (a, ...)
			if a == nil then
				return nil
			end
			return f(a, ...)
		end)(it())
	end
end

---@param it iterator<integer>
---@return integer
function iter.sum(it)
	local acc = 0
	for v in it do
		acc = acc + v
	end
	return acc
end

---@param it iterator<integer, integer>
---@return integer, integer
function iter.sum2(it)
	local s, s2 = 0, 0
	for v1, v2 in it do
		s, s2 = s + v1, s2 + v2
	end
	return s, s2
end

---@generic T
---@param it iterator<T>
---@return T?
function iter.last (it)
	local v = nil
	while true do
		local w = it()
		if w == nil then
			return v
		end
		v = w
	end
end

---@generic T, U
---@param it iterator<T, U>
---@param f fun (t: T, u: U): boolean, boolean
---@return integer, integer
function iter.count2(it, f)
	local s1, s2 = 0, 0
	for v1, v2 in it do
		local b1, b2 = f(v1, v2)
		if b1 then
			s1 = s1 + 1
		end
		if b2 then
			s2 = s2 + 1
		end
	end
	return s1, s2
end

---@return iterator<integer>
function iter.iota()
	local i = 1
	return function ()
		i = i + 1
		return i-1
	end
end

---@generic T...
---@param it iterator<T...>
---@param n integer
---@return iterator<T...>
function iter.take(it, n)
	local c = 1
	return function ()
		if c > n then
			return nil
		else
			c = c + 1
			return it()
		end
	end
end

---@generic T
---@param mat T[][]
---@param i integer
---@param j integer
---@param elt T
---@return integer
function matrix.count_adjacent(mat, i, j, elt)
	local function f (x, y)
		return (mat[x] and mat[x][y] or nil) == elt and 1 or 0
	end

	return f(i-1, j-1) + f(i-1, j) + f(i-1, j+1)
		+ f(i, j-1) + 0 + f(i, j+1)
		+ f(i+1, j-1) + f(i+1, j) + f(i+1, j+1)
end

---@generic T
---@param mat T[][]
---@param i integer
---@param j integer
---@param pred fun (x: T): boolean
---@return boolean
function matrix.for_all_adjacent(mat, i, j, pred)
	local function f (x, y)
		return (mat[x] and mat[x][y] and pred(mat[x][y])) or false
	end

	return f(i-1, j-1) and f(i-1, j) and f(i-1, j+1)
		and f(i, j-1) and true and f(i, j+1)
		and f(i+1, j-1) and f(i+1, j) and f(i+1, j+1)
end

---@generic T
---@param mat T[][]
---@param i integer
---@param j integer
---@param pred fun (x: T): boolean
---@return boolean
function matrix.exists_adjacent(mat, i, j, pred)
	local function f (x, y)
		return (mat[x] and mat[x][y] and pred(mat[x][y])) or false
	end

	return f(i-1, j-1) or f(i-1, j) or f(i-1, j+1)
		or f(i, j-1) or false or f(i, j+1)
		or f(i+1, j-1) or f(i+1, j) or f(i+1, j+1)
end

function iter.filter3(it, pred)
	local function f ()
		local v1, v2, v3 = it()
		if v1 and v2 and v3 then
			if pred(v1, v2, v3) then
				return v1, v2, v3
			else
				return f()
			end
		end
	end
	return f
end

---@generic I...
---@param it iterator<I...>
---@param pred fun(I...): boolean
---@return iterator<I...>
function iter.filter(it, pred)
	return function()
		local function cont(a, ...)
			if a == nil then
				return nil
			end
			if pred(a, ...) then
				return a, ...
			else
				return cont(it())
			end
		end
		return cont(it())
	end
end

---@generic T, U
---@param it iterator<T, U>
---@param pred fun (t: T, u: U): boolean
---@return T, U
function iter.find2(it, pred)
	for v1, v2 in it do
		if pred(v1, v2) then
			return v1, v2
		end
	end
	return nil, nil
end

---@generic T, U
---@param it iterator<T>
---@param f fun (t: T): U?
---@return iterator<U>
function iter.filter_map(it, f)
	local function recur ()
		local v = it()
		if v then
			local u = f(v)
			if u then
				return u
			else
				return recur()
			end
		end
	end
	return recur
end

function aoc.equals3(v)
	return function (_, _, x) return x == v end
end

function iter.count(it)
	local s = 0
	for _ in it do
		s = s + 1
	end
	return s
end

---@generic T
---@param it iterator<T>
---@param pred fun (x: T): boolean
---@return boolean
function iter.for_all(it, pred)
	for elt in it do
		if not pred(elt) then
			return false
		end
	end
	return true
end

---@generic T
---@param it iterator<T>
---@param pred fun (x: T): boolean
---@return boolean
function iter.exists(it, pred)
	for elt in it do
		if pred(elt) then
			return true
		end
	end
	return false
end

function aoc.distance(p)
	return math.abs(p[1] - p[2])
end

function aoc.snd(f)
	return function (_, v)
		return f(v)
	end
end

function aoc.less_than(a, b) return a < b end

---@generic T
---@param mat T[][]
---@return T[][]
function matrix.transpose_view(mat)
	-- The outer proxy (columns)
	return setmetatable({}, {
			__len = function (_)
				return aoc.len(mat) > 0 and (aoc.len(mat[1])) or 0
			end,
			__index = function(_, col)
				-- For each "column", return a row-proxy
				return setmetatable({}, {
						__len = function (_)
							return aoc.len(mat)
						end,
						__index = function(_, row)
							return mat[row][col]
						end,

						__newindex = function(_, row, value)
							mat[row][col] = value
						end
				})
			end
	})
end

---@param x any
function aoc.len (x)
	local mt = getmetatable(x)
	if mt and mt.__len then
		return mt.__len(x)
	else
		return #x
	end
end

function aoc.cmp(a, b)
	if a < b then return -1 elseif a > b then return 1 else return 0 end
end

function range_set.make()
	return nil
end

-- returns the total amount of elements in the set
---@param set table?
---@return integer
function range_set.count_elts(set)
	if set == nil then
		return 0
	else
		return range_set.count_elts(set.left) + (set.high - set.low + 1) + range_set.count_elts(set.right)
	end
end

---@param set table?
---@return integer
function range_set.count_nodes(set)
	if set == nil then
		return 0
	else
		return 1 + range_set.count_elts(set.left) + range_set.count_elts(set.right)
	end
end

---@param set table?
---@param r [integer, integer]
---@return table
function range_set.insert(set, r)
	if set == nil then
		return {
			low = r[1],
			high = r[2],
			left = nil,
			right = nil,
		}
	end

	local bb = aoc.cmp(r[1], set.low)
	local ee = aoc.cmp(r[2], set.high)
	local eb = aoc.cmp(r[2], set.low)
	local be = aoc.cmp(r[1], set.high)

	-- Range bigger than set
	if be > 0 or (ee == 1 and bb >= 0) then
		local nr = { math.max(set.high+1, r[1]), r[2] }
		set.right = range_set.insert(set.right, nr)

	-- Range smaller than set
	elseif eb < 0 or (bb == -1 and ee <= 0) then
		local nr = { r[1], math.min(set.low-1, r[2]) }
		set.left = range_set.insert(set.left, nr)

	-- Parts smaller and bigger than set
	elseif bb == -1 and ee == 1 then
		local nr1 = { r[1], set.low-1 }
		local nr2 = { set.high+1, r[2] }
		set.left = range_set.insert(set.left, nr1)
		set.right = range_set.insert(set.right, nr2)

		-- Range fully contained in set
	elseif (bb >= 0 and ee <= 0) then
		do end
	end

	return set
end

-- Returns a, possibly new, root node, and minimum node
function range_set.min_node(set, should_remove)
	if set == nil then return nil, nil end

	if set.left == nil then
		if should_remove then
			local right = set.right
			set.right = nil
			return right, set
		else
			return set, set
		end
	else
		local left, m = aoc.range_set.min_node(set.left, should_remove)
		set.left = left
		return set, m
	end
end

function range_set.min(set)
	local _, node = range_set.min_node(set, false)
	return node and node.low
end

-- Returns a, possibly new, root node, and maximum node
function range_set.max_node(set, should_remove)
	if set == nil then return nil, nil end

	if set.right == nil then
		if should_remove then
			local left = set.left
			set.left = nil
			return left, set
		else
			return set, set
		end
	else
		local right, m = range_set.max_node(set.right, should_remove)
		set.right = right
		return set, m
	end
end

function range_set.max(set)
	local _, node = range_set.max_node(set, false)
	return node and node.high
end

---@param set table?
---@param transformed [integer, integer][]
---@param transforms [integer, integer, integer][]
---@return table?
local function aux (set, transformed, transforms)
	if set == nil then return set end

	local function replace_current_node ()
		if set.left == nil and set.right == nil then
			return nil
		elseif set.left == nil then
			local nright, node = range_set.min_node(set.right, true)
			node.right = nright
			node.left = set.left
			return node
		else
			local nleft, node = range_set.max_node(set.left, true)
			node.left = nleft
			node.right = set.right
			return node
		end
	end

	for k, t in pairs(transforms) do
		local dst = t[1]
		local src = t[2]
		local len = t[3]
		local d = dst-src

		local r = { src, src+len-1 }

		local bb = aoc.cmp(r[1], set.low)
		local ee = aoc.cmp(r[2], set.high)
		local eb = aoc.cmp(r[2], set.low)
		local be = aoc.cmp(r[1], set.high)


		-- [........]
		--     [----]
		-- [..][****]
		-- ^ r1  ^ tr
		if
			(bb == 1 and ee == 0 and be == -1 and eb == 1)
			or (be == 0 and ee == 0 and bb == 1 and eb == 1)
		then
			local r1 = { set.low, r[1]-1 }
			local tr = { r[1]+d, r[2]+d }
			set.low = r1[1]
			set.high = r1[2]
			table.insert(transformed, tr)
			table.remove(transforms, k)
			return aux(set, transformed, transforms)

		-- [........]
		--   [----]
		-- [][****][]
		-- ^   ^   ^
		-- r1  tr  r2
		elseif bb == 1 and ee == -1 and be == -1 and eb == 1 then
			local r1 = { set.low, r[1]-1 }
			local tr = { r[1]+d, r[2]+d }
			local r2 = { r[2]+1, set.high }
			set.low = r1[1]
			set.high = r1[2]
			table.insert(transformed, r2)
			table.insert(transformed, tr)
			table.remove(transforms, k)
			return aux(set, transformed, transforms)

		--       [.........]
		-- [---------]
		-- [----][***][....]
		-- ^      ^    ^
		-- t1     rt   r1
		elseif
			(bb == -1 and ee == -1 and be == -1 and eb == 1)
			or (bb == -1 and ee == -1 and be == -1 and eb == 0)
		then
			local t1 = { r[1]+d, r[1], (set.low-1)-r[1]+1 }
			local rt = { set.low+d, r[2]+d }
			local r1 = { r[2]+1, set.high }
			set.low = r1[1]
			set.high = r1[2]
			table.remove(transforms, k)
			table.insert(transforms, t1)
			table.insert(transformed, rt)
			return aux(set, transformed, transforms)

		-- [..........]
		-- [------]
		-- [******][..]
		-- ^        ^
		-- tr       r1
		elseif
			(bb == 0 and ee == -1 and be == -1 and eb == 1)
			or (bb == 0 and eb == 0 and be == -1 and ee == -1)
		then
			local r1 = { r[2]+1, set.high }
			local tr = { r[1]+d, r[2]+d }
			set.low = r1[1]
			set.high = r1[2]
			table.insert(transformed, tr)
			table.remove(transforms, k)
			return aux(set, transformed, transforms)

		-- [...........]
		--      [----------]
		-- [...][******][--]
		--  ^     ^      ^
		--  r1    rt     t1
		elseif
			(bb == 1 and ee == 1 and be == -1 and eb == 1)
			or (bb == 1 and ee == 1 and be == 0 and eb == 1)
		then
			local r1 = { set.low, r[1]-1 }
			local tr = { r[1]+d, set.high+d }
			local t1 = { set.high+1+d, set.high+1, r[2]-(set.high+1)+1 }
			set.low = r1[1]
			set.high = r1[2]
			transforms[k] = t1
			table.insert(transformed, tr)
			return aux(set, transformed, transforms)

		--     [..............]
		-- [----------------------]
		-- [--][**************][--]
		-- ^    ^               ^
		-- t1   tr              t2
		elseif bb == -1 and ee == 1 and be == -1 and eb == 1 then
			local t1 = { r[1]+d, r[1], (set.low-1)-r[1]+1 }
			local tr = { set.low+d, set.high+d }
			local t2 = { set.high+1+d, set.high+1, r[2]-(set.high+1)+1 }
			transforms[k] = t1
			table.insert(transformed, tr)
			table.insert(transforms, t2)
			set = replace_current_node()
			return aux(set, transformed, transforms)

		--         [........]
		-- [----------------]
		-- [------][********]
		--  ^ t1     ^ tr
		elseif
			(bb == -1 and ee == 0 and be == -1 and eb == 1)
			or (bb == -1 and ee == 0 and be == -1 and eb == 0)
		then
			local n1 = (set.low-1)-r[1]+1
			local t1 = { r[1]+d, r[1], n1 }
			local tr = { set.low+d, set.high+d }
			transforms[k] = t1
			table.insert(transformed, tr)
			set = replace_current_node()
			return aux(set, transformed, transforms)

		-- [.........]
		-- [--------------]
		-- [*********][---]
		-- ^ tr        ^ t1
		elseif
			(bb == 0 and ee == 1 and be == -1 and eb == 1)
			or (bb == 0 and ee == 1 and be == 0 and eb == 1)
		then
			local tr = { set.low+d, set.high+d }
			local t1 = { set.high+1+d, set.high+1, r[2]-(set.high+1)+1 }
			transforms[k] = t1
			table.insert(transformed, tr)
			set = replace_current_node()
			return aux(set, transformed, transforms)

		-- [........]
		-- [--------]
		-- [********] < tr
		elseif
			(bb == 0 and ee == 0 and be == -1 and eb == 1)
			or (bb == 0 and ee == 0 and be == 0 and eb == 0)
		then
			local tr = { set.low+d, set.high+d }
			table.insert(transformed, tr)
			table.remove(transforms, k)
			set = replace_current_node()
			return aux(set, transformed, transforms)

		-- [.........] [----------]
		elseif
			(bb == 1 and ee == 1 and be == 1 and eb == 1)
			or (bb == -1 and ee == -1 and be == -1 and eb == -1)
		then do end

		else
			print(bb, ee, be, eb)
			assert(false)
		end
	end

	set.left = aux(set.left, transformed, transforms)
	set.right = aux(set.right, transformed, transforms)
	return set
end

---@param set table?
---@param transforms [integer, integer, integer][]
function range_set.slide_transform(set, transforms)
	local transformed = {}
	set = aux(set, transformed, aoc.list.map(transforms, aoc.id))
	for r in aoc.list.iter(transformed) do
		set = range_set.insert(set, r)
	end
	return set
end

function range_set.contains(set, n)
	if set == nil then return false end
	if n >= set.low and n <= set.high then
		return true
	end
	if n < set.low then
		return range_set.contains(set.left, n)
	end
	if n > set.high then
		return range_set.contains(set.right, n)
	end
	return false
end

function range_set.from_range_list(rs)
	local set = aoc.range_set.make()
	for r in aoc.list.iter(rs) do
		set = aoc.range_set.insert(set, r)
	end
	return set
end

function range_set.iter (set)
	return coroutine.wrap(function ()
		if set == nil then return end
		local q = {}
		local cur = set
		while cur or #q > 0 do
			while cur do
				table.insert(q, cur)
				cur = cur.left
			end

			cur = table.remove(q)
			coroutine.yield(cur.low, cur.high)

			cur = cur.right
		end
	end)
end

---@alias solver fun (filename: string): integer, integer

---@param solver solver
---@param filename string
---@param e1 integer
---@param e2 integer
function aoc.verify(solver, filename, e1, e2)
	local p1, p2 = solver(filename)
	if e1 and p1 ~= e1 then
		print("Wrong part1 solution.")
		if p1 then
			print(string.format("Expected %d, but got %d", e1, p1))
		else
			print(string.format("Expected %d, but got nil", e1))
		end
		os.exit(1)
	end
	if e2 and p2 ~= e2 then
		print("Wrong part2 solution.")
		if p2 then
			print(string.format("Expected %d, but got %d", e2, p2))
		else
			print(string.format("Expected %d, but got nil", e2))
		end
		os.exit(1)
	end
end

function aoc.pad_left(s, l, _)
	return string.format("%" .. tostring(l) .. "s", s)
end

function aoc.pad_right(s, l, _)
	if l < 100 then
		local fmt = "%-" .. tostring(l) .. "s"
		return string.format(fmt, s)
	else
		while aoc.len(s) < l do
			s = s .. " "
		end
		return s
	end
end

-- Parses a matrix of the sort:
--
--   123|45 | 67
--   89 | 10|  11
--
-- with column separator characters.
--
---@param filename string
---@param is_sep fun (c: string): boolean
---@return string[][]
function aoc.parse_separated_matrix (filename, is_sep)
	local lines = aoc.collect(io.lines(filename))
	local l = aoc.foldi(lines, 0, function (acc, x, _) return math.max(acc, aoc.len(x)) end)
	local padded_lines = aoc.list.map(lines, function (x) return aoc.pad_right(x, l) end)
	local rows = aoc.list.map(padded_lines, function () return {} end)
	local beg = 1

	local function all_spaces (c)
		return list.for_all(padded_lines, function (line) return is_sep(string.sub(line, c, c)) end)
	end

	local function f (s)
		for r = 1, aoc.len(padded_lines) do
			table.insert(rows[r], string.sub(padded_lines[r], beg, math.min(s-1, l)))
		end
		beg = s+1
	end

	for i = 2, l do
		if all_spaces(i) then f(i) end
	end
	f(l+1)

	return rows
end

-- if elt is a table, elements of the resulting list all alias to the same thing
---@generic T
---@param size integer
---@param elt T
---@return T
function list.init (size, elt)
	local xs = {}
	for i = 1, size do
		xs[i] = elt
	end
	return xs
end

function aoc.b2i (x) return x and 1 or 0 end

-- Splits `str` on substring `sep`.
---@param str string
---@param sep string
---@return iterator<string>
function aoc.split_sub (str, sep)
	return coroutine.wrap(function ()
		local pattern = "(.-)" .. sep
		local last_end = 1
		local s, e, cap = str:find(pattern, 1)
		while s do
			coroutine.yield(cap)
			last_end = e + 1
			s, e, cap = str:find(pattern, last_end)
		end
		coroutine.yield(str:sub(last_end))
	end)
end

function aoc.splat_into(f)
	return function (x)
		return f(unpack(x))
	end
end

---@return aoc
return aoc
