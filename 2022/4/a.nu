def 'set contained' [a, b] {
  $a | reduce -f true { |it, acc| $acc and ($it in $b) }
}

open input
| lines
| split row ','
| parse '{from}-{to}'
| into int from to
| each { |it| seq $it.from $it.to }
| group 2
| each { |it| (set contained $it.0 $it.1) or (set contained $it.1 $it.0) }
| where $it == true
| length
