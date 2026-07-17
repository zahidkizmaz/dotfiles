{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpv
    telegram-desktop
  ];

  # macOS Sequoia's Code Signing Monitor re-validates app signatures on every
  # cold boot and refuses to launch bundles with a broken seal (AMFI "Launch
  # Constraint Violation"). Nixpkgs ships GUI apps without a sealed
  # _CodeSignature, so they fail to open after a reboot. Re-sign them ad-hoc
  # after nix-darwin copies them into place. Runs after the `applications`
  # activation step, so it re-seals the fresh copies on every rebuild.
  system.activationScripts.postActivation.text = ''
    if [ "$(uname -m)" = 'arm64' ]; then
      echo "re-signing GUI apps for macOS code-signing enforcement..." >&2
      for app in "/Applications/Nix Apps/"*.app /Applications/CopyQ.app; do
        [ -d "$app" ] || continue
        chmod -R u+w "$app" 2>/dev/null || true
        /usr/bin/xattr -rd com.apple.quarantine "$app" 2>/dev/null || true
        /usr/bin/codesign --force --deep --sign - "$app" 2>/dev/null || true
      done
    fi
  '';

  # Refresh LaunchServices for the freshly-signed bundles. Without this a
  # rebuild that re-copies an app leaves a stale launch record cached from the
  # previous (broken) signature, so the GUI launch keeps failing until reboot.
  # Runs in the user context, since GUI launches consult the per-user LS db.
  system.activationScripts.postUserActivation.text = ''
    if [ "$(uname -m)" = 'arm64' ]; then
      lsregister=/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister
      for app in "/Applications/Nix Apps/"*.app /Applications/CopyQ.app; do
        [ -d "$app" ] || continue
        "$lsregister" -f "$app" 2>/dev/null || true
      done
    fi
  '';
}
