let root = (mktemp -d -t aoc-XXXX | str trim -r | path split)
let at_most = 100000

def my-cd [cwd, dir] {
  let new_cwd = (
    if $dir == '/' {
      $root
    } else if $dir == '..' {
      $cwd | drop
    } else {
      $cwd | append $dir
    }
  )
  ^mkdir -p ($new_cwd | path join)
  echo $new_cwd
}

def my-ls [cwd, children] {
  cd ($cwd | path join)
  $children
  | split column ' '
  | each { |it|
    if $it.column1 == dir {
      ^mkdir -p $it.column2
    } else {
      echo ($it.column1 | into string) | save ($cwd | append $it.column2 | path join)
    }
  }
  $cwd
}

let commands = (
  open input
  | split row '$ '
  | skip
  | each {
    lines | {
     command: ($in.0? | split row ' ' | { name: $in.0, args: ($in | skip) }),
     output: ($in | skip | if ($in | is-empty) { null } else { $in })
    }
  }
  | flatten command
)

$commands | reduce -f $root { |command, cwd|
  if $command.name == cd {
    my-cd $cwd $command.args.0
  } else {
    my-ls $cwd $command.output
  }
}

def recur [dir: path] {
  ls $dir
  | reduce -f {total: 0, at_most: 0} { |node, acc|
    if $node.type == file {
      $acc | update total (open --raw $node.name | into int | $in + $acc.total)
    } else {
      let sub_dir = ($dir | path split | append $node.name | path join)
      let c = (recur $sub_dir)
      {   total: ($acc.total + $c.total)
      , at_most: ($acc.at_most + $c.at_most + (if $c.total <= $at_most { $c.total } else { 0 }))
      }
    }
  }
}

recur ($root | path join) | get at_most
