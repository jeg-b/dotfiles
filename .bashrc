#
# ~/.bashrc -- depends on .bash/prompt.sh
#

# If not running interactively, don't do anything
if [ "${-#*i}" == *$-* ]; then
	return
fi

source $HOME/.bash/prompt.sh
source $HOME/.bash/git.sh
source $HOME/.bash/sshagent.sh

EDITOR=/usr/bin/vim
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -la'
alias sudo='sudo '
alias xc='xclip -selection clipboard'
alias steam='PROTON_USE_WINE3D=1 flatpak run com.valvesoftware.Steam &>/dev/null &'
function bwu () { bw get username "$1" | xc ; }
function bwp () { bw get password "$1" | xc ; }
function bwt () { bw get totp "$1" | xc ; }
function bwi () { bw get item "$1" | jq ; }
function bws () { bw list items --search "$1" ; }
### history settings 

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

###  change directory to last nnn directory

if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
	source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

### debian-like autocomplete

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'

if ! shopt -oq posix; then
	if [ -f /usr/share/bash_completion/bash_completion ]; then
		. /usr/share/bash_completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

### colored prompt 

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
else
	color_prompt=
fi

if [ "$color_prompt" = yes ]; then
	trap 'timer_start' DEBUG
	set_prompt
	PROMPT_COMMAND=timer_stop
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

### xterm support

# if bash is launched from xterm set window name
case "$TERM" in
	xterm*|rxvt*|st*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac

