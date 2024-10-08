{
  # Window rules
  # Doc: https://wiki.hyprland.org/Configuring/Window-Rules/
  # Add extra transparency to foot (0.85 active, 0.75 inactive)
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "opacity 0.85 override 0.75 override,class:^(foot)$"
      "opacity 0.85 override 0.75 override,class:^(footclient)$"
      "opacity 0.85 override,class:^(foot_scratchpad)$"
      "opacity 0.95 override 0.85 override,class:^(org.pwmt.zathura)$"
      "workspace 2,noblur,nodim,class:^(firefox)$"
      "workspace 2,noblur,nodim,class:^(mullvadbrowser)$"
      "workspace 4, class:^(libreoffice-calc)$"
      "workspace 4, class:^(libreoffice-writer)$"
      "workspace 4, class:^(obsidian)$"
      "workspace 5, class:^(anki)$"
      "maximize, class:^(anki)$"
      "workspace 6, class:^(signal)$"
      "idleinhibit focus, class:^(mpv)$"
      # TODO: figure out how to idleinhibit whilst a command is running (e.g. nixos-rebuild)
    ];
  };
}
