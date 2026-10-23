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
					git
					gh
					jujutsu
					ripgrep

          # Programming languages for neovim
          python3
          python3Packages.pip

          # nix
          nixfmt
        ];
      };
    };
}
