{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      wireplumber = prev.wireplumber.overrideAttrs (_: {
        version = "git";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "pipewire";
          repo = "wireplumber";
          rev = "e76ebde6d82524f2b4e652b1e006412706dde961";
          hash = "sha256-VX3OFsBK9AbISm/XTx8p05ak+z/VcKXfUXhB9aI9ev8=";
        };
      });

      libcamera = prev.libcamera.overrideAttrs (_: {
        postFixup = ''
          ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa_*.so
        '';
      });
    })
  ];
}
