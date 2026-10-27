{ pkgs, lib, config, ... }:
let
	profile = lib.types.submodule {
		options = {
			name = lib.mkOption {
				description = "Name of the instawow profile for this version";
				type = lib.types.strMatching "[A-Za-z0-9._-]+";
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
					(lib.types.strMatching 
						"(github|curse|tukui|wago|wowi):[^[:space:]]+");
				example = [ "github:sfx-wow/masque" ];
			};
			extraConfig = lib.mkOption {
				type = json.type; 
				default = {};
			};
		};
	};

	battlenet = config.programs.battlenet-umu;
	cfg = battlenet.addons;
	json = pkgs.formats.json {};

	# An attr to be set to xdg.configFile for main config
	mainConfigAttr = {
		"instawow/config.json".source = 
			json.generate "instawow-config.json" ({
			tokens = {
				inherit (cfg.tokens) cfcore github;
				wago_addons = cfg.tokens.wagoAddons;
			};
		}//cfg.extraConfig);
	};

	profileToConfig = profile: {
		profile = profile.name;
		addon_dir = lib.join "/" [ 
			battlenet.prefix
			"drive_c"
			profile.addonDir
		];
		flavour_override = profile.flavour;
	} // profile.extraConfig;

	profileToJson = configurator: profile: json.generate (
		lib.join "-" [profile.name "config.json" ]
	) (
		configurator profile
	);

	# An attr to be set to xdg.configFile for each profile in versions
	profileConfigsAttr = builtins.listToAttrs ( 
		map (profile: {
			name = lib.join "/" ["instawow" profile.name "config.json"];
			value = {source = profileToJson profileToConfig profile; };
		}) cfg.versions 
	);

	syncPackage = pkgs.callPackage ./pkg.nix {
			wowVersions = cfg.versions;
			instawow = cfg.package;
	};	
in
{
	options.programs.battlenet-umu.addons = {
		enable = lib.mkEnableOption "addon control through instawow";
		package = lib.mkOption {
			description = "Package of instawow to use to sync";
			type = lib.types.package;
			default = pkgs.instawow;
		};
		tokens = lib.mkOption {
			description = "API tokens for addon providers";
			type = lib.types.submodule {
				options = {
					cfcore = lib.mkOption {
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
					github = lib.mkOption {
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
					wagoAddons = lib.mkOption {
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
				};
			};
		};
		versions = lib.mkOption {
			description = "Descriptions of the different versions of WoW";
			type = lib.types.listOf profile;
		};
		extraConfig = lib.mkOption {
			type = json.type;
			default = {};
		};
	};

	config = lib.mkIf cfg.enable {
		home.packages = [ syncPackage ];
		xdg.configFile = mainConfigAttr // profileConfigsAttr;
		
		systemd.user.services.wow-addon-sync = {
			Unit = {
				Description = "Sync WoW addons to the declared options on every boot";
			};

			Service = {	
				Type = "oneshot";
				ExecStart = map ( 
					profile: syncPackage + " " + profile.name 
				) cfg.versions;
			};
		};
	};
}
