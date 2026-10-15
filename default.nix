let
	pkgs = import <nixpkgs> {};
in
	pkgs.callPackage ./pkg.nix {
		gamePath = "Program Files (x86)/World of Warcraft/_classic_era_/WoWClassic.exe";
	}
