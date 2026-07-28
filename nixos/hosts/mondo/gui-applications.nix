{ pkgs, user, ... }:
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
  #
  # nix-darwin now runs all activation as root (postUserActivation was
  # removed), so the LaunchServices refresh is folded in here and dropped to
  # the console user via `launchctl asuser` + `sudo -u` — GUI launches consult
  # the per-user LS db, which only that user's context can update.
  system.activationScripts.postActivation.text = ''
    if [ "$(uname -m)" = 'arm64' ]; then
      echo "re-signing GUI apps for macOS code-signing enforcement..." >&2
      lsregister=/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister
      uid=$(id -u ${user})
      for app in "/Applications/Nix Apps/"*.app /Applications/CopyQ.app; do
        [ -d "$app" ] || continue
        chmod -R u+w "$app" 2>/dev/null || true
        /usr/bin/xattr -rd com.apple.quarantine "$app" 2>/dev/null || true
        /usr/bin/codesign --force --deep --sign - "$app" 2>/dev/null || true
        # Refresh LaunchServices so a re-copied bundle drops its stale launch
        # record from the previous (broken) signature.
        launchctl asuser "$uid" sudo -u ${user} "$lsregister" -f "$app" \
          2>/dev/null || true
      done
    fi
  '';
}
