{ pkgs, ... }:
{
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    wireplumber.extraConfig = {
      # Default Bluetooth devices to A2DP; a call still gets HFP on demand. Lower
      # index = higher priority, and HFP is absent on purpose.
      "98-bluetooth-a2dp-first" = {
        "device.profile.priority.rules" = [
          {
            matches = [
              { "device.name" = "~bluez_card.*"; }
            ];
            actions = {
              "update-props" = {
                priorities = [
                  "a2dp-sink-sbc_xq"
                  "a2dp-sink-sbc"
                  "a2dp-sink"
                ];
              };
            };
          }
        ];
      };

      "99-suspend-audio" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*"; }
              { "node.name" = "~alsa_input.*"; }
            ];
            actions = {
              "update-props" = {
                "session.suspend-timeout-seconds" = 5;
              };
            };
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
