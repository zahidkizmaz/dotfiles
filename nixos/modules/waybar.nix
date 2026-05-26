{ ... }:
{
  programs.waybar.enable = true;

  # Waybar service restricts PATH at build time — give it access to
  # the full system profile so on-click handlers (wpctl etc.) work.
  systemd.user.services.waybar.path = [ "/run/current-system/sw/bin" ];
}
