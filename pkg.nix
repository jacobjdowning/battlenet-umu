{ writeShellApplication, curl, coreutils, umu-launcher, proton-ge-bin, lib,
	bnetPrefix ? "TestGames/battlenet",
	gamePath ? "Program Files (x86)/Battle.net/Battle.net Launcher.exe",	
	gameName ? "Battle.net"
}:
let
	lowerName = lib.toLower gameName;
	nameList = builtins.filter builtins.isString (builtins.split "[^a-z]+" lowerName);
	scriptName = lib.concatStringsSep "-" (nameList ++ ["umu"]);
in
writeShellApplication {
	name = scriptName; 
	runtimeInputs = [ 
		umu-launcher
		curl
		coreutils
	];
	runtimeEnv = {
		GAMEID = "umu-default";
		PROTONPATH = "${proton-ge-bin.steamcompattool}";
		BNET_PREFIX = bnetPrefix;
		BNET_PATH = "Program Files (x86)/Battle.net/Battle.net Launcher.exe";
		WIN_PATH = gamePath;
	};
	text = builtins.readFile ./bnet-umu.sh;
}
