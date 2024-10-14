{
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 120;
          on-timeout = "hyprlock";
        }
        {
          timeout = 150;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 180;
          # I've set the timer to be 1 minute via systemd-sleep (see the NixOS module).
          # This means that my system will first suspend and then hibernate 1 minute after it suspends.
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };
}
