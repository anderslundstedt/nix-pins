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

    home-manager-darwin-stable.url                    = "github:nix-community/home-manager/release-26.05";
    home-manager-darwin-stable.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    home-manager-linux-stable.url                     = "github:nix-community/home-manager/release-26.05";
    home-manager-linux-stable.inputs.nixpkgs.follows  = "nixos-stable";

    nix-homebrew.url    = "github:zhaofengli/nix-homebrew";
    homebrew-core.url   = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url   = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    nix-auto-follow-darwin.url = "github:fzakaria/nix-auto-follow";
    nix-auto-follow-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    nix-auto-follow-linux.url = "github:fzakaria/nix-auto-follow";
    nix-auto-follow-linux.inputs.nixpkgs.follows = "nixos-stable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{...}:
    {inherit inputs;}
    //
    inputs.flake-utils.lib.eachSystem
      (
        builtins.filter
          (s: s != "x86_64-darwin") inputs.flake-utils.lib.defaultSystems
      )
      (system:
        let
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
          get-output    = (output-linux: output-darwin:
            if      inputs.nixpkgs-unstable.lib.hasSuffix "linux"  system then
              output-linux
            else if inputs.nixpkgs-unstable.lib.hasSuffix "darwin" system then
              output-darwin
            else
              throw "neither Linux nor Darwin"
          );
        in rec {
          nixpkgs-24-11       = get-output
            inputs.nixos-24-11 inputs.nixpkgs-darwin-24-11;
          nixpkgs-25-11       = get-output
            inputs.nixos-25-11 inputs.nixpkgs-darwin-25-11;
          nixpkgs-stable      = get-output
            inputs.nixos-stable inputs.nixpkgs-darwin-stable;
          home-manager-stable = get-output
            inputs.home-manager-linux-stable inputs.home-manager-darwin-stable;
          nix-auto-follow     = get-output
            inputs.nix-auto-follow-linux inputs.nix-auto-follow-darwin;

          checks.run-auto-follow = pkgs-unstable.runCommand
            "check-auto-follow"
            {nativeBuildInputs = [nix-auto-follow.packages.${system}.default];}
            ''
            auto-follow --check ${./flake.lock}
            touch $out
            '';

          devShells.default = pkgs-unstable.mkShell {
            buildInputs = [
              pkgs-unstable.gnumake
            ];
          };
        }
      );
}
