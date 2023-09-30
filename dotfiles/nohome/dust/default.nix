{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.dust ];
    shellAliases.du = "dust";
  };
}
