#!/bin/zsh

# zsh script
[[ -z $ZSH_VERSION ]] && return

tmuxlogger() {
    if [[ -z $TMUX ]]; then
        return 1
    fi

    if [[ ! -f ~/.tmux.info ]]; then
        return 1
    fi

    local current_pane_number current_window_number
    current_pane_number="$(tmux list-panes | grep 'active' | cut -d: -f1)"
    current_window_number="$(tmux display -p '#I')"

    cat <~/.tmux.info |
    # 1:1:/Users/b4b4r07/go/src/github.com/b4b4r07/twithub
    # 1:1:/Users/b4b4r07
    # 1:2:/Users/b4b4r07/bin

    if (($# > 0)) &&
        [[ $1 =~ ^[0-9]+$ ]] &&
        tmux list-panes | grep -q "^$1"
    then
        # >tmuxlogger 1
        # 1:1:/Users/b4b4r07/go/src/github.com/b4b4r07/twithub
        # 1:1:/Users/b4b4r07
        grep "$current_window_number:$1"
    else
        # other
        # 1:2:/Users/b4b4r07/bin
        grep -v "$current_window_number:$current_pane_number"
    fi | tail -1 |
    # 1:1:/Users/b4b4r07

    if [[ "$1" == "-n" ]]; then
        # 1
        cut -d: -f2
    else
        # /Users/b4b4r07
        cut -d: -f3
    fi
}

_tmuxlogger() {
    touch ~/.tmux.info
    if [ -n "$TMUX" ]; then
        echo "$(tmux display -p "#I:#P"):$PWD" >>~/.tmux.info
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _tmuxlogger

alias opwd='tmuxlogger'
alias -g T=' $(tmuxlogger)'
