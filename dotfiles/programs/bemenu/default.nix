{ config, ... }:

{
  programs.bemenu = {
    enable = true;
    settings = {
      fb  = "#${config.colorScheme.palette.base00}";
      ff  = "#${config.colorScheme.palette.base05}";
      nb  = "#${config.colorScheme.palette.base00}";
      nf  = "#${config.colorScheme.palette.base05}";
      tb  = "#${config.colorScheme.palette.base00}";
      hb  = "#${config.colorScheme.palette.base00}";
      tf  = "#${config.colorScheme.palette.base0E}";
      hf  = "#${config.colorScheme.palette.base0B}";
      af  = "#${config.colorScheme.palette.base05}";
      ab  = "#${config.colorScheme.palette.base00}";
      bdr = "#${config.colorScheme.palette.base0E}";
      fn = 12;
      line-height = 40;
      border = 2;
      border-radius = 10;
    };
  };
}
