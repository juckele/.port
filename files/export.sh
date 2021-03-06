#!/bin/bash

export USERGIVENNAME="John"
export HISTFILESIZE=1000000
export HISTSIZE=1000000

export E=/e
export EDITOR="emacs"
export P4EDITOR=$EDITOR

# Gradle home
export GRADLE_HOME="/opt/gradle"
export PATH="$PATH:$GRADLE_HOME/bin"

# Brew Paths
if [[ $(uname) == "Darwin" ]]; then
    export PATH=$HOME/homebrew/bin:$PATH
    export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH
fi

# Add all the funny places bin files could be...
export PATH=$PATH:~/bin/:~/git/.port/bin/:~/.local/bin/:/etc/alternatives/


export GRADLE_OPTS="-Dorg.gradle.daemon=true"
export LESS=-R

export LS_COLORS="no=00:fi=00:di=01;34:ln=00;36:pi=40;32:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31:ex=00;32:"
