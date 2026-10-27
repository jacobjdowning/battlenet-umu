{
	description = "A Home Manager module for battle.net including addons";

	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	inputs.instawow = {
		url = "github:layday/instawow/v7.3.0";
		#inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, instawow, ...}: {
		home-manager.extraSpecialArgs = { instawow = instawow.package; };
		homeModules = {
			battlenet = ./umu/module.nix; 
			addons = ./addons/module.nix;
			default = {pkgs, lib, ...}:
			let
				# instawow uses a python tool called versioningit
				# that only works when the source has a git history
				# or is already an sdist, so here I replace the sourc
				# with the source from PyPi that will be the official
				# sdist
				# I can remove all of this when nixpkgs is updated to
				# a version that supports WoW:Forever
				package = instawow.packages.x86_64-linux.instawow.overridePythonAttrs(old: {
					src = pkgs.fetchPypi {
						pname = "instawow";
						version = "7.3.0";
						hash = "sha256-ZB+FuMf5oJVRAtsinhFa6NQH5FvInpfnTlchsrVbgA8=";
					};
				});
			in
			{
				imports = [
					self.homeModules.battlenet
					self.homeModules.addons
				];
				programs.battlenet-umu.addons.package = 
					lib.mkDefault package;
			};
		};
	};
}
