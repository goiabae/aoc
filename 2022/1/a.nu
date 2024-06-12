open input | split row "\n\n" | each {|it| $it | lines | reduce -f 0 {|num, acc| ($num | into int) + $acc } } | sort | last
