#!/bin/bash -eu
#
# Fetch upstream kernel repos
#

outdir=${1:-}

if [ -n "${outdir}" ] ; then
	if [ -d "${outdir}" ] ; then
		cd "${outdir}"
	else
		mkdir -p "${outdir}"
		cd "${outdir}"
		git init
	fi
fi

#
# Fetch linux
#

url=https://github.com/torvalds/linux

# Fetch master branch
git fetch --force --no-tags "${url}" \
    "refs/heads/master":"refs/heads/upstream/linux"

# Fetch tags
git fetch --tags "${url}"

#
# Fetch linux-stable
#

url=https://github.com/gregkh/linux

# Fetch all linux-*.y branches
while IFS= read -r ref ; do
	branch=${ref#*refs/heads/}
	git fetch --force --no-tags "${url}" \
	    "refs/heads/${branch}":"refs/heads/upstream/${branch}"
done < <(git ls-remote --heads "${url}" | grep "refs/heads/linux-.*\.y$")

# Fetch tags
git fetch --tags "${url}"
