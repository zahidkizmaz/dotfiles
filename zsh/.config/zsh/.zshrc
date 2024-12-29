#!/usr/bin/env zsh

# Basic auto/tab complete:
# This is necessary for the arch.
autoload bashcompinit
bashcompinit

autoload -Uz compinit
compinit -C
fpath+=~/.zfunc
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.
setopt AUTO_PARAM_SLASH   # if completed parameter is a directory, add a trailing slash

# Edit line in $EDITOR with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# CUSTOM ALIASESES - FUNCTIONS - ENV VARS
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"
[ -f "$ZDOTDIR/env_vars" ] && source "$ZDOTDIR/env_vars"
[ -f "$ZDOTDIR/functionrc" ] && source "$ZDOTDIR/functionrc"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"

# atuin
if type "atuin" &>/dev/null; then
  # disable zsh history
  HISTSIZE=1
  eval "$(atuin init zsh)"
fi

# Starship
if type "starship" &>/dev/null; then
  eval "$(starship init zsh)"
fi

# direnv
if type "direnv" &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf
if type "fzf" &>/dev/null; then
  source <(fzf --zsh)
fi

# Zoxide
if type "zoxide" &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Rust
if type "cargo" &>/dev/null; then
  export PATH="$HOME/.cargo/bin:$PATH"
elif [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# zeesh-man
zeesh_dir=${XDG_DATA_HOME:-"$HOME/.local/share"}/zeesh/zeesh-man
if [[ ! -f $zeesh_dir/zeesh.zsh ]]; then
  command git clone https://github.com/zahidkizmaz/zeesh-man.git "$zeesh_dir"
fi
source "$zeesh_dir/zeesh.zsh"

zeesh_get "zdharma-continuum/fast-syntax-highlighting"
zeesh_get "zsh-users/zsh-autosuggestions"
zeesh_get "jeffreytse/zsh-vi-mode"
zeesh_get "Aloxaf/fzf-tab"
