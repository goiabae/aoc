function map_seq(f, xs)
	local acc = {}
	for i = 1, #xs do
		table.insert(acc, f(xs[i]))
	end
	return acc
end

function each(f, xs)
	for i = 1, #xs do
		f(xs[i])
	end
end

function map_it(f, it)
	local acc = List()
	while true do
		local v = it()
		if v then
			table.insert(acc, f(v))
		else
			break
		end
	end
	return acc
end

function reduce(f, xs)
	local acc = xs[1]
	for i = 2, #xs do
		acc = f(acc, xs[i])
	end
	return acc
end

function iter(it)
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

function filter_seq(pred, xs)
	local acc = List()
	for i = 1, #xs do
		if pred(xs[i]) then
			table.insert(acc, xs[i])
		end
	end
	return acc
end

function max(x, y)
	if x > y then return x else return y end
end

function id(x)
	return x
end

function split_chars(str)
	local acc = List()
	for i = 1, #str do
		table.insert(acc, str:sub(i, i))
	end
	return acc
end

function plus(x, y)
	return x + y
end

function sub(x, y)
	return x - y
end

function max(x, y)
	if x > y then return x else return y end
end

function min(x, y)
	if x < y then return x else return y end
end

function is_digit(char)
	return char == "0"
		or char == "1"
		or char == "2"
		or char == "3"
		or char == "4"
		or char == "5"
		or char == "6"
		or char == "7"
		or char == "8"
		or char == "9"
end

function slice(seq, from , to)
	local acc = List()
	if to > #seq then to = to % #seq end
	if to < from then
		for i = from, #seq do
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

function concat(x, y)
	return x .. y
end

function test(tests)
	each(
		function (test)
			local output = test.func(test.input)
			print("  " .. output)
			if test.output then
				assert(output == test.output)
			end
		end,
		tests
	)
end

function at(vec, is)
	local acc = vec
	for i = 1, #is do
		acc = acc[is[i]]
		if not acc then
			break
		end
	end
	return acc
end

function log_or(x, y)
	return x or y
end

function log_and(x, y)
	return x and y
end

function compose(f, g)
	return function(x) return g(f(x)) end
end

List = {
	__index = List,
	__add = function (this, that)
		local acc = List()
		for i = 1, #this do
			table.insert(acc, this[i] + that[i])
		end
		return acc
	end,

	-- constructors
	from_list = function(xs)
		local list = List()
		for i = 1, #xs do
			table.insert(list, xs[i])
		end
		return list
	end,
	from_table = function(tab)
		local table = List()
		for k, v in pairs(tab) do
			table[k] = v
		end
		return table
	end,
	from_iter = function(it)
		return map_it(id, it)
	end
}

function get(xs, col)
	local acc = List()
	for i = 1, #xs do
		table.insert(acc, xs[i][col])
	end
	return acc
end

function swap(f)
	return function(x, y)
		return f(y, x)
	end
end

function new(meta)
	local tab = {
		at = at,
		map = function(xs, f)
			local acc = List()
			for i = 1, #xs do
				table.insert(acc, f(xs[i]))
			end
			return acc
		end,
		filter = function(this, pred)
			return filter_seq(pred, this)
		end,
		reduce = function(this, func)
			return reduce(func, this)
		end,
		apply = function(this, func)
			return func(this)
		end,
		slice = slice,
		get = get,
		each = swap(each),
	}

	function tab:group(n)
		local acc = List()
		local i = 1
		while i <= #self do
			local group = {}
			for j = 0, n-1 do
				table.insert(group, self[i+j])
			end
			table.insert(acc, group)
			i = i + n
		end
		return acc
	end

	function tab:iter()
		local i = 1
		return function()
			if i > #self then return nil end
			i = i + 1
			return self[i-1]
		end
	end

	function tab:sort(comparator)
		table.sort(self, comparator)
		return self
	end

	function tab:foldi(initial, f)
		local acc = initial
		for i = 1, #self do
			acc = f(acc, self[i], i)
		end
		return acc
	end

	function tab:mapi(f)
		local acc = List()
		for i = 1, #self do
			table.insert(acc, f(self[i], i))
		end
		return acc
	end

	function tab:pairs()
		local acc = List()
		for i = 1, #self - 1 do
			for j = i+1, #self do
				table.insert(acc, { self[i], self[j] })
			end
		end
		return acc
	end

	setmetatable(tab, meta)
	return tab
end

setmetatable(List, { __call = new })

function find_char(c, str)
	for i = 1, #str do
		if str:sub(i, i) == c then
			return i
		end
	end
	return nil
end

function split_on_spaces(str)
	local acc = List()
	local i = 1
	while i < #str + 1 do
		if str:sub(i, i) ~= " " then
			local k = 0
			while (i+k+1) <= #str and str:sub(i+k+1, i+k+1) ~= " " do
				k = k + 1
			end
			table.insert(acc, str:sub(i, i+k))
			i = i + k
		end
		i = i + 1
	end
	return acc
end

function read_file(f)
	local fd = io.open(f, "r")
	if not fd then return "" end
	local txt = fd:read("*a")
	io.close(fd)
	return txt
end

function fix2(f, x)
	return function(y) return f(x, y) end
end

function fix3(f, x)
	return function(y, z) return f(x, y, z) end
end

function inverse(xs)
	local ys = {}
	for i = 1, #xs do
		ys[xs[i]] = i
	end
	return ys
end

function sleep(t)
  os.execute("sleep " .. t)
end

function call2(f)
	return function(args)
		return f(args[1], args[2])
	end
end


function print_seq(seq)
	print(seq:reduce(function(acc, it) return acc .. " " .. it end))
end

function slide_map(seq, n, f)
	local acc = List()
	for i = 1, #seq - n + 1 do
		table.insert(acc, f(slice(seq, i, i + n - 1)))
	end
	return acc
end

function ring_map(seq, n, f)
	local acc = List()
	for i = 1, #seq do
		table.insert(acc, f(slice(seq, i, i + n - 1)))
	end
	return acc
end

function cycle(seq)
	local acc = List.from_list(seq)
	local last = acc[#acc]
	table.remove(acc, #acc)
	table.insert(acc, 1, last)
	return acc
end

function filter_mask(seq, mask)
	assert(#seq == #mask)
	local acc = List()
	for i = 1, #seq do
		if mask[i] then
			table.insert(acc, seq[i])
		end
	end
	return acc
end

function vec2_eq(v, w) return v[1] == w[1] and v[2] == w[2] end

function zip_with(f, xs, ys)
	local zs = List()
	assert(#xs == #ys)
	for i = 1, #xs do
		table.insert(zs, f(xs[i], ys[i]))
	end
	return zs
end

function belongs_to(it, set, eq)
	for i = 1, #set do
		if eq(it, set[i]) then return true end
	end
	return false
end

function eq(x, y)
	return x == y
end
