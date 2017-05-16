#!/bin/bash

## HISTORY MANAGEMENT
# history grepping command
hist () {
    grep "$@" ~/.bash_history | uniq --count | tail -50;
}

uhist () {
    grep "$@" ~/.bash_history | uniq --count;
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

# Surfaces all terminals to the top
show() {
    xdotool search --class "terminal" windowactivate %@ > /dev/null 2>&1
}

# Kill everything that's mine
un () {
    killall -v -u juckele -9 $1;
}

# Say hello
greet () {
    greet=$(random_line ~/linefiles/startup | sed -e "s|USERNAME|$USERGIVENNAME|");
    echo -e "\033[38;5;204m$greet";
}

# Print a random line from a file
random_line () {
    head -$((${RANDOM} % `wc -l < $1` + 1)) $1 | tail -1;
}

# cd -> ls
cl () {
    cd $1;
    ls;
}

# curl + newline
crl () {
     /usr/bin/curl $1;
     echo '';
}

# find | grep
fig() {
      find ./ | grep $1
}

# find | grep with file extension
fx() {
     find ./ | grep $1.*\.$2
}

# recrusive grep
gr() {
#     PATTERN=${1}
#     ROOT=${2:./}
     grep -r $1 ./
}

# use .gradlew if it exists
gradle() {
  if [ -f ./gradlew ]; then
    echo './gradlew exists, using that';
    ./gradlew;
  else
    echo './gradlew does not exist, which gradle?';
    local GRADLE_CMD=$(which gradle);
    echo -ne $GRADLE_CMD;
    $GRADLE_CMD;
  fi
}
