#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    alias date="gdate"
    alias ls="gls -FA"
    alias uniq="guniq"
    alias rm="grm"
else
    alias ls='ls --color -FA'
    alias say='espeak'
fi

alias c='clear'
alias e='emacs -nw'
alias g='grep --color=auto'
alias grep='grep --color=auto'

alias cde='cd $E'

alias java='/usr/bin/java "$@" 2> >(grep -v "^Picked up.*OPTION" >&2)'
alias antlr4='java -jar /usr/local/lib/antlr-4.5.3-complete.jar'
