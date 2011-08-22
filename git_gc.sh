#!/bin/sh

for i in *; do
	if [[ -d "$i/.git" ]]; then
		cd "$i"
		git gc
		if [[ -d "$i/.git/svn" ]]; then
			git svn gc
		fi
		cd ..
	fi
done
