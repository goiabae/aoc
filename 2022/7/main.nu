use ./fszipper.nu

def recur [node, path] {
	const at_most = 100000
	$node.children | reduce -f { total: 0, at_most: 0, dirs: [] } { |child, acc|
		if $child.type == file {
			$acc | update total { |it| $it.total + $child.size }
		} else if $child.type == listed-dir {
			let sub_dir = ($path | path join $node.name)
			let c = recur $child $sub_dir
			{ total: ($acc.total + $c.total)
			, at_most: ($acc.at_most + $c.at_most + (if $c.total <= $at_most { $c.total } else { 0 }))
			, dirs: ($acc.dirs | append $c.dirs | append { dir: $sub_dir, size: $c.total })
			}
		}
	}
}

def parse-commands [filename] {
	open $filename
	| split row '$ '
	| skip
	| each {
		lines | {
			command: ($in.0 | split row ' ' | { name: $in.0, args: ($in | skip) }),
			output: ($in | skip | if ($in | is-empty) { null } else { $in })
		}
	}
	| flatten command
	| each { |c|
		if $c.name == cd {
			{ type: cd dirname: $c.args.0 }
		} else if $c.name == ls {
			let contents = (
				$c.output | each { |line|
					let p = $line | split row (char space)
					if $p.0 == dir {
						{ type: dir name: $p.1 }
					} else {
						{ type: file name: $p.1 size: ($p.0 | into int) }
					}
				}
			)
			{ type: ls contents: $contents }
		}
	}
}

let operations = parse-commands input
let tree = fszipper unzip ($operations | reduce -f (fszipper root) { |operation, zipper|
	fszipper perform $zipper $operation
})

const capacity = 70000000
const minimum = 30000000

let res = recur $tree "/"
let needed = $minimum - ($capacity - $res.total)
let p1 = $res.at_most
let p2 = $res.dirs | where size >= $needed | sort-by size | get 0.size

if $p1 != 1778099 {
	error make { msg: "wrong part1" }
}
if $p2 != 1623571 {
	error make { msg: "wrong part2" }
}
