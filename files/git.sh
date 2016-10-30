#!/bin/bash

# Lazy ~/git
export G=~/git

# Lazy git repos
export V=$G/vivarium
export P=$G/.port

# Preceed my own git install over my workplaces 3rd party tool repo

if [[ $(uname) == "Darwin" ]]; then
    alias git='/Users/juckele/homebrew/bin/git'

    # Lazy gitk
    alias k='gitx'
    # Lazy git gui
    alias gg='gitx'
else
    alias git='/usr/bin/git'

    # Lazy gitk
    alias k='gitk'
    # Lazy git gui
    alias gg='git gui'
fi


# Allow wildcard to match hidden files so that the following commands work on this project
shopt -s dotglob

# pull all git projects
pullall () {
    local pwd=$(pwd);
    for f in $G/*; do cd $f; echo -e "\033[1;32mPulling $f\033[0m"; git pull; done
    cd $pwd
}

# status for all git projects
statusall () {
    local pwd=$(pwd);
    for f in $G/*; do cd $f; echo -e "\033[1;32mStatus of $f\033[0m"; git status; done
    cd $pwd
}
