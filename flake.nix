#  \##|   |
###\\ |   |
#   \\|   \'---'/   Gabriel (@koalagang)
#    \   _'.'O'.'   https://github.com/koalagang
#     | :___   \
#     |  _| :  |
#     | :__,___/
#     |   |
#     |   |
#     |   |
{
  description = "Koala's Unified and Declarative Operating System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprcursor theme
    # make sure to add `inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default` to your packages
    # and add `env = HYPRCURSOR_THEME,rose-pine-hyprcursor` to hyprland.conf
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
  };

  outputs = inputs@{ self, nixos-hardware, nixpkgs, home-manager, ... }: {
    # install script
    # this enables us to deploy the configuration onto a new system using a single-command install:
    # nix run github:koalagang/kudos --no-write-lock-file
    packages.x86_64-linux.install = with nixpkgs.legacyPackages.x86_64-linux; stdenv.mkDerivation {
      pname = "install";
      version = "1.0";
      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;
      src = ./.;
      buildInputs = [
        git
        coreutils
        diffutils
        mkpasswd
        toybox
      ];
      buildPhase = ''
        mkdir -p $out/bin
        cp install.sh $out/bin/install
        chmod +x $out/bin/install
      '';
    };
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.install;
    apps.x86_64-linux.default = {
      type = "app";
      program = "${self.packages.x86_64-linux.install}/bin/install";
    };

    # the actual configuration that is used when running nixos-install or nixos-rebuild
    nixosConfigurations = {
      Myla = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd # addresses some hardware quirks
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.dante = import ./home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}
