{ config, ... }:

{
  # modified keyboard layout (see input part of settings)
  home.file."${config.xdg.configHome}/xkb/symbols/uk-no".source = ./uk-no;

  wayland.windowManager.hyprland.settings = {
    general = {
      # Doc: https://wiki.hyprland.org/Configuring/Variables/#general
      gaps_in = 2;
      gaps_out = 4;
      border_size = 2;
      "col.active_border" = "rgb(${config.colorScheme.palette.base0E})";
      "col.inactive_border" = "rgb(${config.colorScheme.palette.base03})";

      # as God intended it
      layout = "master";
    };

    input = {
      # Doc: https://wiki.hyprland.org/Configuring/Variables/#input
      kb_layout = "uk-no"; # uses an xkb file

      follow_mouse = 1;

      # mouse sensitivity
      sensitivity = 0.2; # -1.0 - 1.0, 0 means no modification.

      # make repeating keys by holding down faster (e.g. resizing windows)
      # equivalent to X's xset
      repeat_delay = 250;
      repeat_rate = 40;
    };

    # touchpad gestures
    # gestures = {
    #   workspace_swipe = true;
    #   workspace_swipe_forever = true;
    # };

    cursor = {
      # hide cursor after 3 seconds of inactivity
      # equivalent to X's unclutter
      inactive_timeout = 3;

      hide_on_key_press = true;
      hide_on_touch = true;

      no_warps = false;
      persistent_warps = true;
      warp_on_change_workspace = true;
    };
    env = "HYPRCURSOR_THEME,rose-pine-hyprcursor";

    decoration = {
      # Doc: https://wiki.hyprland.org/Configuring/Variables/#decoration

      # Use curved window corners
      rounding = 10;

      # Drop shadows are barely noticeable to me but they are taxing on the battery according to
      # https://wiki.hyprland.org/FAQ/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop
      drop_shadow = false;
      #shadow_range = 4
      #shadow_render_power = 3
      #col.shadow = rgba(1a1a1aee)

      # Blur is also apparently taxing on the battery but I enjoy it too much to disable
      blur = {
        enabled = true;
        size = 6;
        passes = 1;
        #xray = true # transparent floating windows expose the wallpaper (rather than showing windows behind)
        ignore_opacity = true; # creates an interesting effect
      };

      # Use no transparency on active windows
      active_opacity = 1;
      # but add a small amount to inactive windows
      inactive_opacity = 0.85;

      # add a very subtle dimming effect to inactive windows
      dim_inactive = true;
      dim_strength = 0.1;
    };

    animations = {
      # Doc: https://wiki.hyprland.org/Configuring/Animations/
      enabled = true;

      animation = [
        # I find that most of hyprland's default animations, with a delay level of 7, feel too sluggish.
        # However, delay level 1 feels so fast you may as well disable them at that point.
        # Delay level 2 is that sweet spot where it doesn't feel slow but you can enjoy it.
        "windows, 1, 2, default, popin"
        "windowsOut, 1, 2, default, popin"
        "workspaces, 1, 2, default, slide"

        # I believe the default here is 10.
        # 2 is too fast to see but 5 is just right
        "fade, 1, 5, default"

        # The only animation with good defaults
        "border, 1, 10, default"
      ];
    };

    master = {
      # Doc: https://wiki.hyprland.org/Configuring/Master-Layout/

      # Don't place windows in annoying positions
      new_status = "slave";
      new_on_top = false;

      mfact = 0.5; # master should use 50% of the screen

      # don't enable smart gaps (I think this is off by default anyway)
      no_gaps_when_only = 0;

      # I've got the default as left
      # but I also have bindings lower down to change the orientation
      orientation = "left";

      # TEST
      allow_small_split = true;
    };

    misc = {
      # Doc: https://wiki.hyprland.org/Configuring/Variables/#misc

      #disable_autoreload = true;

      # enable terminal window swallowing
      enable_swallow = true;
      swallow_regex = "^(footclient|foot)$";
      swallow_exception_regex = "^(noswallow)$";

      # decreases battery usage according to https://wiki.hyprland.org/0.37.0/configuring/performance/
      vfr = true;
    };
  };
}
