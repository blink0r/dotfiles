#!/bin/bash
# _               _     ____   ____
#| |__   __ _ ___| |__ |  _ \ / ___|
#| '_ \ / _` / __| '_ \| |_) | |
#| |_) | (_| \__ \ | | |  _ <| |___
#|_.__/ \__,_|___/_| |_|_| \_\\____|
#

if [[ -z $DISPLAY && $XDG_VTNR -eq 1  ]]
then
	exec startx
fi

# set additional environment variables
export PATH="$PATH:$HOME/.local/bin"

#disably ctrl-s and ctrl-q
stty -ixon

# auto cd into directory
shopt -s autocd

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# bash_history settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=10000

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -h --color=auto --group-directories-first"
fi

# aliases
alias sa="sudo apt-get"
alias edi="vim ~/.config/i3/config"
alias edb="vim ~/.bashrc"
alias edv="vim ~/.vimrc"
alias edx="vim ~/.Xresources"
alias edib="sudo vim /etc/i3blocks.conf"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll="ls -hAlF --group-directories-first"
alias v="vim -c start"
alias sv="sudo vim -c start"
alias vim="vim -c start"
alias s="subl"
alias tail="tail -f"
alias ..="cd .."
alias rr="reboot"
alias off="poweroff"
alias mkdir="mkdir -pv"
alias epwn="vim /home/blingi/.local/bin/ctf_framework.py"
alias rpwn="python /home/blingi/.local/bin/ctf_framework.py"
alias yt="youtube-dl --add-metadata -ic"
alias yts="youtube-dl --add-metadata -ics"
alias wget="wget -c"
alias rm="rm --preserve-root"
alias df="df -Th --total"
alias du="du -ach"
alias ps="ps -auxf"
alias psg="ps -aux | grep -v grep | grep -i -e VSZ -e"
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove"
alias dot="cd ~/documents/dotfiles/"
alias gitup="git add ~/documents/dotfiles/ && git commit -m 'update' && git push"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# functions
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

