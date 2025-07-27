{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --time-format '%I:%M %p | %a • %h | %F'";
        user = "greeter";
      };
    };
    vt = 2;
  };

  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
}
