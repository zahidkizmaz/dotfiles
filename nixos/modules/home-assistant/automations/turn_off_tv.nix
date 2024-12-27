{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Turn off TV Power at night";
        trigger = {
          platform = "time";
          at = "23:59:59";
        };
        condition = {
          condition = "or";
          conditions = [
            {
              condition = "device";
              device_id = "1c9343ec47f2b43cbded556b31b07835";
              domain = "media_player";
              entity_id = "8c2d549c4466b588412890a6125fa10e";
              type = "is_off";
            }
            {
              condition = "device";
              device_id = "1c9343ec47f2b43cbded556b31b07835";
              domain = "media_player";
              entity_id = "8c2d549c4466b588412890a6125fa10e";
              type = "is_idle";
            }
          ];
        };
        action = [
          {
            type = "turn_off";
            device_id = "0a59149da57b9a25ea5c607b80a5c811";
            entity_id = "3d6b54f29d657c96185a25883e3a5715";
            domain = "switch";

          }
        ];
      }
    ];
  };
}# mode: single
