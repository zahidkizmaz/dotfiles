# History settings
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Basic auto/tab complete:
autoload -U bashcompinit
bashcompinit
fpath+=~/.zfunc
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
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

# Starship
if type "starship" &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Direnv
if type "direnv" &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Zoxide
if type "zoxide" &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Pipx
if type "pipx" &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

# asdf-vm
if [[ -f "/opt/asdf-vm/asdf.sh" ]]; then  # Linux
  source /opt/asdf-vm/asdf.sh
elif [[ -f "/usr/local/opt/asdf/libexec/asdf.sh" ]]; then  # Intel Mac
  source /usr/local/opt/asdf/libexec/asdf.sh
elif [[ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]]; then  # Arm Mac
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# CUSTOM ALIASESES - FUNCTIONS - ENV VARS
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"
[ -f "$ZDOTDIR/env_vars" ] && source "$ZDOTDIR/env_vars"
[ -f "$ZDOTDIR/functionrc" ] && source "$ZDOTDIR/functionrc"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# PLUGINS
[ -d "$ZDOTDIR/plugins/zsh-autosuggestions" ] && source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -d "$ZDOTDIR/plugins/zsh-syntax-highlighting" ] && source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
