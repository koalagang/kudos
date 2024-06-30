{ pkgs, config, ... }:

# I am currently using a lot of out of store symlinks during the initial configuration process.
# This is to make it easy to change the configurations without the need for rebuilding.
# I am also storing most of my wayland-related configs here temporarily.
# Once I've got wayland fully set up and ready to daily drive,
# I'll port all my configs to homemanager modules and store them in their own separate directories.

# Additionally, I'll switch from using the hyprland nixpkg to installing using flake+cachix

{
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  systemdIntegration = true;
  #};

  # temporary
  # I'll create separate configs later
  programs.foot = {
    enable = true;
    server.enable = true;
  };
  home.file."${config.xdg.configHome}/foot/foot.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/misc/hyprland/foot.ini";
  };

  # WORK IN PROGRESS (switching from waybar to eww)
  #programs.waybar = {
  #  enable = true;
  #  systemdIntegration.enable = true;
  #};
  #programs.eww = {
  #  enable = true;
  #  #configDir = ./config
  #};

  home.file."${config.xdg.configHome}/waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/misc/hyprland/waybar";
    recursive = true;
  };

  home.file."${config.xdg.configHome}/fuzzel/fuzzel.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/misc/hyprland/fuzzel.ini";
  };
  programs.fuzzel.enable = true; # TODO: switch to bemenu

  # TODO: switch to hyprlock
  # make sure to add `security.pam.services.swaylock = {};` to configuration.nix
  programs.swaylock.enable = true;

  # TODO: switch to hypridle
  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 120;
      command = "${pkgs.swaylock}/bin/swaylock";
    }];
  };

  home.file."${config.xdg.configHome}/mako/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/misc/hyprland/mako/config";
  };

  # hyprland has support for hot-reloading
  home.file."${config.xdg.configHome}/hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/misc/hyprland/hyprland.conf";
  };

  # modified keyboard layout
  home.file."${config.xdg.configHome}/xkb/symbols/uk-no".source = ./uk-no;

  home = {
    packages = with pkgs; [
      # I also have wlsunset configured with homemanager (see services/wlsunset)
      # but it doesn't seem to work
      # maybe because I'm not currently use hyprland's homemanager module?
      mako waybar eww brightnessctl wlsunset hdrop

      (writeShellScriptBin "eww-workspace" ''
        # pass input to hyprctl
        ${pkgs.hyprland}/bin/hyprctl dispatch "$@"

        # add yuck code to an array
        IFS=$'\n'
        widgets=('(box :class "widgets" :space-evenly true :halign "start"'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 1" "󰠱")'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 2" "󰈹")'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 3" "󰅩")'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 4" "󰦨")'
        '(button :class "workspace_inactive_star" :onclick "eww-workspace workspace 5" "")'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 6" "󰭹")'
        '(button :class "workspace_inactive" :onclick "eww-workspace workspace 7" "󰠱"))')

        # find which workspace is currently focused...
        focused="$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')"

        # ...and update the respective element in the widgets array
        widgets[$focused]="''${widgets[$focused]/inactive/focused}"

        # get all workspaces that have open windows...
        active=($(${pkgs.hyprland}/bin/hyprctl -j clients | \
          ${pkgs.jq}/bin/jq '.[] | .workspace.id' | ${pkgs.coreutils}/bin/sort -u))

        # ...and update the respective element in the widgets array
        # (excludes focused workspace because of previous commands)
        for i in "''${active[@]}"; do
            widgets[$i]="''${widgets[$i]/inactive/active}"
        done

        # now we can update the focused variable inside eww
        # this loads the yuck code stored within the widgets array
        ${pkgs.eww}/bin/eww update focused="$(${pkgs.coreutils}/bin/echo ''${widgets[@]} | ${pkgs.coreutils}/bin/tr -d '\n')"
      '')

      # toggle do not disturb mode
      (writeShellScriptBin "eww-dnd" ''
        if [[ "$(makoctl mode)" =~ 'do-not-disturb' ]]; then
            # disable
            makoctl mode -r do-not-disturb
            notify-send 'Do Not Disturb' 'disabled'
            #eww update dnd_class=':class "button_disabled"'
        else
            # enable
            notify-send 'Do Not Disturb' 'enabled'
            #sleep 4
            makoctl mode -a do-not-disturb
            #eww update dnd_class=':class "button_enabled"'
        fi
      '')
      ];
  };
}
