{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ghostty
    kitty
    sesh
    starship
    tmux
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "IosevkaTerm"
        "Noto"
      ];
    })
    noto-fonts-color-emoji
  ];
}
