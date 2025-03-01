$env.path ++= ["~/.local/bin"]
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = ""

source ./completers.nu
source ./catppuccin-mocha.nu
'~/.bash_profile' | path exists | sh ~/.bash_profile

#------------------------------
# Env Vars
#------------------------------
$env.PSQL_EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.PAGER = "less"
$env.LESS = "-R"
$env.MANPAGER = "nvim +Man!"
$env.LC_ALL = "en_US.UTF-8"
$env.LANG = "en_US.UTF-8"

# FD Vars
$env.FD_OPTIONS = "--hidden -I --follow --exclude .git --exclude node_modules --exclude .direnv"

# FZF Vars
$env.FZF_DEFAULT_COMMAND = $"fd --type f --type l ($env.FD_OPTIONS)"
$env.FZF_DEFAULT_OPTS = "--no-hscroll --height 40%
                        --layout=reverse --margin=0
                        --info=inline --color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD
                        --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96
                        --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always --line-range :50 {}'"

# BAT Vars
$env.BAT_THEME = "Catppuccin-mocha"

# Pip Setting
$env.PIP_REQUIRE_VIRTUALENV = true

# Term Setting Works With Tmux
$env.TERM = "xterm-256color"


#------------------------------
# Aliases
#------------------------------
alias nu-open = open
alias open = ^open
alias nv = nvim
alias mkdir = mkdir -v
alias pls = sudo (fc -ln -1)
alias grep = grep --colour=auto


#------------------------------
# Git Aliases
#------------------------------
alias gs = git status -sb
alias gp = git push
alias ga = git add
alias gA = git add -A
alias gc = git commit
alias gl = git log
alias gf = git fetch --all
alias gco = git checkout
alias gd = git diff
alias gdc = git diff --cached
alias gsh = git stash
alias gmno = git commit --amend --no-edit
alias gmo = git merge origin/master
alias gpm = git pull origin (git branch --show-current)

#------------------------------
# GitHub CLI Aliases
#------------------------------
alias pro = gh pr view --web


#------------------------------
# CLI Tools
#------------------------------
mkdir ($nu.data-dir | path join "vendor/autoload")

# Starship
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Zoxide
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Direnv
$env.config = ($env.config | upsert hooks {
    env_change: {
        PWD: { ||
          if (which direnv | is-empty) {
            return
          }

          direnv export json | from json | default {} | load-env
          if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
            $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
          }
        }
    }
})

source ./autin.nu


#------------------------------
# Helper Functions
#------------------------------

# GitHub CLI Functions
def prc [] {
  let gh_pr_create = 'gh pr create --draft --assignee "@me"'
  let pr_template = (git ls-files | grep -i -o -F "pull_request_template.md" | first)
  let cmd = if $pr_template != "" {
    $gh_pr_create + " --template " + $pr_template
  } else {
    $gh_pr_create + " --fill"
  }
  eval $cmd; gh pr view --web
}


# Checkout git branch
def fco [] {
    let branches = (git for-each-ref --sort=-committerdate refs/ --format="%(refname:short)")
    let branch = ($branches | fzf --no-sort )
    if $branch != "" {
        git checkout ($branch | str replace "origin/" "")
    }
}

# fzf env vars
def fzf-env-vars [] {
    let out = ($env | to text | fzf)
    if $out != "" {
        echo ($out | split row "=" | get 1)
    }
}

# Kill processes with fzf
def fzf-kill-processes [] {
    let pid = (^ps -ef | sed 1d | fzf | awk '{print $2}')
    if ($pid | is-not-empty)  {
        kill --force ($pid | into int)
    }
}

# Sesh connect
def sessions [] {
    let session = (
        sesh list --icons
        | fzf-tmux
        -p '80%,70%'
        --no-sort
        --ansi
        --border-label ' sesh '
        --prompt '⚡ '
        --bind 'tab:down,btab:up'
        --preview-window 'right:55%'
        --preview 'sesh preview {}'
    )

    if ($session | is-not-empty) {
        sesh connect $session
    }
}
alias sl = sessions
