# nix-morph-kgc

[Nix](https://nixos.org) flake for [morph-kgc](https://github.com/morph-kgc/morph-kgc).


## Usage

Install with `nix profile install github:insilica/nix-morph-kgc`

Or run with `nix run github:insilica/nix-morph-kgc`

## Updating

- Update version and the morph-kgc version in pyproject.toml.
- Run `poetry install`
  - I used `docker run -ti --volume ~/src/nix-morph-kgc:/nix-morph-kgc fnndsc/python-poetry poetry install -C /nix-morph-kgc` to work around bugs in poetry (via dulwich). See https://github.com/python-poetry/poetry/issues/6873
- Test with `nix run` and `nix flake check`
