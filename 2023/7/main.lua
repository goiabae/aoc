require("aoc")

-- TODO extract common logic between hand_type and hand_type_joker
local function hand_type(chars)
	local hand = {}

	for i = 1, #chars do
		if hand[chars[i]] == nil then
			hand[chars[i]] = 1
		else
			hand[chars[i]] = hand[chars[i]] + 1
		end
	end

	-- five of a kind
	for _, count in pairs(hand) do
		if count == 5 then
			return "five-of-a-kind"
		end
	end

	-- four of a kind
	for _, count in pairs(hand) do
		if count == 4 then
			return "four-of-a-kind"
		end
	end

	-- full house
	do
		local three = false
		local two = false
		for _, count in pairs(hand) do
			if count == 3 then
				three = true
				if two then
					return "full-house"
				end
			end
			if count == 2 then
				two = true
				if three then
					return "full-house"
				end
			end
		end
	end

	-- three of a kind
	for _, count in pairs(hand) do
		if count == 3 then
			return "three-of-a-kind"
		end
	end

	-- two pair
	-- one pair
	do
		local pair_count = 0
		for _, count in pairs(hand) do
			if count == 2 then
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

local function hand_type_joker(chars)
	local hand = {}

	for i = 1, #chars do
		if hand[chars[i]] == nil then
			hand[chars[i]] = 1
		else
			hand[chars[i]] = hand[chars[i]] + 1
		end
	end

	local jokers = hand["J"] or 0

	if jokers == 5 then
		return "five-of-a-kind"
	end

	-- five of a kind
	for card, count in pairs(hand) do
		if card ~= "J" and (count + jokers) >= 5 then
			return "five-of-a-kind"
		end
	end

	-- four of a kind
	for card, count in pairs(hand) do
		if card ~= "J" and (count + jokers) >= 4 then
			return "four-of-a-kind"
		end
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
				goto continue
			end
			if card ~= "J" and (count + jokers_left) == 2 then
				jokers_left = jokers_left - (2 - count)
				two = true
				if three then
					return "full-house"
				end
			end
			::continue::
		end
	end

	-- three of a kind
	for card, count in pairs(hand) do
		if card ~= "J" and (count + jokers) >= 3 then
			return "three-of-a-kind"
		end
	end

	-- two pair
	-- one pair
	do
		local jokers_left = jokers
		local pair_count = 0
		for card, count in pairs(hand) do
			if card ~= "J" and (jokers_left + count) >= 2 then
				jokers_left = jokers_left - (2 - count)
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

local types = inverse {
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

local function solve(f, typer, order)
	return List
		.from_iter(io.lines(f))
		:map(split_on_spaces)
		:map(function (x) return { hand = split_chars(x[1]), type = types[typer(split_chars(x[1]))], bid = tonumber(x[2]) } end)
		:sort(fix3(comp_hands, inverse(order)))
		:foldi(0, function(acc, x, i) return acc + i*x.bid end)
end

local part1 = function(f)
	return solve(f, hand_type, {
		"2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"
	})
end

local part2 = function(f)
	return solve(f, hand_type_joker, {
		"J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"
	})
end

test({
	{ func = part1, input = "example", output = 6440 },
	{ func = part1, input = "input", output = 248217452 },
	{ func = part2, input = "example", output = 5905 },
	{ func = part2, input = "input", outupt = 245576185 }
})
