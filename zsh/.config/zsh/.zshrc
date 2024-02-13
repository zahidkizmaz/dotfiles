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

# Enable vi mode
bindkey -v

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

# CUSTOM ALIASESES - FUNCTIONS - ENV VARS
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"
[ -f "$ZDOTDIR/env_vars" ] && source "$ZDOTDIR/env_vars"
[ -f "$ZDOTDIR/functionrc" ] && source "$ZDOTDIR/functionrc"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# atuin
if type "atuin" &>/dev/null; then
  # disable zsh history
  HISTSIZE=1
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Starship
if type "starship" &>/dev/null; then
  eval "$(starship init zsh)"
fi

# mise
if type "mise" &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# Zoxide
if type "zoxide" &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Pipx
if type "pipx" &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# PLUGINS
[ -d "$ZDOTDIR/plugins/zsh-autosuggestions" ] && source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -d "$ZDOTDIR/plugins/zsh-syntax-highlighting" ] && source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
