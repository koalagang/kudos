{ config, ... }:

{
  # make sure to add `security.pam.services.hyprlock = {};` to configuration.nix
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        grace = 3;
      };

      background = [ { path = "${config.xdg.userDirs.pictures}/wallpapers/catppuccin/sitting-cat.png"; } ];

      # TODO: nix-colors
      input-field = [{
        size = "300, 60";
        outline_thickness = 4;
        outer_color = "rgb(cba6f7)"; # base0E (mauve)
        inner_color = "rgb(1e1e2e)"; # base00 (background)
        font_color = "rgb(cdd6f4)"; # base05 (foreground)
        fade_on_empty = false;
        placeholder_text = "<span foreground=\"##cba6f7\">Please enter your password</span>";
        hide_input = true;
        check_color = "rgb(cba6f7)"; # base0E (mauve)
        fail_color = "rgb(f38ba8)"; # base08 (red)
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "rgb(f9e2af)"; # base0A (yellow)
        position = "0, -47";
        halign = "center";
        valign = "center";
      }];

      label = [
        { # layout
          text = "Layout: $LAYOUT";
          color = "rgb(cdd6f4)"; # base05 (foreground)
          font_size = 25;
          font_family = "Victor Mono";
          position = "30, -30";
          halign = "left";
          valign = "top";
        }
        { # time
          text = "$TIME";
          color = "rgb(cdd6f4)"; # base05 (foreground)
          font_size = 90;
          font_family = "Victor Mono";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        { # date
          text = "cmd[update:43200000] date +\"%A %d %B %Y\"";
          color = "rgb(cdd6f4)"; # base05 (foreground)
          font_size = 25;
          font_family = "Victor Mono";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
