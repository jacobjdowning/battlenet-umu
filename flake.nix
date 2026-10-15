{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = { nixpkgs, home-manager, ... }: {
		homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
			modules = [ 
				./default.nix
				{
					home.username = "test";
					home.homeDirectory = "/home/jjd";
					home.stateVersion = "26.05";
				}
			];
		};
	};
}
