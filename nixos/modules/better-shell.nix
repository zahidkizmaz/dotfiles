{ pkgs, ... }:
{
  programs = {
    bat.enable = true;
    direnv.enable = true;
    starship.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      terminal = "tmux-256color";
      baseIndex = 1;
      aggressiveResize = true;
      escapeTime = 10;
      plugins = with pkgs; [ tmuxPlugins.catppuccin ];
      extraConfig = ''
        # Pane Navigation
        bind -r C-h select-pane -L  # move left
        bind -r C-j select-pane -D  # move down
        bind -r C-k select-pane -U  # move up
        bind -r C-l select-pane -R  # move right
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;
      shellInit = # bash
        ''
          export PAGER='less'
          export LESS='-R'
          export MANPAGER='nvim +Man!'

          function sessions() {
            sesh connect "$(
              sesh list --icons | fzf-tmux -p 80%,70% \
                --no-sort --ansi --border-label ' sesh ' --prompt '⚡ ' \
                --bind 'tab:down,btab:up' \
                --preview-window 'right:55%' \
                --preview 'sesh preview {}'
            )"
          }
          alias sl='sessions'
        '';
      shellAliases = {
        # General
        nv = "nvim";
        mkdir = "mkdir -v";
        pls = "sudo $(fc -ln -1)";
        grep = "grep --colour=auto";

        # LS aliases
        ls = "ls --color=auto -h -F";
        ll = "ls --color=auto -h -F -l";
        la = "ls --color=auto -h -F -a";

        # Git aliases
        gs = "git status -sb";
        gsm = "git switch main";
        gp = "git pull origin $(git branch --show-current)";
        grc = "git pull --rebase origin $(git branch --show-current)";
        gP = "git push";
        ga = "git add ";
        gA = "git add -A";
        gc = "git commit ";
        gl = "git log";
        gf = "git fetch --all";
        gco = "git checkout ";
        gd = "git diff";
        gdc = "git diff --cached";
        gm = "git commit -m ";
        gfrb = "git fetch origin && git rebase origin/master";
        gsh = "git stash ";
        gmno = "git commit --amend --no-edit";
        gmo = "git merge origin/master";
        gfgp = "git fetch origin && git pull origin ";
        "git wipe" = "git reset --hard HEAD";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    atuin
    fzf
    gitMinimal
    lnav
    sesh
  ];
}
