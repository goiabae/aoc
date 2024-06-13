def intersection [xs: list, ys: list] {
  $xs | each { |x| if $x in $ys { $x } }
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
| group 3
| each { |group|
    $group
  | each { |sack| $sack | split chars | uniq }
  | reduce { |it, acc| intersection $it $acc }
}
| flatten
| reduce --fold 0 { |it, acc|
  $char_codes | get --sensitive $it | $in + $acc
}
