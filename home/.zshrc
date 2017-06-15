# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \     'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt no_case_glob

for function in ~/.zsh/functions/*; do
  source $function
done

# automatically enter directories without cd
setopt auto_cd

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# emacs mode
bindkey -e

# use incremental search
bindkey "^R" history-incremental-search-backward

# smart history using up/down arrows
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# bind ctrl+b to beginning of line since tmux has ctrl+a
bindkey "^B" beginning-of-line

# expand functions in the prompt
setopt prompt_subst

# prompt
export PS1='[${SSH_CONNECTION+"%n@%m:"}%~] '

# ignore duplicate history entries
setopt histignoredups

# keep TONS of history
export HISTSIZE=4096

# automatically pushd
setopt auto_pushd
export dirstacksize=5

# awesome cd movements from zshkit
setopt AUTOCD
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt cdablevars

# don't autocorrect
unsetopt correct_all
unsetopt correct

# Enable extended globbing
setopt EXTENDED_GLOB

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

if [ -e /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

# speed up ruby tests
export RUBY_GC_MALLOC_LIMIT=90000000

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ ! $TERM =~ screen ]]; then
  tmux attach || tmux new
fi
