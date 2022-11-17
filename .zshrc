# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export SHELL=/bin/zsh

alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"

test -e ~/.alias && . ~/.alias || true
test -e ~/.env && . ~/.env || true
test -e ~/.site.sh && . ~/.site.sh || true

# Turn off software flow control (Ctrl-S/Q)
stty -ixon <$TTY >$TTY

# This may have been temporarily set during startup if config is shared with bash
unsetopt no_nomatch

setopt autopushd

# Load completion awesomeness
fpath=(/usr/share/zsh/vendor-completions/_pass $fpath)
autoload -U compinit && compinit

# Support bash completion too
autoload -U bashcompinit && bashcompinit
source /etc/bash_completion &> /dev/null

# Allow completion mid-word
zstyle ':completion:*' completer _complete _list _match _prefix

# Disable hostname completion
zstyle ':completion:*' hosts off

# Make git completion fast at the expense of some lost functionality
__git_files () {
    _wanted files expl 'local files' _files
}

# Editor editing of command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Uber-move
autoload -U zmv
alias mmv='noglob zmv -W'

# Interactive move
imv() {
    local src dst
    for src; do
        [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
        dst=$src
        vared dst
        [[ $src != $dst ]] && mkdir -p $dst:h && mv $src $dst
    done
}

# Command line editing

case $TERM in
    *rxvt*|*xterm*)
        precmd () {print -Pn "\e]0;%M: %~ [%n]\a"}
        preexec () {print -Pn "\e]0;%M: $2 [%n]\a"}
        ;;
esac

bindkey -v    # Vi key bindings

# Bind in both Vi modes
function bindglobal ()
{
    bindkey -v $@
    bindkey -a $@
}

# # Keep some Emacsy bindings
bindglobal '^A' beginning-of-line
bindglobal '^E' end-of-line
bindglobal '^P' up-history
bindglobal '^N' down-history
bindglobal '\e.' end-of-buffer-or-history
bindglobal '^R' history-incremental-search-backward
bindglobal '^U' kill-whole-line
bindglobal '^T' push-line
bindglobal '^Xe' expand-word
bindglobal '\ep' history-search-backward
bindglobal '^H' end-of-history
bindglobal '^w' backward-kill-word
bindglobal '^[.' insert-last-word
bindkey -a ':' execute-named-cmd
bindkey -a '.' execute-last-named-cmd
bindkey -a '/' history-incremental-search-backward
bindkey -a '?' history-incremental-search-forward

autoload -U edit-command-line
zle -N edit-command-line
bindglobal '^f' edit-command-line

# Make word handling like Bash
autoload -U select-word-style
select-word-style bash

# History setup
setopt inc_append_history
#setopt hist_verify
setopt share_history   # Share history real-time between shells
export HISTFILE="$HOME/.zshhistory"
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE

# Automatic directory history
DIRSTACKSIZE=20
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'

source ~/.local/lib/zsh/zsh-z.plugin.zsh

# Syntax highlighting in the shell
# Must be loaded last.
source ~/.local/lib/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Powerlevel10k prompt 
source ~/.local/lib/zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
