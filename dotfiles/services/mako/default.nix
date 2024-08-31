{
  services.mako = {
    enable = true;
    font = "Victor Mono 12";
    anchor = "top-center";
    borderRadius = 10;
    width = 200;
    defaultTimeout = 5000;
    borderSize = 2;
    # TODO: nix-colors
    # base00 (background)
    backgroundColor= "#1e1e2e";
    # base05 (foreground)
    textColor = "#cdd6f4";
    # base0E (mauve)
    borderColor = "#cba6f7";
    # base02 (surface0)
    progressColor = "source #313244";
    extraConfig = ''
      text-alignment=center
      history=1
      # base09 (peach)
      [urgency=high]
      border-color=#fab387
      # NOTE: this part must come *after* the colours for some reason
      # do not disturb
      [mode=dnd]
      invisible=1
    '';
  };
}

