{ writeShellApplication, curl, coreutils, umu-launcher, proton-ge-bin }:
writeShellApplication {
	name = "bnet-umu";
	runtimeInputs = [ 
		umu-launcher
		curl
		coreutils
	];
	runtimeEnv = {
		GAMEID = "umu-default";
		PROTONPATH = "${proton-ge-bin.steamcompattool}";
		BNET_PREFIX = "TestGames/battlenet";
		BNET_PATH = "Program Files (x86)/Battle.net/Battle.net Launcher.exe";
		WIN_PATH = "Program Files (x86)/Battle.net/Battle.net Launcher.exe";
	};
	text = builtins.readFile ./bnet-umu.sh;
}
