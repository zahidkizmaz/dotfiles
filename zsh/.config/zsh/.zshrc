export PATH="$HOME/.local/bin:$PATH"


eval "$(starship init zsh)"


export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


source $ZDOTDIR/aliasrc
source $ZDOTDIR/functionrc
