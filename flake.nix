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

      tools = with pkgs; [
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
        lazyjj

        # Programming languages for neovim
        python3
        python3Packages.pip

        # nix
        nixfmt
      ];
    in
    {
      # Environnement utilisateur : nix profile install ~/.config/nvim
      packages.${system}.default = pkgs.buildEnv {
        name = "nvim-env";
        paths = tools;
      };

      # Shell ponctuel : nix develop ~/.config/nvim
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = tools;
      };
    };
}
