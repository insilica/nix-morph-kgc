{
  description = "morph-kgc";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; };
      let
        inherit (poetry2nix.legacyPackages.${system})
          defaultPoetryOverrides mkPoetryApplication;
        morph-kgc-package = mkPoetryApplication {
          preferWheels = true;
          projectDir = self;
          overrides = defaultPoetryOverrides.extend (self: super: {
            jsonpath-python = super.jsonpath-python.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ])
                ++ [ python3Packages.setuptools ];
            });
          });
        };
        morph-kgc = stdenv.mkDerivation {
          name = "morph-kgc";
          src = ./bin;
          buildInputs = [ morph-kgc-package.dependencyEnv ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
          '';
        };
      in {
        packages = {
          inherit morph-kgc;
          default = morph-kgc;
        };
        devShells.default =
          mkShell { buildInputs = [ poetry2nix.packages.${system}.poetry ]; };
      });
}
