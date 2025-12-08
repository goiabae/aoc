local aoc = require("aoc")

---@param chars string[]
---@return string
local function hand_type(chars)
	local hand = aoc.make_bag(chars)

	if aoc.map.exists(hand, function (_, count) return count == 5 end) then
		return "five-of-a-kind"
	end

	if aoc.map.exists(hand, function (_, count) return count == 4 end) then
		return "four-of-a-kind"
	end

	local pair_count = aoc.map.count(hand, function (_, count) return count == 2 end)
	local three = aoc.map.exists(hand, function (_, count) return count == 3 end)
	local two = pair_count > 0
	if two and three then
		return "full-house"
	end

	if three then
		return "three-of-a-kind"
	end

	if pair_count == 1 then
		return "one-pair"
	elseif pair_count == 2 then
		return "two-pair"
	end
	return "high-card"
end

---@param chars string[]
---@return string
local function hand_type_joker(chars)
	local hand = aoc.make_bag(chars)

	local jokers = hand["J"] or 0

	if jokers == 5 then
		return "five-of-a-kind"
	end

	-- five of a kind
	if aoc.map.exists(hand, function (card, count) return card ~= "J" and (count + jokers) >= 5 end) then
		return "five-of-a-kind"
	end

	if aoc.map.exists(hand, function (card, count) return card ~= "J" and (count + jokers) >= 4 end) then
		return "four-of-a-kind"
	end

	-- full house
	do
		local jokers_left = jokers
		local three = false
		local two = false
		for card, count in pairs(hand) do
			if card ~= "J" and (count + jokers_left) >= 3 then
				jokers_left = jokers_left - (3 - count)
				three = true
				if two then
					return "full-house"
				end
			elseif card ~= "J" and (count + jokers_left) == 2 then
				jokers_left = jokers_left - (2 - count)
				two = true
				if three then
					return "full-house"
				end
			end
		end
	end

	if aoc.map.exists(hand, function (card, count) return card ~= "J" and (count + jokers) >= 3 end) then
		return "three-of-a-kind"
	end

	do
		local pair_count = 0
		for card, count in pairs(hand) do
			if card ~= "J" and (jokers + count) >= 2 then
				jokers = jokers - (2 - count)
				pair_count = pair_count + 1
			end
		end
		if pair_count == 1 then
			return "one-pair"
		elseif pair_count == 2 then
			return "two-pair"
		end
	end

	return "high-card"
end

local types = aoc.inverse {
	"high-card",
	"one-pair",
	"two-pair",
	"three-of-a-kind",
	"full-house",
	"four-of-a-kind",
	"five-of-a-kind"
}

local function comp_hands(cards, x, y)
	if x.type ~= y.type then
		return x.type < y.type
	end

	for i = 1, #x.hand do
		if cards[x.hand[i]] ~= cards[y.hand[i]] then
			return cards[x.hand[i]] < cards[y.hand[i]]
		end
	end

	return false -- they are equal
end

local function solve2(f, typer, order)
	local function g (x)
		local cs = aoc.split_chars(x[1])
		return {
			hand = cs,
			type = types[typer(cs)],
			bid = tonumber(x[2])
		}
	end
	local a = aoc.list.map(aoc.collect(io.lines(f)), function (line) return g(aoc.split_with(line, " ")) end)
	aoc.sort(a, order)
	return aoc.foldi(a, 0, function(acc, x, i) return acc + i*x.bid end)
end

local o1 = aoc.fix(comp_hands, aoc.inverse({ "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" }))
local o2 = aoc.fix(comp_hands, aoc.inverse({ "J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A" }))

local function solve (filename)
	local p1 = solve2(filename, hand_type, o1)
	local p2 = solve2(filename, hand_type_joker, o2)
	return p1, p2
end

aoc.verify(solve, "example", 6440, 5905)
aoc.verify(solve, "input", 248217452, 245576185)
