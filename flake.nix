{
  description = "Gaming on Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/9099616b93301d5cf84274b184a3a5ec69e94e08";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake.nixosModules = let
        inherit (inputs.nixpkgs) lib;
      in {
        pipewireLowLatency = import ./modules/pipewireLowLatency.nix;
        steamCompat = import ./modules/steamCompat.nix;
        default = throw (lib.mdDoc ''
          The usage of default module is deprecated as multiple modules are provided by nix-gaming. Please use
          the exact name of the module you would like to use. Available modules are:

          ${builtins.concatStringsSep "\n" (lib.filter (name: name != "default") (lib.attrNames self.nixosModules))}
        '');
      };

      imports = [
        ./lib
        ./pkgs
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };

}
