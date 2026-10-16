{pkgs, lib, config, ...}:
let
	game = lib.types.submodule{
		options = {
			name = lib.mkOption {
				description = "Name of the game installed";
				type = lib.types.str;
			};
			path = lib.mkOption {
				description = "Path to the executable within the prefix's C:/ drive";
				type = lib.types.str;
				default = "Program Files (x86)/Battle.net/Battle.net Launcher.exe"; 
			};
			proton = lib.mkOption {
				description = "The proton package used for the game";
				type = lib.types.package;
				default = pkgs.proton-ge-bin;
			};
		};
	};
	cfg = config.programs.battlenet-umu;
in
{
	options.programs.battlenet-umu = {
		enable = lib.mkEnableOption "umu-launcher for battle.net games";
		prefix = lib.mkOption {
			description = "Wine Prefix for the umu-launcher for your battle.net games";
			type = lib.types.path;
			default = "${config.xdg.dataHome}/battlenet-umu/prefix";
		};
		games = lib.mkOption {
			description = "A list of battle.net game definitions";
			type = lib.types.listOf game;
			default = [ { name = "Battle.net"; } ];
		};

	};
	config = lib.mkIf cfg.enable {
		home.packages = map (game:
			pkgs.callPackage ./pkg.nix {
				bnetPrefix = cfg.prefix;
				gamePath = game.path;
				gameName = game.name;
			}
		) cfg.games;
	};
}
