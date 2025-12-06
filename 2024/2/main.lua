local aoc = require("aoc")

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

---@type solver
local function solve (filename)
	return aoc.iter.unzip2_count(io.lines(filename), function (line)
		local report = aoc.split_on_spaces(line)
		return is_safe(report, nil), tolerating(report)
	end)
end

aoc.verify(solve, "input", 421, 476)
