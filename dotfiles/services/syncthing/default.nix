{ config, ... }:

{
  services.syncthing = {
    enable = true;
    # override devices and folders not created through nix (to avoid accidentally making imperative changes)
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      gui = {
        user = "dante";
        # unfortunately, there is no hashed password file option
        # so making the hash public will have to suffice for now
        # see https://github.com/NixOS/nixpkgs/issues/85336
        # EDIT: syncthing.passwordFile?
        password = "$2b$05$F0sou.ZtPZMvwshtUbHES.6yAPlEVQWvgInBqIvuzzHa14BK0fgca";
      };
      options.urAccepted = -1; # refuse analytics
      devices."android".id = "L3V37H7-NQVSFHO-SJJZHVH-LOWUX5W-6VSMAVQ-UVS7XH2-NPRXIOO-D2JWCQH";
      folders = {
        # path on Android device to sync from (excludes the /storage/emulated/0/ prefix)
        "DCIM/Camera" = {
          path = "${config.xdg.userDirs.pictures}/android/camera"; # path on local NixOS device to sync to
          devices = [ "android" ];
          ignorePerms = true;
          versioning = {
            type = "simple";
            params = {
              keep = "10";
            };
          };
        };
        "Pictures" = {
          path = "${config.xdg.userDirs.pictures}/android/pictures";
          devices = [ "android" ];
          ignorePerms = true;
          versioning = {
            type = "simple";
            params = {
              keep = "10";
            };
          };
        };
        "Download" = {
          path = "${config.xdg.userDirs.pictures}/android/download";
          devices = [ "android" ];
          ignorePerms = true;
          versioning = {
            type = "simple";
            params = {
              keep = "10";
            };
          };
        };
        "KeePass" = {
          path = "${config.xdg.userDirs.desktop}/keepass";
          devices = [ "android" ];
          ignorePerms = true;
          versioning = {
            type = "simple";
            params = {
              keep = "10";
            };
          };
        };
        "Documents" = {
          path = "${config.xdg.userDirs.documents}";
          devices = [ "android" ];
          ignorePerms = true;
          versioning = {
            type = "simple";
            params = {
              keep = "10";
            };
          };
        };
      };
    };
  };

  home = {
    sessionVariables.STNODEFAULTFOLDER = "true"; # don't create default ~/Sync folder
    persistence."/persist/nocow/home/dante".directories = [ ".local/state/syncthing" ]; # persist data
  };
}
