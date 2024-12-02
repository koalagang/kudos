{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      # Doc: https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",preferred,auto,auto";

      # Execute commands at launch
      # Doc: https://wiki.hyprland.org/Configuring/Keywords/
      exec-once = [
        # set random catppuccin wallpaper
        "${pkgs.swaybg}/bin/swaybg --mode fill --image \"$(${pkgs.findutils}/bin/find ${config.xdg.userDirs.pictures}/backgrounds/wallpapers/catppuccin -type f | ${pkgs.coreutils}/bin/shuf -n 1)\" &"

        # launch bar
        "${pkgs.eww}/bin/eww open bar &"

        # Provides power notifcations, such as when the battery is at warning level or critical level
        # (defined using upower), as well as notifying you when you've plugged in or unplugged your charger
        "${pkgs.poweralertd}/bin/poweralertd &"

        # notify me of any upcoming tasks
        # "taskdue"

        # notify me of any events today
        "${pkgs.remind}/bin/remind ${config.xdg.userDirs.documents}/remind.rem"
      ];
    };
  };

  imports = [
    ./bindings.nix
    ./rules.nix
    ./settings.nix
  ];
}
