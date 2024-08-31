{
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 90;
          on-timeout = "hyprlock";
        }
        {
          timeout = 120;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # TODO: switch this to suspend-then-hibernate once you've setup swap
          timeout = 150;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
