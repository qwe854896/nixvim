{
  description = "Minimal standalone Nixvim starter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixvim, ... }:
    let
      system = "x86_64-linux";
      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit system;
        module = import ./config;
      };
    in
    {
      packages.${system}.default = nvim;
    };
}
