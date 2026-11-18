{ pkgs, lib, config, ... }:
let
	profile = lib.types.submodule {
		options = {
			name = lib.mkOption {
				description = "Name of the instawow profile for this version";
				type = lib.types.strMatching "[A-Za-z0-9_]+";
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
				default = [];
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

  useTokenFile = cfg.tokenFiles.cfcore != null;

  # An attr to be set to xdg.configFile for main config
  mainConfigJson = json.generate "instawow-config.json" (
    {
      access_tokens = {
        inherit (cfg.tokens) cfcore github;
        wago_addons = cfg.tokens.wagoAddons;
      };
    }
    // cfg.extraConfig
  );

  # Only used when no secret file is set
  mainConfigAttr = {
    "instawow/config.json".source = mainConfigJson;
  };

  # Merges the secret into a real (non-store) config file at runtime
  renderConfig = pkgs.writeShellScript "instawow-render-config" ''
    set -eu
    umask 077
    dir="''${XDG_CONFIG_HOME:-$HOME/.config}/instawow"
    mkdir -p "$dir"
    tmp="$(mktemp "$dir/config.json.XXXXXX")"
    ${pkgs.jq}/bin/jq \
    --rawfile cfcore ${lib.escapeShellArg cfg.tokenFiles.cfcore} \
    '.access_tokens.cfcore = ($cfcore | rtrimstr("\n"))' \
    ${mainConfigJson} > "$tmp"
    mv -f "$tmp" "$dir/config.json"
  '';

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
			name = lib.join "/" ["instawow" "profiles" profile.name "config.json"];
			value = {source = profileToJson profileToConfig profile; };
		}) cfg.versions 
	);

	syncPackage = pkgs.callPackage ./pkg.nix {
			wowVersions = cfg.versions;
			instawow = cfg.package;
			# This should have a way to use only addons module
			bnetPrefix = battlenet.prefix;
	};	
	
	hasMainConfig =
	cfg.tokens.cfcore != null
		|| cfg.tokens.github != null
		|| cfg.tokens.wagoAddons != null
		|| cfg.extraConfig != { };
in
{
	options.programs.battlenet-umu.addons = {
		enable = lib.mkEnableOption "addon control through instawow";
		package = lib.mkOption {
			description = "Package of instawow to use to sync";
			type = lib.types.package;
			default = pkgs.instawow;
		};
    tokenFiles = lib.mkOption {
      description = "Paths to files holding API tokens";
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
      default = { };
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
		home.packages = [ syncPackage  cfg.package ];
		xdg.configFile = profileConfigsAttr // lib.optionalAttrs (hasMainConfig && !useTokenFile) mainConfigAttr ;
		
		systemd.user.services.wow-addon-sync = {
			Unit = {
				Description = "Sync WoW addons to the declared options on every boot";
				After = [ "network-online.target" ];
				Wants = [ "network-online.target" ];
			};

			Service = {	
				Type = "oneshot";
        ExecStartPre = lib.optional useTokenFile "${renderConfig}";
				ExecStart = map ( 
					profile: "${lib.getExe syncPackage} ${profile.name}" 
				) cfg.versions;
			};

			Install.WantedBy = [ "default.target" ];
		};
	};
}
