let
	pkgs = import <nixpkgs> {};
in
	pkgs.callPackage ./umu.nix {}
