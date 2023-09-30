{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.du-dust ];
    shellAliases.du = "dust";
  };
}
