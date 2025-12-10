def move [stacks, amount, from, to, reverse] {
  # stack pop the push reverses list
  let to_move  = ($stacks | get $from | take $amount | if $reverse { reverse } else $in)
  let new_from = ($stacks | get $from | skip $amount)
  let new_to   = ($stacks | get $to   | prepend $to_move)
  $stacks
  | update $from $new_from
  | update $to $new_to
}

let input = (open input | lines)

let stacks = (
  $input
  | take until { |it| $it == "" }
  | do { |t| $t | drop | prepend ($t | last) } $in
  | str join "\n"
  | detect columns
  | transpose
  | reject column0
  | each { |it| $it | transpose -i | get column0 | where $it != null }
)

let instructions = (
  $input
  | skip ($stacks | length | $in + 1)
  | parse 'move {amount} from {from} to {to}'
  | into int amount from to
)

def f [reverse] {
	$instructions
	| reduce -f $stacks { |op, stacks| move $stacks $op.amount ($op.from - 1) ($op.to - 1) $reverse }
	| each { |stack| $stack | first | str replace --regex '\[([A-Z])\]' '$1' }
	| str join ''
}

if (f true) != WCZTHTMPS { error make { msg: $"wrong part1 answer: ($in)" } }
if (f false) != BLSGJSDTS { error make { msg: $"wrong part2 answer: ($in)" } }
