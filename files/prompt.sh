#!/bin/bash

function record_command_start_time() {
    if [[ $PROMPT_LOCAL_READY == "TRUE" ]]; then
        export PROMPT_LOCAL_START_TIME=$(date +%s%N | cut -b1-13)
        export PROMPT_LOCAL_READY="FALSE"
    fi
}
function record_command_stop_time() {
    export PROMPT_LOCAL_STOP_TIME=$(date +%s%N | cut -b1-13)
}
function execute_trap(){
    if [[ $TRAP_READY == "TRUE" ]]; then
        export TRAP_READY="FALSE"

        # Time new command was executed
        local        LEMON="\033[38;5;227m"
        local pretty_time="$(date +%T)"
        echo -e "$LEMON$pretty_time"
    
        record_command_start_time;

        # Display user and host in tab, add ! to indicate running process.
        echo -ne "\033]0;$user_name@$host_name!\007"

        # Echo 'normal' text before program output so that
        # it is not colorized by the prompt input color
        echo -ne '\033[0m'
    fi
}

# Colored prompt
function proml {
    # Actions to take on the first prompt of a session
    if [[ $FIRST_PROM == "" ]]; then
        echo "Hello!"
        bc -l <<< "- ($(date -d '01/04/2016' +%s) - $(date +%s))/86400/365"
        bc -l <<< "- ($(date -d '06/21/2013' +%s) - $(date +%s))/86400/365"
	export PROMPT_LOCAL_READY="TRUE";
	record_command_start_time;
        export FIRST_PROM="nope";
    fi

    # Record command execution time stop and ready the traps
    record_command_stop_time;
    export PROMPT_LOCAL_READY="TRUE"
    export TRAP_READY="TRUE"

    # Preemptive color setup
    local          RED="\[\033[0;31m\]"
    local    LIGHT_RED="\[\033[1;31m\]"
    local       YELLOW="\[\033[0;33m\]"
    local LIGHT_YELLOW="\[\033[1;33m\]"
    local        GREEN="\[\033[0;32m\]"
    local  LIGHT_GREEN="\[\033[1;32m\]"
    local         BLUE="\[\033[0;34m\]"
    local   LIGHT_BLUE="\[\033[1;34m\]"
    local       PURPLE="\[\033[0;35m\]"
    local LIGHT_PURPLE="\[\033[1;35m\]"
    local         CYAN="\[\033[0;36m\]"
    local   LIGHT_CYAN="\[\033[1;36m\]"
    local         GRAY="\[\033[0;37m\]"
    local    DARK_GRAY="\[\033[1;30m\]"
    local        WHITE="\[\033[1;37m\]"
    local        PLAIN="\[\033[0m\]"
    local         BOLD="\[\033[1;30m\]"

    # colors of form where last number is the color # from ~/git/.port/bin/colors
    # Requires 256 color terminal
    local       ORANGE="\[\033[38;5;214m\]"
    local         PINK="\[\033[38;5;203m\]"
    local   LIGHT_PINK="\[\033[38;5;217m\]"
    local        OLIVE="\[\033[38;5;107m\]"
    local        LILAC="\[\033[38;5;111m\]"

    # command time computation
    local delta_ms="$((PROMPT_LOCAL_STOP_TIME - $PROMPT_LOCAL_START_TIME))"
    local delta_seconds="$(($delta_ms / 1000))"
    local delta_centiseconds="$((delta_ms % 1000 / 100))"
    local delta_centiseconds=$(printf "%0*d" 2 $delta_centiseconds)
    local pretty_delta="$(date -d @$((18000 + $delta_seconds)) +%T)"
    
    # Now
    local pretty_time="$(date +%T)"

    # Git Branch
    local in_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
    if [[ $in_git_repo == "true" ]]; then
        local git_branch=$(git branch 2>/dev/null | grep \* | sed 's/* //')
        local git_branch=$(echo $git_branch | sed 's/juckele\///')
        local git_email=$(git config user.email 2>/dev/null)
        local git_dirty=$(git status --porcelain 2>/dev/null)
        local git_ahead=$(git log origin/master..master 2>/dev/null | wc -l)
        if [[ $git_email == "juckele@nuodb.com" ]]; then
            local git_color="$BLUE"
        elif [[ $git_email == "john.h.uckele@gmail.com" ]]; then
	    local git_color="$CYAN"
        elif [[ $git_email == "j@vivarium.io" ]]; then
	    local git_color="$LIGHT_CYAN"
        elif [[ $git_email == "juckele@google.com" ]]; then
	    local git_color="$LILAC"
        else
	    local git_color="$DARK_GRAY"
        fi

        if [[ $git_dirty ]]; then
            local git_status_color="$RED"
	    local git_status="Δ"
        elif [[ $git_ahead > 0 ]]; then
            local git_status_color="$YELLOW"
	    local git_status="Δ"
        elif [[ $git_branch ]]; then
	    local git_status_color="$GREEN"
	    local git_status="="
        fi

    fi

    # User shorthand
    if [[ $USER == "juckele" ]]; then
        export user_name="我"
	local user_color="$GREEN"
    elif [[ $USER == "vivarium" ]]; then
	local user_name="生"
        local user_color="$WHITE"
    else
        local user_name="$USER"
        local user_color="$ORANGE"
    fi

    # Host color and shorthand name
    export host_name=${PROMPTNAME:-$HOSTNAME}
    if [[ $HOSTPROMPTCOLOR == "" ]]; then
	local host_color="$DARK_GRAY"
    else
	local host_color=$HOSTPROMPTCOLOR
    fi

    # Display user and host in tab
    echo -ne "\033]0;$user_name@$host_name\007"

    # Map colors to fields
    local delta_color="$LIGHT_PINK"
    local time_color="$OLIVE"
    local path_color="$PURPLE"
    local input_color="$LIGHT_PURPLE"
    local operator_color="$YELLOW"
    local operator_color2="$LIGHT_YELLOW"
    local operator_color3="$LIGHT_RED"

    # Build the actual prompt
    PS1="$time_color$pretty_time\n$path_color\w\n$delta_color$pretty_delta$user_color$user_name$host_color$host_name$git_color$git_branch$git_status_color$git_status${operator_color}输入 $input_color"
    PS2='$operator_color2什么$PLAIN '
    PS4='$operator_color3输入$PLAIN '
}

# Traps for color revert for program output and command time computation
trap "execute_trap" DEBUG

# And last but not least, set the prompt function
export PROMPT_COMMAND=proml

