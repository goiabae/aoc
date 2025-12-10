def f [n] {
	open input
	| split chars
	| drop
	| window $n
	| each { uniq }
	| take until { length | $in == $n }
	| length
	| $in + $n
}

if (f 4) != 1655 { error make { msg: "wrong part1 answer" } }
if (f 14) != 2665 { error make { msg: "wrong part2 answer" } }
