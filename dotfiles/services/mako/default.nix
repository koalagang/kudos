{ config, ... }:

{
  services.mako = {
    enable = true;
    font = "Victor Mono 12";
    anchor = "top-center";
    borderRadius = 10;
    width = 200;
    defaultTimeout = 5000;
    borderSize = 2;
    backgroundColor= "#${config.colorScheme.palette.base00}";
    textColor = "#${config.colorScheme.palette.base05}";
    borderColor = "#${config.colorScheme.palette.base0E}";
    progressColor = "source #${config.colorScheme.palette.base02}";
    extraConfig = ''
      text-alignment=center
      history=1
      [urgency=high]
      border-color=#${config.colorScheme.palette.base09}
      # NOTE: this part must come *after* the colours for some reason
      # do not disturb
      [mode=dnd]
      invisible=1
    '';
  };
}

