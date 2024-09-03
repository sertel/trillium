{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }: let

    trillium = { lib, mkCoqDerivation, coq, stdpp, iris, paco }: mkCoqDerivation rec {
      pname = "tillium";
      propagatedBuildInputs = [ stdpp iris paco ];
      defaultVersion = "0.0.1";
      installPhase = ''
        runHook preInstall
        PREFIX=$out/lib/coq/${coq.coq-version}/user-contrib
        find trillium -name '*.vo*' | while read -r f; do
          d=''${f%/*}
          k=''${f##*/}
          if [ "$f" = "$d" ]; then d=. ; fi
          mkdir -p -- "$PREFIX/$d"
          cp -p -- "$f" "$PREFIX/$f"
        done
        runHook postInstall
      '';
      release."0.0.1" = {
        src = lib.const (lib.cleanSourceWith {
          src = lib.cleanSource ./.;
          filter = let inherit (lib) hasSuffix; in path: type:
            (! hasSuffix ".gitignore" path)
            && (! hasSuffix "flake.nix" path)
            && (! hasSuffix "flake.lock" path)
            && (! hasSuffix "_build" path);
        });
      };
    };

  in flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
    };
  in {
    devShells = {
      trillium = self.packages.${system}.trillium;
      default = self.packages.${system}.trillium;
    };

    packages = {
      trillium = pkgs.coqPackages_8_19.trillium;
      default = self.packages.${system}.trillium;
    };
  }) // {
    # NOTE: To use this flake, apply the following overlay to nixpkgs and use
    # the injected package from its respective coqPackages_VER attribute set!
    overlays.default = final: prev: let
      injectPkg = name: set:
        prev.${name}.overrideScope (self: _: {
          trillium = self.callPackage trillium {};
        });
    in (nixpkgs.lib.mapAttrs injectPkg {
      inherit (final) coqPackages_8_19;
    });
  };
}
