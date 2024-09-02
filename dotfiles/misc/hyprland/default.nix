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

        # TODO: make wlsunset, hypridle and foot server run on startup via systemd
        "wlsunset -t 2500K -T 6500 -S 06:00 -s 19:00 &"
        "hypridle &"

        # "taskdue"
      ];
    };
  };

  imports = [
    ./bindings.nix
    ./rules.nix
    ./settings.nix
  ];
}
