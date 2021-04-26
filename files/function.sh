#!/bin/bash

## HISTORY MANAGEMENT
# history grepping command
hist () {
    grep $@ ~/.bash_history | uniq --count | tail -50;
}

uhist () {
    grep $@ ~/.bash_history | uniq --count;
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

# Wrapper/shorthand for exit, with added handling for screen
ex() {
  # If we're in a screen session
  # exit iff the user passes -f, otherwise detach
  if [[ $STY ]]; then
    if [[ $1 == "-f" ]]; then
      echo "Forcing exit from screen bash. Goodbye!";
      exit;
    elif [[ $1 == "-d" ]]; then
      screen -d $STY;
    else
      echo "You're in a screen session. Use -f if you actually want to exit the shell or -d to detach!"
    fi
  # If we're not in a screen session, exit normally always.
  else
    echo "Goodbye!";
    exit;
  fi
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
    echo './gradlew exists, using ./gradlew file';
    ./gradlew $*;
  else
    echo './gradlew does not exist, using default system gradle installation';
    local GRADLE_CMD=$(which gradle);
    $GRADLE_CMD $*;
  fi
}
