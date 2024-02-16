{ pkgs, config, ... }:

# A simple template for adding bash scripts to your nix config
# You can remove the above 'config' if you're not using any homemanager variables

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "foobar" ''
        ${pkgs.coreutils}/bin/echo 'hello world'
      '')
    ];
  };
}
