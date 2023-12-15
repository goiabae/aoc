require("aoc")

local cards = {
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
}

local types = {
	["high-card"] =  1,
	["one-pair"] = 2,
	["two-pair"] = 3,
	["three-of-a-kind"] = 4,
	["full-house"] = 5,
	["four-of-a-kind"] = 6,
	["five-of-a-kind"] = 7,
}

local function hand_type(chars)
	local hand = {}

	for i = 1, #chars do
		if hand[chars[i]] == nil then
			hand[chars[i]] = 1
		else
			hand[chars[i]] = hand[chars[i]] + 1
		end
	end

	local type = 0

	-- five of a kind
	for card, count in pairs(hand) do
		if count == 5 then
			return "five-of-a-kind"
		end
	end

	-- four of a kind
	for card, count in pairs(hand) do
		if count == 4 then
			return "four-of-a-kind"
		end
	end

	-- full house
	do
		local three = false
		local two = false
		for card, count in pairs(hand) do
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
	for card, count in pairs(hand) do
		if count == 3 then
			return "three-of-a-kind"
		end
	end

	-- two pair
	-- one pair
	do
		local pair_count = 0
		for card, count in pairs(hand) do
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

local function comp_hands(x, y)
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

	-- they are equal
	return false
end

local function part1(f)
	local hands = List
		.from_iter(io.lines(f))
		:map(split_on_spaces)
		:map(
			function (x)
				return {
					hand = x[1],
					type = hand_type(split_chars(x[1])),
					bid = tonumber(x[2])
				}
			end
		)

	table.sort(hands, comp_hands)

	local total = 0
	for i = 1, #hands do
		print(hands[i].hand .. " " .. i .. "*".. hands[i].bid)
		total = total +  i * hands[i].bid
	end
	return total
end

test({
		{ func = part1, input = "example", output = 6440 },
		{ func = part1, input = "input" }
})
