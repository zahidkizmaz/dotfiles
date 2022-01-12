# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.cache/zsh/history

# Basic auto/tab complete:
fpath+=~/.zfunc
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
export ZSH_PYENV_LAZY_VIRTUALENV=true

# Edit line in $EDITOR with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Better Up and Down arrow searches
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# zmodload zsh/terminfo
# bindkey "$terminfo[kcuu1]" up-line-or-beginning-search  # Up
# bindkey "$terminfo[kcud1]" down-line-or-beginning-search  # Down
bindkey "^[[A" up-line-or-beginning-search   # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Starship
if type "starship" &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Direnv
if type "direnv" &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# CUSTOM ALIASESES AND FUNCTIONS
[ -f "$ZDOTDIR/aliasrc" ] && source $ZDOTDIR/aliasrc
[ -f "$ZDOTDIR/functionrc" ] && source $ZDOTDIR/functionrc
[ -f "$HOME/.bash_profile" ] && source $HOME/.bash_profile

# PLUGINS
[ -d "$ZDOTDIR/plugins/zsh-pyenv-lazy" ] && source $ZDOTDIR/plugins/zsh-pyenv-lazy/pyenv-lazy.plugin.zsh
[ -d "$ZDOTDIR/plugins/zsh-autosuggestions" ] && source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -d "$ZDOTDIR/plugins/zsh-syntax-highlighting" ] && source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
