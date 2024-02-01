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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      Myla = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.dante = import ./home.nix;
              # pass inputs to home.nix so we can use firefox-addons
              # for programs.firefox.<profile>.extensions
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}
