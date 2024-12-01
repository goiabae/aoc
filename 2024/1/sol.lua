function split(str)
	local tokens = {}
	for token in string.gmatch(str, "[^%s]+") do
		table.insert(tokens, token)
	end
	return tokens
end

function part1(filename)
	local fst = {}
	local snd = {}

	for line in io.lines(filename) do
		local nums = split(line)

		table.insert(fst, nums[1])
		table.insert(snd, nums[2])
	end

	table.sort(fst, function (a, b) return a < b end)
	table.sort(snd, function (a, b) return a < b end)

	local total = 0
	for i = 1, #fst do
		total = total + math.abs(fst[i] - snd[i])
	end

	return total
end

function part2(filename)
	local fst = {}
	local freqs = {}

	for line in io.lines(filename) do
		local nums = split(line)

		table.insert(fst, nums[1])
		if freqs[nums[2]] == nil then
			freqs[nums[2]] = 1
		else
			freqs[nums[2]] = freqs[nums[2]] + 1
		end
	end

	local total = 0
	for i = 1, #fst do
		local freq = freqs[fst[i]]
		if freq ~= nil then
			total = total + fst[i] * freq
		end
	end

	return total
end

print(part1("input"))
print(part2("input"))
