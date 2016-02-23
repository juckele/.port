#!/bin/bash

## HISTORY MANAGEMENT
# history grepping command
hist () {
    grep "$@" ~/.bash_history | uniq --count | tail -50;
}

rhist () {
     history | tail -150;
}
# This function sets up history file use for a session
start_history () {
    touch ~.history_$$;
    trap end_history EXIT;
}

empty () {
    ls $1 >& ~/empty_temp;
    error=$(grep "No such file" ~/empty_temp);
    if [[ $error == "" ]]; then
        echo "Emptying file: $1";
        oldsize=$(ls -lh $1 | sed s/.*users\ *// | sed s/\ .*//);
        echo "Filesize is: $oldsize";
        rm $1 && touch $1;
    else
        echo "File $1 does not exist";
    fi

    rm ~/empty_temp;
}

un () {
    killall -v -u juckele -9 $1;
}

greet () {
    greet=$(random_line ~/linefiles/startup | sed -e "s|USERNAME|$USERGIVENNAME|");
    echo -e "\033[38;5;204m$greet";
}

random_line () {
    head -$((${RANDOM} % `wc -l < $1` + 1)) $1 | tail -1;
}

cl () {
    cd $1;
    ls;
}

crl () {
     /usr/bin/curl $1;
     echo '';
}

fig() {
      find ./ | grep $1
}

jf() {
     find ./ | grep $1.*java
}