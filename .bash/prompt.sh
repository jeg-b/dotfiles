#
# script for formatting the prompt
#
function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function format_time {
    local delta_us=$1
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 360000000))

    if ((h > 0)); then execution_time="${h}h ${m}m"
    elif ((m > 0)); then execution_time="${m}m ${s}s"
    elif ((s >= 10)); then execution_time="${s}.$((ms / 100))s"
    elif ((s > 0)); then execution_time="${s}.$(printf '%.3d' "${ms}")s"
    elif ((ms >= 100)); then execution_time="${ms}ms"
    elif ((ms > 0)); then execution_time="${ms}.$(printf '%.3d' "${us}")ms"
    else execution_time="${us}us"
    fi
}


function timer_stop {
    local result="$?"
    if [ -z "$timer_start" ]; then
        trap 'timer_start' DEBUG
        timer_start=$timer_now
    fi
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    format_time "$delta_us"
    exit_status $result
    echo "Execution time $execution_time"
    unset timer_start execution_time result
}

function exit_status {
    cgreen='\e[92m'
    cred='\e[31m'
    creset='\e[0m'
    iconx='\xE2\x9D\x8C'
    iconcheckmark='\xE2\x9C\x94'
    if [ "$1" -eq 0 ] ; then
        echo -e "$cgreen$iconcheckmark ${creset}Done."
    else
        echo -e "$cred$iconx${creset}EC: $1"
    fi
    unset cgreen cred creset iconx iconcheckmark
    set_prompt
}

function set_prompt() {
    cred='\[\e[30;41m\]'
    cgreen='\[\e[92;42m\]'
    cyellow='\[\e[30;43m\]'
    ccyan='\[\e[36;40m\]'
    creset='\[\e[0m\]'
    PS1="${creset}"
    PS1+="${cgreen}[\u@\h]${creset}\n ${cyellow}$(__git_ps1 "[%s]")${creset}\n ${ccyan}\w${creset} [\t] \$ > "
#   PS1+="$cgreen[\u@\h]\n $cyellow\`parse_git_branch\`$creset $ccyan\w$creset \`nonzero_return\` > $creset"
    unset cred cgreen cyellow ccyan creset
}

