{
	description = "A Home Manager module for battle.net including addons";

	outputs = { self, ... }: {
		homeModules = {
			battlenet = ./umu/module.nix; 
			addons = ./addons/module.nix;
			default = {
				imports = [
					self.homeModules.battlenet
					self.homeModules.addons
				];
			};
		};
	};
}
