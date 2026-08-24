{
  inputs = {
    nixos-24-11.url           = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-darwin-24-11.url  = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixos-25-11.url           = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin-25-11.url  = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixos-stable.url          = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url      = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin-stable.url                    = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin-stable.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    home-manager-darwin.url                    = "github:nix-community/home-manager";
    home-manager-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    home-manager-linux.url                     = "github:nix-community/home-manager";
    home-manager-linux.inputs.nixpkgs.follows  = "nixos-stable";

    nix-homebrew.url          = "github:zhaofengli/nix-homebrew";
    homebrew-core.url         = "github:homebrew/homebrew-core";
    homebrew-core.flake       = false;
    homebrew-cask.url         = "github:homebrew/homebrew-cask";
    homebrew-cask.flake       = false;
  };
  outputs = inputs@{...}: {
    inherit inputs;
  };
}
