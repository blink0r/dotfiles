if [[ -z $DISPLAY && $XDG_VTNR -eq 1  ]]
then
	exec startx
fi

# set additional environment variables
export PATH="$PATH:$HOME/.local/bin"

#disably ctrl-s and ctrl-q
stty -ixon

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# autocd into directory
setopt autocd

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt sharehistory

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ssh icon
if [[ ! -z "$SSH_CLIENT" ]]; then
    RPROMPT="$RPROMPT ⇄"
fi

# typing ... expands to ../.., .... to ../../.., etc.
rationalise-dot() {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}

zle -N rationalise-dot
bindkey . rationalise-dot

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -h --color=auto --group-directories-first"
fi

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# aliases
alias sa="sudo apt-get"
alias edi="vim ~/.config/i3/config"
alias edb="vim ~/.bashrc"
alias edv="vim ~/.vimrc"
alias edx="vim ~/.Xresources"
alias edz="vim ~/.zshrc"
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
alias yts="youtube-dl --add-metadata -icx --audio-format mp3"
alias wget="wget -c"
alias rm="rm --preserve-root"
alias df="df -Th --total"
alias du="du -ach"
alias ps="ps -auxf"
alias psg="ps -aux | grep -v grep | grep -i -e VSZ -e"
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove"
alias gitup="cd ~/documents/dotfiles/ && git add ~/documents/dotfiles/ && git commit -m 'update' && git push && cd"
alias neo="neofetch --refresh_rate on"
alias r="ranger"

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

# Load zsh-plugins; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
