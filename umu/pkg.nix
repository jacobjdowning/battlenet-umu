{ writeShellApplication, curl, coreutils, umu-launcher, proton-ge-bin, lib, makeDesktopItem, symlinkJoin, xdg-terminal-exec,
	bnetPrefix ? "TestGames/battlenet",
	gamePath ? "Program Files (x86)/Battle.net/Battle.net Launcher.exe",	
	gameName ? "Battle.net",
	launchArgs ? ""
}:
let
	lowerName = lib.toLower gameName;
	nameList = builtins.filter builtins.isString (builtins.split "[^a-z]+" lowerName);
	scriptName = lib.concatStringsSep "-" (nameList ++ ["umu"]);

	script = writeShellApplication {
		name = scriptName; 
		runtimeInputs = [ 
			umu-launcher
			curl
			coreutils
			xdg-terminal-exec
		];
		runtimeEnv = {
			GAMEID = "umu-default";
			PROTONPATH = "${proton-ge-bin.steamcompattool}";
			BNET_PREFIX = bnetPrefix;
			BNET_PATH = "Program Files (x86)/Battle.net/Battle.net Launcher.exe";
			WIN_PATH = gamePath;
			LAUNCH_ARGS = launchArgs;
		};
		text = builtins.readFile ./bnet-umu.sh;
	};	
	desktopItem = makeDesktopItem{
		name = scriptName;
		desktopName = gameName;
		exec = lib.getExe script;
		terminal = false;
		categories = [ "Game" ];

	};
in
	symlinkJoin{
		name = scriptName;
		paths = [ script desktopItem ];
		meta.mainProgram = scriptName;
	}
