local aoc = {}

-- equivalent of sum(mapi(seq, f))
-- does not accumulate an intermediary list
function aoc.sumi(seq, f)
	local total = 0
	for i = 1, #seq do
		total = total + f(seq[i], i)
	end
	return total
end

-- keys are elements, values are the frequencies of each key in seq
-- if the key was not in seq, frequency is 0
function aoc.make_bag(seq)
	local bag = {}
	local meta = { __index = function() return 0 end }
	setmetatable(bag, meta)

	for elt in aoc.iter(seq) do
		if bag[elt] == nil then
			bag[elt] = 1
		else
			bag[elt] = bag[elt] + 1
		end
	end
	return bag
end

function aoc.transpose(rows)
	local res = {}
	for i = 1, #(rows[1]) do
		table.insert(res, {})
		for j = 1, #rows do
			table.insert(res[i], rows[j][i])
		end
	end
	return res
end


--@param seq any[]
--@param f function
--@return any[]
function aoc.filter_map(seq, f)
	local res = {}
	for elt in aoc.iter(seq) do
		local mapped = f(elt)
		if mapped ~= nil then
			table.insert(res, mapped)
		end
	end
	return res
end

--@param seq any[]
--@param pred function
--@return boolean
function aoc.for_all(seq, pred)
	for elt in aoc.iter(seq) do
		if not pred(elt) then
			return false
		end
	end
	return true
end

--@param seq any[]
--@param pred function
--@return boolean
function aoc.exists(seq, pred)
	for elt in aoc.iter(seq) do
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
	for i = 1, #str do
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

--@param str string
--@param row_sep string
--@param col_sep string
--@return integer[][]
function aoc.parse_number_mat(str, row_sep, col_sep)
	return aoc.map(aoc.split_with(str, row_sep), function (c) return aoc.map(aoc.split_with(c, col_sep), tonumber) end)
end

--@param seq any[]
function aoc.middle(seq)
	assert((#seq) % 2 == 1, "length " .. #seq .. " of sequence is not odd")
	return seq[(#seq + 1) / 2]
end

--@param seq integer[]
--@return integer
function aoc.sum(seq)
	local total = 0
	for num in aoc.iter(seq) do
		total = total + num
	end
	return total
end

-- collect an iterator into a list
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

function aoc.id(x)
	return x
end

function aoc.split_chars(str)
	local acc = {}
	for i = 1, #str do
		table.insert(acc, str:sub(i, i))
	end
	return acc
end

function aoc.add(x, y)
	return x + y
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
	local code = string.byte(char)
	return string.byte('0') <= code and code <= string.byte('9')
end

function aoc.concat(x, y)
	return x .. y
end

function aoc.test(tests)
	aoc.each(
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

-- given a table and a list on indexes returns the equivalent of tab[idxs[1]][idxs[2]]...[idxs[n]]
--@param tab table
--@param idxs table
function aoc.at(tab, idxs)
	local acc = tab
	for i = 1, #idxs do
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

function aoc.from_list(seq)
	local list = {}
	for i = 1, #seq do
		table.insert(list, seq[i])
	end
	return list
end

function aoc.get(seq, col)
	local acc = {}
	for i = 1, #seq do
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
	while i <= #seq do
		local group = {}
		for j = 0, n-1 do
			table.insert(group, seq[i+j])
		end
		table.insert(acc, group)
		i = i + n
	end
	return acc
end

function aoc.iter(seq)
	local i = 1
	return function()
		if i > #seq then return nil end
		i = i + 1
		return seq[i-1]
	end
end

function aoc.sort(seq, comparator)
	table.sort(seq, comparator)
	return seq
end

function aoc.foldi(seq, initial, f)
	local acc = initial
	for i = 1, #seq do
		acc = f(acc, seq[i], i)
	end
	return acc
end

--@param seq any[]
--@param f function(any, integer)
function aoc.mapi(seq, f)
	local acc = {}
	for i = 1, #seq do
		table.insert(acc, f(seq[i], i))
	end
	return acc
end

function aoc.pairs(seq)
	local acc = {}
	for i = 1, #seq - 1 do
		for j = i+1, #seq do
			table.insert(acc, { seq[i], seq[j] })
		end
	end
	return acc
end

function aoc.find_char(c, str)
	for i = 1, #str do
		if str:sub(i, i) == c then
			return i
		end
	end
	return nil
end

function aoc.split_on_spaces(str)
	local acc = {}
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

--@param str string
--@param sep string
function aoc.split_with(str, sep)
	local tokens = {}
	for token in string.gmatch(str, "[^" .. sep .. "]+") do
		table.insert(tokens, token)
	end
	return tokens
end

function aoc.read_file(f)
	local fd = io.open(f, "r")
	if not fd then return "" end
	local txt = fd:read("*a")
	io.close(fd)
	return txt
end

function aoc.fix(f, x)
	return function(...)
		return f(x, ...)
	end
end

function aoc.inverse(seq)
	local ys = {}
	for i = 1, #seq do
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

function aoc.print_seq(seq)
	print(aoc.reduce(seq, function(acc, it) return acc .. " " .. it end))
end

-- apply f to each window of seq of length n and collect the results
--@param f function
function aoc.slide_map(seq, n, f)
	local acc = {}
	for i = 1, #seq - n + 1 do
		table.insert(acc, f(aoc.slice(seq, i, i + n - 1)))
	end
	return acc
end

function aoc.ring_map(seq, n, f)
	local acc = {}
	for i = 1, #seq do
		table.insert(acc, f(aoc.slice(seq, i, i + n - 1)))
	end
	return acc
end

-- remove the last element and put it at the beginning
function aoc.cycle(seq)
	local acc = aoc.from_list(seq)
	local last = acc[#acc]
	table.remove(acc, #acc)
	table.insert(acc, 1, last)
	return acc
end

-- filter sequence using a boolean mask
function aoc.filter_mask(seq, mask)
	assert(#seq == #mask)
	local acc = {}
	for i = 1, #seq do
		if mask[i] then
			table.insert(acc, seq[i])
		end
	end
	return acc
end

function aoc.vec2_eq(v, w) return v[1] == w[1] and v[2] == w[2] end

function aoc.zip_with(f, xs, ys)
	local zs = {}
	assert(#xs == #ys)
	for i = 1, #xs do
		table.insert(zs, f(xs[i], ys[i]))
	end
	return zs
end

-- whether it is contained in set
function aoc.belongs_to(it, set, eq)
	for i = 1, #set do
		if eq(it, set[i]) then return true end
	end
	return false
end

function aoc.eq(x, y)
	return x == y
end

--@param from integer
--@param to integer
function aoc.slice(seq, from , to)
	local acc = {}
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

--@param f function
function aoc.each(seq, f)
	for i = 1, #seq do
		f(seq[i])
	end
end

--@param f function
function aoc.reduce(seq, f)
	local acc = seq[1]
	for i = 2, #seq do
		acc = f(acc, seq[i])
	end
	return acc
end

--@param f function
function aoc.map(seq, f)
	local acc = {}
	for i = 1, #seq do
		table.insert(acc, f(seq[i]))
	end
	return acc
end

--@param pred function
function aoc.filter(seq, pred)
	local acc = {}
	for i = 1, #seq do
		if pred(seq[i]) then
			table.insert(acc, seq[i])
		end
	end
	return acc
end

function aoc.globalize()
	for k, v in pairs(aoc) do
		_G[k] = v
	end
end

return aoc
