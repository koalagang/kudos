# TODO: shell integration
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Victor Mono:size=12";
        selection-target = "both";
      };
      # TODO: nix-colors
      colors = {
        foreground = "cdd6f4"; # base05 (foreground)
        background = "1e1e2e"; # base00 (background)
        regular0   = "181825"; # base01 (mantle) / black
        regular1   = "f38ba8"; # base08 (red)
        regular2   = "a6e3a1"; # base0B (green)
        regular3   = "f9e2af"; # base0A (yellow)
        regular4   = "89b4fa"; # base0D (blue)
        regular5   = "cba6f7"; # base0E (mauve) / (supposed to be magenta)
        regular6   = "94e2d5"; # base0C (teal) / (supposed to be cyan)
        regular7   = "f5e0dc"; # base06 (rosewater) / (supposed to be white)
        bright0    = "585b70"; # base04 (surface2) / bright black
        bright1    = "f38ba8"; # base0B (red)
        bright2    = "a6e3a1"; # base0B (green)
        bright3    = "f9e2af"; # base0A (yellow)
        bright4    = "89b4fa"; # base0D (blue)
        bright5    = "cba6f7"; # base0E (mauve) / (supposed to be magenta)
        bright6    = "94e2d5"; # base0C (teal) / (supposed to be cyan)
        bright7    = "f5e0dc"; # base06 (rosewater) / (supposed to be bright white)
        selection-foreground = "cdd6f4"; # base05 (foreground)
        selection-background = "585b70"; # base04 (surface2)
        search-box-no-match = "181825 f38ba8"; # base01 (mantle) / black + base08 (red)
        search-box-match = "cdd6f4 313244"; # base05 (foreground) + base02 (surface0)
        jump-labels = "181825 fab387"; # base01 (mantle) / black + base09 (peach)
        urls = "89b4fa"; # base0D (blue)
      };
      key-bindings = {
        scrollback-up-page = "Control+U";
        scrollback-up-line = "Control+K";
        scrollback-down-page = "Control+D";
        scrollback-down-line = "Control+J";
        scrollback-home = "Control+g";
        scrollback-end = "Control+G";
        search-start = "Control+slash";
        font-increase = "Control+equal";
        font-decrease = "Control+minus";
        show-urls-launch = "Control+O";
        show-urls-copy = "Control+L";
        show-urls-persistent = "Control+P";
        prompt-prev = "Control+Shift+z";
        prompt-next = "Control+Shift+x";
        unicode-input = "none";
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
