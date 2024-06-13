def move [stacks, amount, from, to] {
  # CrateMover 9001 can move multiple crates at once
  let to_move  = ($stacks | get $from | take $amount)
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

$instructions
| reduce -f $stacks { |op, stacks| move $stacks $op.amount ($op.from - 1) ($op.to - 1) }
| each { |stack| $stack | first | str replace --regex '\[([A-Z])\]' '$1' }
| str join ''
