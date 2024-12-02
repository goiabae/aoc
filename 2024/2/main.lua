function split(str)
	local tokens = {}
	for token in string.gmatch(str, "[^%s]+") do
		table.insert(tokens, token)
	end
	return tokens
end

function is_safe(report)
	local dec = true
	local inc = true
	for i = 1, #report - 1 do
		local cur = tonumber(report[i])
		local nxt = tonumber(report[i+1])
		local diff = math.abs(cur - nxt)

		if not dec and not inc then
			return false
		end
		if not (diff >= 1 and diff <= 3) then
			return false
		end
		dec = dec and cur > nxt
		inc = inc and cur < nxt
	end
	return dec or inc
end

function is_safe_tolerating(report, skip)
	local dec = true
	local inc = true
	for cur_idx = 1, #report - 1 do
		if cur_idx == skip then
			goto continue
		end

		local nxt_idx = cur_idx + ((cur_idx+1 == skip) and 2 or 1)

		local cur = tonumber(report[cur_idx])
		local nxt = tonumber(report[nxt_idx])

		if nxt == nil then
			goto continue
		end

		local diff = math.abs(cur - nxt)

		if (not dec and not inc) or not (diff >= 1 and diff <= 3) then
			return false
		end
		dec = dec and cur > nxt
		inc = inc and cur < nxt

		::continue::
	end
	return dec or inc
end

function part1(filename)
	local total = 0
	for line in io.lines(filename) do
		local report = split(line)
		if is_safe(report) then
			total = total + 1
		end
	end
	return total
end

function part2(filename)
	local total = 0
	for line in io.lines(filename) do
		local report = split(line)

		local safe = is_safe(report)
		if not safe then
			for i = 1, #report do
				if is_safe_tolerating(report, i) then
					safe = true
					break
				end
			end
		end

		if safe then
			total = total + 1
		end
	end
	return total
end

assert(part1("input") == 421, "wrong answer for part 1")
assert(part2("input") == 476, "wrong answer for part 1")
