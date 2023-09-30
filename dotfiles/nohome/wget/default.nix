{ pkgs, config, ... }:

{
  home = {
    packages = [ pkgs.wget ];
    # prevents wget from dumping files into the home directory
    file."${config.xdg.configHome}/wget/wgetrc".text = ''
      hsts-file = "${config.xdg.cacheHome}/wget-hsts"
    '';
    sessionVariables.WGETRC = "${config.xdg.configHome}/wget/wgetrc";
  };
}
