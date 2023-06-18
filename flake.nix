{
  description = "cs50 dev environment";

  nixConfig.bash-prompt = "[cs50:\\w]\\$ ";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
      self,
      nixpkgs
  }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;
    in {
      packages.x86_64-linux.default = pkgs.mkShell {
        name = "cs50 dev environment";
        packages = [
          pkgs.wget
	  pkgs.unzip
	  pkgs.tree
	  pkgs.git
          pkgs.python310
	  pkgs.libcs50
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
    };
}
