{ lib, ... }:
let
	profile = lib.types.submodule {
		options = {
			name = lib.mkOption {
				description = "Name of the instawow profile for this version";
				type = lib.types.str;
			};
			addonDir = lib.mkOption {
				description = "Path to the Addons folder within the prefix's C:/ drive";
				type = lib.types.str;
			};
			flavour = lib.mkOption {
				description = "The version of WoW these addons are for";
				type = lib.types.enum [
					"mainline"
					"vanilla_classic"
					"forever_classic"
					"tbc_classic"
					"wrath_classic"
					"titan_classic"
					"cata_classic"
					"mists_classic"
				];
			};
			addons = lib.mkOption {
				description = "A list of addons for this version";
				type = lib.types.listOf 
					lib.types.strMatching 
						"(github|curse|tukui|wago|wowi)\\:.+";
				example = [ "github:sfx-wow/masque" ];
			};
			extraConfig = lib.mkOption {
				type = lib.type.attrs;
			};
		};
	};
						
in
{
	options.programs.battlenet-umu.addons = {
		enable = lib.mkEnableOption "addon control through instawow";
		tokens = lib.mkOption {
			description = "API tokens for addon providers";
			type = lib.types.submodule {
				options = {
					cfcore = lib.mkOption {
						type = lib.types.str;
					};
					github = lib.mkOption {
						type = lib.types.str;
					};
					wagoAddons = lib.mkOption {
						type = lib.types.str;
					};
				};
			};
		};
		versions = lib.mkOption {
			description = "Descriptions of the different versions of WoW";
			type = lib.types.listOf profile;
		};
		extraConfig = lib.mkOption {
			type = lib.type.attrs;
		};
	};
}
