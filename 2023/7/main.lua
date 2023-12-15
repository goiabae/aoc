require("aoc")

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

local types = {
	["high-card"] =  1,
	["one-pair"] = 2,
	["two-pair"] = 3,
	["three-of-a-kind"] = 4,
	["full-house"] = 5,
	["four-of-a-kind"] = 6,
	["five-of-a-kind"] = 7,
}

local function comp_hands(cards, x, y)
	local xh = split_chars(x.hand)
	local yh = split_chars(y.hand)
	local xt = types[x.type]
	local yt = types[y.type]

	if xt ~= yt then
		return xt < yt
	end

	for i = 1, #xh do
		if cards[xh[i]] ~= cards[yh[i]] then
			return cards[xh[i]] < cards[yh[i]]
		end
	end

	return false -- they are equal
end

local function solve(f, typer, order)
	local hands = List
		.from_iter(io.lines(f))
		:map(split_on_spaces)
		:map(
			function (x)
				return {
					hand = x[1],
					type = typer(split_chars(x[1])),
					bid = tonumber(x[2])
				}
			end
		)

	table.sort(hands, order)

	local total = 0
	for i = 1, #hands do
		total = total +  i * hands[i].bid
	end
	return total
end

local comp_hands_joker = fix3(comp_hands, {
	["J"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["T"] = 10,
	["Q"] = 11,
	["K"] = 12,
	["A"] = 13,
})

local comp_hands_norm = fix3(comp_hands, {
	["2"] = 1,
	["3"] = 2,
	["4"] = 3,
	["5"] = 4,
	["6"] = 5,
	["7"] = 6,
	["8"] = 7,
	["9"] = 8,
	["T"] = 9,
	["J"] = 10,
	["Q"] = 11,
	["K"] = 12,
	["A"] = 13,
})

local part1 = function(f) return solve(f, hand_type, comp_hands_norm) end
local part2 = function(f) return solve(f, hand_type_joker, comp_hands_joker) end

test({
		{ func = part1, input = "example", output = 6440 },
		{ func = part1, input = "input", output = 248217452 },
		{ func = part2, input = "example", output = 5905 },
		{ func = part2, input = "input", outupt = 245576185 }
})
