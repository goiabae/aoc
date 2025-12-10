open input
| lines
| split row ','
| parse '{from}-{to}'
| into int from to
| chunks 2
| filter { |it|
  ($it.0.from >= $it.1.from and $it.0.to <= $it.1.to) or ($it.1.from >= $it.0.from and $it.1.to <= $it.0.to)
}
| length
| if $in != 441 { error make { msg: "wrong part1 solution" } }

open input
| lines
| split row ','
| parse '{from}-{to}'
| into int from to
| chunks 2
| filter { |it|
  ([$it.0.from $it.1.from] | math max) <= ([$it.0.to $it.1.to] | math min)
}
| length
| if $in != 861 { error make { msg: "wrong part2 solution" } }
