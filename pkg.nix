{ writeShellApplication, curl, coreutils, umu-launcher, proton-ge-bin,
	bnetPrefix ? "TestGames/battlenet",
	gamePath ? "Program Files (x86)/Battle.net/Battle.net Launcher.exe",	
}:
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
		BNET_PREFIX = bnetPrefix;
		BNET_PATH = "Program Files (x86)/Battle.net/Battle.net Launcher.exe";
		WIN_PATH = gamePath;
	};
	text = builtins.readFile ./bnet-umu.sh;
}
