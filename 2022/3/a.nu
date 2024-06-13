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
| each { |line|
    $line
  | split chars
  | group ($in | length | $in / 2)
  | do { |compartments|
      $compartments.0
    | uniq
    | each { |type| if ($type in $compartments.1) { $type } }
  } $in
}
| flatten
| reduce -f 0 { |it, acc|
  $acc + ($char_codes | get --sensitive $it)
}
