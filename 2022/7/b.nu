let root = (mktemp -d -t aoc-XXXX | str trim -r | path split)
let capacity = 70000000
let minimum = 30000000

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
      command: ($in.0 | split row ' ' | { name: $in.0, args: ($in | skip) }),
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
  | reduce -f {total: 0} { |node, acc|
    if $node.type == file {
      $acc | update total (open --raw $node.name | into int | $in + $acc.total)
    } else {
      let sub_dir = ($dir | path split | append $node.name | path join)
      let c = (recur $sub_dir)
      { total: ($acc.total + $c.total)
      ,  dirs: ($acc | get -i dirs | if ($c | get -i dirs | $in != null) { $in | append $c.dirs } else { $in } | append {dir: $sub_dir, size: $c.total} )
      }
    }
  }
}

recur ($root | path join)
| do { |tree|
  let needed = $minimum - ($capacity - $tree.total)
  $tree.dirs
  | where size >= $needed
  | sort-by size
  | get 0.size
} $in
