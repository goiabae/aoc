open input
| split chars
| drop
| do { |chars|
  $chars
  | drop (4 - 1)
  | enumerate
  | each { |it| $chars | skip $it.index | take 4 }
} $in
| each { uniq }
| take until { length | $in == 4 }
| length
| $in + 4
