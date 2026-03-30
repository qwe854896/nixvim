{
  description = "Standalone Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvimModule = {
            inherit system;
            module = import ./config;
          };
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
        in
        {
          packages.default = nvim;
          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };
    };
}
