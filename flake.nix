{
  description = "Ressources pédagogiques mpi-informatique/exercices";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.code-extract = {
    url = "github:mpi-informatique/typst-code-extract";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, code-extract }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      packagesFor = system: import nixpkgs { inherit system; };
      manifest = (builtins.fromTOML (builtins.readFile ./typst.toml)).package;
      source = nixpkgs.lib.cleanSourceWith {
        src = self;
        filter = path: type:
          let name = builtins.baseNameOf path; in
          !(builtins.elem name [ ".git" ".direnv" ".astro" "dist" "build" "tmp" "__pycache__" "node_modules" ".DS_Store" "web" "shared" ])
          && !(nixpkgs.lib.hasSuffix ".log" name);
      };
      dependencies = builtins.fromJSON (builtins.readFile ./nix/typst-packages.json);
    in {
      packages = forAllSystems (system:
        let
          pkgs = packagesFor system;
          package = pkgs.runCommand "exercices-typst-${manifest.version}" {
            nativeBuildInputs = [ pkgs.python3 ];
            TYPST_PACKAGE_PATH = code-extract.packages.${system}.default;
          } ''
            python3 ${source}/scripts/package.py --path "$out"
          '';
          previews = map (dependency: {
            name = "preview/${dependency.name}/${dependency.version}";
            path = pkgs.fetchzip {
              url = "https://packages.typst.org/preview/${dependency.name}-${dependency.version}.tar.gz";
              hash = dependency.hash;
              stripRoot = false;
            };
          }) (builtins.filter (dependency: (dependency.namespace or "preview") == "preview") dependencies);
        in {
          default = package;
          typst-package = package;
          typst-packages = pkgs.linkFarm "exercices-typst-packages" (previews ++ [{
            name = "local/code-extract/0.2.0";
            path = "${code-extract.packages.${system}.default}/local/code-extract/0.2.0";
          } {
            name = "mpi-informatique/${manifest.name}/${manifest.version}";
            path = "${package}/mpi-informatique/${manifest.name}/${manifest.version}";
          }]);
        });
      devShells = forAllSystems (system:
        let pkgs = packagesFor system; in {
          default = pkgs.mkShellNoCC {
            packages = [ pkgs.typst pkgs.just pkgs.python3 pkgs.ocaml pkgs.stdenv.cc pkgs.ripgrep ];
            TYPST_PACKAGE_PATH = self.packages.${system}.typst-packages;
            TYPST_FONT_PATHS = "${pkgs.newcomputermodern}/share/fonts";
          };
          web = pkgs.mkShellNoCC {
            packages = [ pkgs.nodejs_22 pkgs.typst pkgs.just pkgs.python3 pkgs.ripgrep pkgs.newcomputermodern pkgs.dejavu_fonts ];
            TYPST_PACKAGE_PATH = self.packages.${system}.typst-packages;
            TYPST_FONT_PATHS = "${pkgs.newcomputermodern}/share/fonts";
            EXERCICES_FONT_PATHS = "${pkgs.newcomputermodern}/share/fonts:${pkgs.dejavu_fonts}/share/fonts";
          };
        });
      checks = forAllSystems (system:
        let pkgs = packagesFor system; in {
          documents = pkgs.runCommand "exercices-check" {
            nativeBuildInputs = [ pkgs.typst pkgs.just pkgs.python3 pkgs.ocaml pkgs.stdenv.cc pkgs.git ];
            TYPST_PACKAGE_PATH = self.packages.${system}.typst-packages;
            TYPST_FONT_PATHS = "${pkgs.newcomputermodern}/share/fonts";
          } ''
            export HOME="$TMPDIR"
            cp -R ${source} source
            chmod -R u+w source
            cd source
            just check
            mkdir -p "$out"
            cp -R build/. "$out/"
          '';
        });
    };
}
