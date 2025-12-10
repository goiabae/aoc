let totals = open input | split row "\n\n" | each { lines | each { into int } | math sum } | sort --reverse

if ($totals.0) != 70374 { error make { msg: $"wrong part1 solution: ($in)" } }

$totals
| take 3
| math sum
| if $in != 204610 { error make { msg: $"wrong part2 solution: ($in)" } }
