{ config, ... }:

{
  # most environmental variables are located in their respective files
  # these are the "misc" ones (i.e. ones without config files)
  home.sessionVariables = {
    CARGO_HOME="${config.xdg.dataHome}/cargo";
  };
}

