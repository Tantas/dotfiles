#!/bin/bash

# Verify dependencies exist.
command -v curl >/dev/null 2>&1 || \
    { echo >&2 "Missing dependency curl. Aborting."; exit 1; }

# Vim configuration directories
autoloadDirectory="${HOME}/.vim/autoload"
vimbundleDirectory="${HOME}/.vim/bundle"

echo "Updating Pathogen..."

# Update vim-pathogen
mkdir -p "${autoloadDirectory}" "${vimbundleDirectory}"
curl -Sso "${autoloadDirectory}/pathogen.vim" \
	"https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim"

# Update the bundles
vimbundles=(
	"git://github.com/tpope/vim-sensible" \
	"git://github.com/scrooloose/nerdtree" \
	"git://github.com/tpope/vim-markdown" \

)
cd "${vimbundleDirectory}"
for vimbundlerepository in ${vimbundles[@]}; do
	echo "Checking bundle ${vimbundlerepository}"
	repositoryname=$(basename ${vimbundlerepository})
	if [[ -d ${repositoryname} ]]; then
		cd ${repositoryname}
		git pull
		cd ../
	else
		echo 'Cloning bundle '
		git clone -q ${vimbundlerepository}
	fi
done

# Delete bundles by removing from vimbundles and "${vimbundleDirectory}"

