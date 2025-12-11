local aoc = require("aoc")

---@param report string[]
---@param skip? integer
---@return boolean
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

---@param report string[]
---@return boolean
local function tolerating(report)
	return is_safe(report) or aoc.iter.exists(aoc.iter.take(aoc.iter.iota(), #report), aoc.fix(is_safe, report))
end

---@type solver
local function solve (filename)
	local function f (line)
		local report = aoc.split_on_spaces(line)
		return is_safe(report, nil), tolerating(report)
	end
	return aoc.iter.count2(aoc.iter.map(io.lines(filename), f), aoc.id)
end

aoc.verify(solve, "input", 421, 476)
