def intersection [xs: list, ys: list] {
  $xs | filter { |x| $x in $ys }
}

let char_codes = (
  seq char a z
  | append (seq char A Z)
  | reverse
  | rotate
  | append (seq 1 52 | reverse | rotate)
  | headers
  | first
)

open input
| lines
| each {
  split chars
  | chunks ($in | length | $in / 2 | math floor)
  | do { |compartments|
    $compartments.0
    | uniq
    | filter { |type| $type in $compartments.1 }
  } $in
}
| flatten
| reduce --fold 0 { |it, acc|
  $acc + ($char_codes | get --sensitive $it)
}
| if $in != 7701 { error make { msg: $"wrong part1 answer ($in)" } }

open input
| lines
| chunks 3
| each {
  each { split chars | uniq }
  | reduce { |it, acc| intersection $it $acc }
}
| flatten
| reduce --fold 0 { |it, acc|
  $acc + ($char_codes | get --sensitive $it)
}
| if $in != 2644 { error make { msg: $"wrong part2 answer ($in)" } }
