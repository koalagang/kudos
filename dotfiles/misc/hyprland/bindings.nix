{ pkgs, config, ... }:

{
  # I wrote this script to allow me to change the volume
  # but without ever going above 100% because that distorts the sound.
  # You can find the keybinds to this script further down.
  home.packages = with pkgs; [
    (writeShellScriptBin "hyprland-wpctl" ''
      if [[ "$1" == 'toggle' ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      else
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"
      fi

      # never go above 100%
      [ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2 | tr -d '.')" -gt 100 ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
    '')
  ];

  wayland.windowManager.hyprland = {
    settings = {
      # Modifiers
      # Doc: https://wiki.hyprland.org/Configuring/Keywords/
      "$mainMod" = "SUPER";
      "$moveMod" = "$mainMod_SHIFT";
      "$operationMod" = "$mainMod_CTRL";
      "$appLaunchMod" = "$mainMod_ALT";
      "$powerMod" = "CTRL_ALT";

      # --- General bindings
      # Doc: https://wiki.hyprland.org/Configuring/Binds/
      # NOTE: hyprland's default bindings are gross *vomiting emoji*

      bind = [
        # Basic bindings
        "$mainMod, Return, exec, ${pkgs.foot}/bin/footclient"
        "$operationMod, Return, exec, ${pkgs.foot}/bin/foot" # in case the server crashes
        "$appLaunchMod, Return, exec, ${pkgs.foot}/bin/foot -a noswallow" # no window swallowing
        "$operationMod, Semicolon, exec, eww-layout killactive"
        "$operationMod, q, exit"
        "$mainMod, f, exec, eww-layout togglefloating"
        "$operationMod, f, fullscreen,0" # real fullscreen
        "$mainMod, Tab, exec, eww-layout 'fullscreen 1'"

        # graphical apps
        "$appLaunchMod, i, exec, notify-send 'Launching Anki' && ${pkgs.anki}/bin/anki &"
        "$appLaunchMod, k, exec, notify-send 'Launching KeepassXC' && ${pkgs.keepassxc}/bin/keepassxc &"
        "$appLaunchMod, p, exec, notify-send 'Launching Signal' && ${pkgs.signal-desktop}/bin/signal-desktop &"
        "$appLaunchMod, b, exec, notify-send \"Launching ${config.home.sessionVariables.BROWSER}\" && ${config.home.sessionVariables.BROWSER} &"
        "$appLaunchMod, o, exec, notify-send 'Launching Obsidian' && ${pkgs.obsidian}/bin/obsidian --features=UseOzonePlatform --ozone-platform=wayland &"
        "$mainMod, t, exec, ${pkgs.hdrop}/bin/hdrop -f -g 58 --width 98 --height 91 foot -a foot_scratchpad"
        # temporary
        "$appLaunchMod, m, exec, notify-send 'Launching Mullvad' && mullvad-browser &"
        "$appLaunchMod, u, exec, notify-send 'Launching Chromium' && chromium &"

        # Power state
        "$powerMod, p, exec, shutdown now"
        "$powerMod, r, exec, reboot"
        "$powerMod, s, exec, systemctl suspend"
        "$powerMod, l, exec, hyprlock"

        # Quoting from the Hyprland Wiki:
        # using two hashes because this escapes the hash
        "$mainMod, backslash, exec, ${pkgs.bemenu}/bin/bemenu-run -B 2 -R 10 -l 10 -c --fixed-height -W 0.2 --fn 18 -p '❯' -f --fb '##1e1e2eD9' --ff '##cdd6f4D9' --nb '##1e1e2eD9' --nf '##cdd6f4D9' --tb '##1e1e2eD9' --hb '##1e1e2eD9' --tf '##f38ba8D9' --hf '##f9e2afD9' --af '##cdd6f4D9' --ab '##1e1e2eD9' --bdr '##f38ba8D9'"

        # --- Manipulating the master layout

        # focus master
        "$mainMod, SPACE, layoutmsg, focusmaster master"

        # swap the currently active window with the master window
        "$moveMod, SPACE, layoutmsg, swapwithmaster master"

        # increment/decrement the master
        "$operationMod, i, layoutmsg, addmaster"
        "$operationMod, o, layoutmsg, removemaster"

        # change the orientation of the master layout
        "$operationMod, left, layoutmsg, orientationleft master"
        "$operationMod, up,   layoutmsg, orientationtop master"
        "$operationMod, down, layoutmsg, orientationbottom master"
        "$operationMod, right,layoutmsg, orientationright master"

        # add or remove a window from the master
        "$mainMod, apostrophe, layoutmsg, addmaster"
        "$mainMod, numbersign, layoutmsg, removemaster"

        # Move focus with mainMod + vi keys
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"

        # --- WORKSPACES
        # Doc: https://wiki.hyprland.org/Configuring/Workspace-Rules/

        # Most people tend to use numbers
        # but I use the letters zxcvbnm because they're the letters along the bottom of the QWERTY layout,
        # making them very easy to access.

        # Switch workspaces
        "$mainMod, z, exec, eww-workspace workspace 1"
        "$mainMod, x, exec, eww-workspace workspace 2"
        "$mainMod, c, exec, eww-workspace workspace 3"
        "$mainMod, v, exec, eww-workspace workspace 4"
        "$mainMod, b, exec, eww-workspace workspace 5"
        "$mainMod, n, exec, eww-workspace workspace 6"
        "$mainMod, m, exec, eww-workspace workspace 7"
        "$mainMod, Period, exec, eww-workspace workspace e+1"
        "$mainMod, Comma, exec, eww-workspace workspace e-1"

        # Move active window to a workspace but do not follow the window
        "$moveMod, z, exec, eww-workspace movetoworkspace 1"
        "$moveMod, x, exec, eww-workspace movetoworkspace 2"
        "$moveMod, c, exec, eww-workspace movetoworkspace 3"
        "$moveMod, v, exec, eww-workspace movetoworkspace 4"
        "$moveMod, b, exec, eww-workspace movetoworkspace 5"
        "$moveMod, n, exec, eww-workspace movetoworkspace 6"
        "$moveMod, m, exec, eww-workspace movetoworkspace 7"
        "$moveMod, Period, exec, eww-workspace movetoworkspace e+1"
        "$moveMod, Comma, exec, eww-workspace movetoworkspace e-1"

        # Move active window to a workspace and follow the window
        "$operationMod, z, exec, eww-workspace movetoworkspacesilent 1"
        "$operationMod, x, exec, eww-workspace movetoworkspacesilent 2"
        "$operationMod, c, exec, eww-workspace movetoworkspacesilent 3"
        "$operationMod, v, exec, eww-workspace movetoworkspacesilent 4"
        "$operationMod, b, exec, eww-workspace movetoworkspacesilent 5"
        "$operationMod, n, exec, eww-workspace movetoworkspacesilent 6"
        "$operationMod, m, exec, eww-workspace movetoworkspacesilent 7"
        "$operationMod, Period, exec, eww-workspace movetoworkspacesilent e+1"
        "$operationMod, Comma, exec, eww-workspace movetoworkspacesilent e-1"

        # -- Manipulating windows

        # Move windows with moveMod + shift + vi keys
        "$moveMod, h, movewindow, l"
        "$moveMod, j, movewindow, d"
        "$moveMod, k, movewindow, u"
        "$moveMod, l, movewindow, r"
      ];

      bindm = [
        # Move windows with mainMod + LMB and dragging (my preferred method for floating windows)
        "$mainMod, mouse:272, movewindow"
        # Resize windows with with mainMod + RMB and dragging (my preferred method for floating windows)
        "$mainMod, mouse:273, resizewindow"
      ];

      binde =[
        # Resize windows with $operationMod + ctrl + vi keys
        "$operationMod, h, resizeactive, -50 0"
        "$operationMod, j, resizeactive, 0 50"
        "$operationMod, k, resizeactive, 0 -50"
        "$operationMod, l, resizeactive, 50 0"
      ];
    };

    extraConfig = ''
      # Volume controls
      binde =, XF86AudioRaiseVolume, exec, hyprland-wpctl 5+
      binde =, XF86AudioLowerVolume, exec, hyprland-wpctl 5%-
      bind  =, XF86AudioMute, exec, hyprland-wpctl toggle

      # ======= DMENU SUBAMP ========
      # dmenu scripts
      # Doc: https://wiki.hyprland.org/Configuring/Binds/#submaps
      # I'm essentially using this as a hack to create keychords.
      # Credits for figuring out this trick https://github.com/sadiksaifi/dotfiles/tree/main/.config/hypr#application-keybindings

      # ------- DO NOT REMOVE -------
      bind = $mainMod,d,submap,dmenu
      submap = dmenu
      # -----------------------------

      # scripts here

      bind=,p,exec,colourmenu
      bind=,p,submap,reset

      bind=,e,exec,emojimenu
      bind=,e,submap,reset

      bind=,k,exec,killmenu
      bind=,k,submap,reset

      bind=,r,exec,radiomenu
      bind=,r,submap,reset

      bind=,s,exec,screenmenu
      bind=,s,submap,reset

      bind=,t,exec,transmenu
      bind=,t,submap,reset

      bind=,y,exec,ytmenu
      bind=,y,submap,reset

      # ------- DO NOT REMOVE -------
      # use escape if you somehow get stuck in the submap (pun not intended)
      bind=,escape,submap,reset
      submap = reset
      # ----------------------------
      # ============================
    '';
  };
}