open input
| split chars
| drop
| do { |chars|
  $chars
  | drop (14 - 1)
  | enumerate
  | each { |it| $chars | skip $it.index | take 14 }
} $in
| each { uniq }
| take until { length | $in == 14 }
| length
| $in + 14
