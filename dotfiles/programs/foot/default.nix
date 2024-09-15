{ config, ... }:

# TODO: shell integration
# see https://codeberg.org/dnkl/foot/wiki#shell-integration
# will probably contribute enableBashIntegration, enableZshIntegration and enableFishIntegration options to the homemanager module
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Victor Mono:size=12";
        selection-target = "both";
      };
      colors = {
        foreground = "${config.colorScheme.palette.base05}";
        background = "${config.colorScheme.palette.base00}";
        regular0   = "${config.colorScheme.palette.base01}";
        regular1   = "${config.colorScheme.palette.base08}";
        regular2   = "${config.colorScheme.palette.base0B}";
        regular3   = "${config.colorScheme.palette.base0A}";
        regular4   = "${config.colorScheme.palette.base0D}";
        regular5   = "${config.colorScheme.palette.base0E}";
        regular6   = "${config.colorScheme.palette.base0C}";
        regular7   = "${config.colorScheme.palette.base06}";
        bright0    = "${config.colorScheme.palette.base04}";
        bright1    = "${config.colorScheme.palette.base08}";
        bright2    = "${config.colorScheme.palette.base0B}";
        bright3    = "${config.colorScheme.palette.base0A}";
        bright4    = "${config.colorScheme.palette.base0D}";
        bright5    = "${config.colorScheme.palette.base0E}";
        bright6    = "${config.colorScheme.palette.base0C}";
        bright7    = "${config.colorScheme.palette.base06}";
        selection-foreground = "${config.colorScheme.palette.base05}";
        selection-background = "${config.colorScheme.palette.base04}";
        search-box-no-match = "${config.colorScheme.palette.base01} ${config.colorScheme.palette.base08}";
        search-box-match = "${config.colorScheme.palette.base05} ${config.colorScheme.palette.base02}";
        jump-labels = "${config.colorScheme.palette.base01} ${config.colorScheme.palette.base09}";
        urls = "${config.colorScheme.palette.base0D}";
      };
      key-bindings = {
        quit = "Control+Q";
        unicode-input = "none";
        scrollback-up-page = "Control+U";
        scrollback-up-line = "Control+K";
        scrollback-down-page = "Control+D";
        scrollback-down-line = "Control+J";
        scrollback-home = "Control+g";
        scrollback-end = "Control+G";
        search-start = "Control+slash";
        font-increase = "Control+equal";
        font-decrease = "Control+minus";
        # NOTE: opening URLs this way causes terminal swallowing
        show-urls-launch = "Control+O";
        show-urls-copy = "Control+L";
        show-urls-persistent = "Control+P";
        # NOTE: requires shell integration
        prompt-prev = "Control+Shift+z";
        prompt-next = "Control+Shift+x";
      };
      search-bindings = {
        find-prev = "Control+N";
        find-next = "Control+n";
        cursor-left = "Control+h Left";
        cursor-left-word = "Control+b Control+Left";
        cursor-right = "Control+l Right";
        cursor-right-word = "Control+w Control+Right";
        cursor-home = "Control+0";
        cursor-end = "Control+dollar";
        extend-to-word-boundary = "Control+Shift+Right";
      };
    };
  };
}
