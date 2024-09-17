{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      # Doc: https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",preferred,auto,auto";

      # Execute your favorite apps at launch
      # Doc: https://wiki.hyprland.org/Configuring/Keywords/
      exec-once = [
        # should hopefully not be necessary to put here after I port these configs (cuz of systemd integration)
        "${pkgs.wbg}/bin/wbg \"$(${pkgs.findutils}/bin/find ${config.xdg.userDirs.pictures}/wallpapers/catppuccin -type f | ${pkgs.coreutils}/bin/shuf -n 1)\" &"
        "${pkgs.eww}/bin/eww open bar &"

        # Provides power notifcations, such as when the battery is at warning level or critical level
        # (defined using upower), as well as notifying you when you've plugged in or unplugged your charger
        "${pkgs.poweralertd}/bin/poweralertd &"

        "taskdue"
      ];
    };
  };

  imports = [
    ./bindings.nix
    ./rules.nix
    ./settings.nix
  ];
}
