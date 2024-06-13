def 'set intersection' [a, b] {
  $a | each { |it| if $it in $b { $it } }
}

open input
| lines
| split row ','
| parse '{from}-{to}'
| into int from to
| each { |it| seq $it.from $it.to }
| group 2
| each { |it| set intersection $it.0 $it.1 | is-empty | not $in }
| where $it == true
| length
