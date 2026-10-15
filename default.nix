{pkgs, ...}:
let
	pkg = pkgs.callPackage ./pkg.nix {
		gamePath = "Program Files (x86)/World of Warcraft/_classic_era_/WowClassic.exe";
		gameName = "WoW Classic";
	};
in
{
	home.packages = [ pkg ];
}
