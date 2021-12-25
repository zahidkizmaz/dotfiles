# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

export EDITOR='nvim'
export PSQL_EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER='nvim +Man!'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

# Edit line in $EDITOR with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
# Starship
eval "$(starship init zsh)"
# Direnv
eval "$(direnv hook zsh)"

# CUSTOM ALIASESES AND FUNCTIONS
[ -f  "$ZDOTDIR/aliasrc" ] && source $ZDOTDIR/aliasrc
[ -f "$ZDOTDIR/functionrc" ] && source $ZDOTDIR/functionrc
[ -f "$HOME/.bash_profile" ] && source $HOME/.bash_profile

# PLUGINS
[ -d "$ZDOTDIR/plugins/zsh-autosuggestions" ] && source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -d "$ZDOTDIR/plugins/zsh-syntax-highlighting" ] && source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
