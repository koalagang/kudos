{ pkgs, config, ... }:

# Archive given file

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "arc" ''
        archive="${config.xdg.userDirs.documents}/archive/$(${pkgs.coreutils}/bin/date -r "$1" +%Y-%m-%d)"
        ${pkgs.coreutils}/bin/mkdir -p "$archive" && ${pkgs.coreutils}/bin/mv "$1" "$archive"
      '')
    ];
  };
}
