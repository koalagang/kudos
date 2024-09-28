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

      # change the background and avatar if you change theme
      background = [ { path = "${config.xdg.userDirs.pictures}/backgrounds/other/catppuccin/sitting-cat.png"; } ];
      # user avatar
      image = [{
        path = "${config.xdg.userDirs.pictures}/backgrounds/other/face.png";
        size = 100;
        border_color = "${config.colorScheme.palette.base0E}";
        position = "0, 75";
        halign = "center";
        valign = "center";
      }];

      input-field = [{
        size = "300, 60";
        outline_thickness = 4;
        outer_color = "rgb(${config.colorScheme.palette.base0E})";
        inner_color = "rgb(${config.colorScheme.palette.base00})";
        font_color = "rgb(${config.colorScheme.palette.base05})";
        fade_on_empty = false;
        placeholder_text = "<span foreground=\"##${config.colorScheme.palette.base0E}\">Please enter your password</span>";
        hide_input = false;
        check_color = "rgb(${config.colorScheme.palette.base0E})";
        fail_color = "rgb(${config.colorScheme.palette.base08})";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "rgb(${config.colorScheme.palette.base0A})";
        position = "0, -47";
        halign = "center";
        valign = "center";
      }];

      label = [
        { # layout
          text = "Layout: $LAYOUT";
          color = "rgb(${config.colorScheme.palette.base05})";
          font_size = 25;
          font_family = "Victor Mono";
          position = "30, -30";
          halign = "left";
          valign = "top";
        }
        { # time
          text = "$TIME";
          color = "rgb(${config.colorScheme.palette.base05})";
          font_size = 90;
          font_family = "Victor Mono";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        { # date
          text = "cmd[update:43200000] date +\"%A %d %B %Y\"";
          color = "rgb(${config.colorScheme.palette.base05})";
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
