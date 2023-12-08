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
	local acc = {}
	for i = 1, #str do
		table.insert(acc, str:sub(i, i))
	end
	return acc
end

function plus(x, y)
	return x + y
end

function max(x, y)
	if x > y then return x else return y end
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
	for i = from, to do
		table.insert(acc, seq[i])
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
				assert(test.func(test.input) == test.output)
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
		each = swap(each)
	}
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
