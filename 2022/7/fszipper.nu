
export def root [] {
	{
		type: "unlisted-dir"
		name: "/"
		children: []
		parents: []
	}
}

export def perform [zipper, operation] {
	if $operation.type == ls {
		if $zipper.type == "unlisted-dir" {
			{
				type: listed-dir
				name: $zipper.name
				children: (
					$operation.contents | each { |entry|
						if $entry.type == dir {
							{
								type: unlisted-dir
								name: $entry.name
								children: []
							}
						} else if $entry.type == file {
							{
								type: file
								name: $entry.name
								size: $entry.size
							}
						} else {
							error make { msg: $"unknown entry type: ($entry.type)" }
						}
					}
				)
				parents: $zipper.parents
			}
		} else if $zipper.type == "listed-dir" {
			error make { msg: "can't list directories twice" }
		} else {
			error make { msg: "can only list directories" }
		}
	} else if $operation.type == cd {
		if $operation.dirname == ".." {
			if ($zipper.parents | is-empty) {
				error make { msg: "directory does not have a parent" }
			} else {
				$zipper.parents
				| last
				| update children { append ($zipper | reject parents) }
				| insert parents ($zipper.parents | drop)
			}
		} else if $operation.dirname == "/" {
			mut new_zipper = $zipper
			while $new_zipper.name != "/" {
				$new_zipper = perform $new_zipper { type: cd dirname: .. }
			}
			$new_zipper
		} else {
			if $zipper.type == "listed-dir" {
				let candidates = $zipper.children | where type in [listed-dir, unlisted-dir] and name == $operation.dirname
				if ($candidates | is-empty) {
					error make { msg: "child not found or is not a directory" }
				} else if ($candidates | length) > 1 {
					print $candidates
					error make { msg: "more than one child directory with the same name" }
				} else {
					let candidate = $candidates.0
					$candidate | insert parents (
						$zipper.parents | append {
							type: $zipper.type
							name: $zipper.name
							children: ($zipper.children | where not ($it.type == $candidate.type and $it.name == $candidate.name))
						}
					)
				}
			} else {
				error make { msg: "cannot cd into an undiscovered directory" }
			}
		}
	}
}

export def unzip [zipper] {
	if ($zipper.parents | is-not-empty) {
		let parent = $zipper.parents | last
		unzip {
			type: $parent.type
			name: $parent.name
			children: ($parent.children | append {
				type: $zipper.type
				name: $zipper.name
				children: $zipper.children
			})
			parents: ($zipper.parents | drop)
		}
	} else {
		{
			type: $zipper.type
			name: $zipper.name
			children: $zipper.children
		}
	}
}
