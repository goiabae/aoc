local aoc = require("aoc")

---@type solver
local function solve (filename)
	local mat = aoc.parse_char_mat(aoc.read_file(filename))
	local l = #(mat[1])
	local pos = math.ceil((l + 1) / 2)

	local s = 0

	local beams = aoc.mapi(mat[1], function (_, i)
		return (i == pos) and 1 or 0
	end)

	for i = 2, #mat do
		local row = mat[i]
		local new_beams = aoc.list.init(l, 0)
		for j = 1, l do
			if beams[j] > 0 then
				if row[j] == "^" then
					s = s + 1
					new_beams[j-1] = new_beams[j-1] + beams[j]
					new_beams[j+1] = new_beams[j+1] + beams[j]
				elseif row[j] == "." then
					new_beams[j] = new_beams[j] + beams[j]
				end
			end
		end
		beams = new_beams
	end

	local s2 = aoc.list.sum(beams, function (_, x) return x end)

	return s, s2
end

aoc.verify(solve, "example", 21, 40)
aoc.verify(solve, "input", 1626, 48989920237096)
