{
  description = "Neovim development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Alternative: development shell (recommended)
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          neovim

          # Neovim dependencies
          deno
          tree-sitter
          luajitPackages.luarocks
          imagemagick
          ghostscript
          tectonic
          mermaid-cli
          fd
          lua5_1

          # Programming languages for neovim
          go
          ruby
          php
          julia
          zulu
          python3
          python3Packages.pip
          php84Packages.composer
        ];
      };
    };
}
