# History in cache directory:
HISTSIZE=10000
HISTFILE=$HOME/.cache/zsh/history

# http://zsh.sourceforge.net/Doc/Release/Options.html#History
setopt append_history         # append to history file
setopt extended_history       # write the history file in the ':start:elapsed;command' format
setopt hist_expire_dups_first # expire a duplicate event first when trimming history
setopt hist_find_no_dups      # don't display a previously found event
setopt hist_ignore_all_dups   # delete an old recorded event if a new event is a duplicate
setopt hist_ignore_dups       # don't record an event that was just recorded again
setopt hist_ignore_space      # don't record an event starting with a space
setopt hist_no_store          # don't store history commands
setopt hist_reduce_blanks     # remove superfluous blanks from each command line being added to the history list
setopt hist_save_no_dups      # don't write a duplicate event to the history file
setopt hist_verify            # don't execute immediately upon history expansion
setopt inc_append_history     # write to the history file immediately, not when the shell exits
unsetopt hist_beep            # don't beep when attempting to access a missing history entry
unsetopt share_history        # don't share history between all sessions

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

# Pipx
if type "pipx" &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

# asdf -vm
if [[ -f "/opt/asdf-vm/asdf.sh" ]]; then
  source /opt/asdf-vm/asdf.sh
fi

# CUSTOM ALIASESES AND FUNCTIONS
[ -f "$ZDOTDIR/aliasrc" ] && source $ZDOTDIR/aliasrc
[ -f "$ZDOTDIR/env_vars" ] && source $ZDOTDIR/env_vars
[ -f "$ZDOTDIR/functionrc" ] && source $ZDOTDIR/functionrc
[ -f "$HOME/.bash_profile" ] && source $HOME/.bash_profile
[ -f "$HOME/.fzf.zsh" ] && source $HOME/.fzf.zsh

# PLUGINS
[ -d "$ZDOTDIR/plugins/zsh-pyenv-lazy" ] && source $ZDOTDIR/plugins/zsh-pyenv-lazy/pyenv-lazy.plugin.zsh
[ -d "$ZDOTDIR/plugins/zsh-autosuggestions" ] && source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -d "$ZDOTDIR/plugins/zsh-syntax-highlighting" ] && source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
