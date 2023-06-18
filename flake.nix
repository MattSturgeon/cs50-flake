{
  description = "cs50 dev environment";

  nixConfig.bash-prompt = "[cs50:\\w]\\$ ";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # TODO add cs50 packages in an overlay
          ];
        };
        python-with-packages = (pkgs.python310.withPackages (ps:
          [
            ps.numpy # Example
            # TODO check50, style50, submit50, lib50
          ]));
        mkShell = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; };
      in rec {

        devShells.default = mkShell {
          name = "cs50 dev environment";

          packages = with pkgs; [
            wget
            unzip
            tree
            git
            python-with-packages
            libcs50
          ];

          shellHook = ''
            echo "This is CS50"

            # A helper function to download and open a zip file
            # useful for many CS50 psets
            get_zip() {
                if test $# -ne 1; then
                    echo "Usage: get_zip url"
                    return 1
                fi

                url="$1"
                zip="$(basename $url)"
                dir="''${zip%.zip}"

                wget "$url" && unzip "$zip" \
                && rm -f "$zip" \
                && "$dir"
            }
          '';
        };
      });
}
