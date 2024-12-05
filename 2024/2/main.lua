local function split(str)
	local tokens = {}
	for token in string.gmatch(str, "[^%s]+") do
		table.insert(tokens, token)
	end
	return tokens
end

local function is_safe(report, skip)
	local dec = true
	local inc = true
	for cur_idx = 1, #report - 1 do
		if skip ~= nil and cur_idx == skip then
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

local function tolerating(report)
	if is_safe(report, nil) then
		return true
	end
	for i = 1, #report do
		if is_safe(report, i) then
			return true
		end
	end
	return false
end

local function solution(pred, filename)
	local total = 0
	for line in io.lines(filename) do
		total = total + (pred(split(line), nil) and 1 or 0)
	end
	return total
end

assert(solution(is_safe, "input") == 421, "wrong answer for part 1")
assert(solution(tolerating, "input") == 476, "wrong answer for part 1")
