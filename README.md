# Battle.net Umu
A Nix Flake that provides a Home-Manager module to declaratively configure Battle.net games and WoW addons using [umu-launcher](https://github.com/Open-Wine-Components/umu-launcher) and [instawow](https://github.com/layday/instawow)

## Installation
Add the repo to your flake inputs:
```nix
battlenet-umu = {
    url = "github:jacobjdowning/battlenet-umu";
};
```
The flake provides a module that you want to add into your home-manager imports:
```nix
imports = [
   	battlenet-umu.homeModules.default
];
```
## Configuration
Here is an example configuration:
```nix
let
	wow = "Program Files (x86)/World of Warcraft";
	addonFolder = "Interface/Addons";
in
programs.battlenet-umu = {
	enable = true;
	games = [
		{ name = "Battle.net"; }
		{
			name = "Heroes of the Storm";
			path = "Program Files (x86)/Heroes of the Storm/Support64/HeroesSwitcher_x64.exe";
		}
		{
			name = "World of Warcraft";
			path = "${wow}/_retail_/Wow.exe";
		}
		{
			name = "WoW: Classic";
			path = "${wow}/_classic_era_/WowClassic.exe";
		}
	];
	addons = {
		enable = true;
		tokens = {
			wagoAddons = "SECRET";
		};
		versions = [
			{
				name = "era";
				addonDir = "${wow}/_classic_era_/${addonFolder}";
				flavour = "vanilla_classic";
				addons = [
					"github:Peterodox/YUI-Dialogue"
					"github:Total-RP/Total-RP-3"
					"github:DustinChecketts/VendorPricePlus"
				];
			}
		];
	};
}
```
- Each element in the list of games creates a launch script with umu launcher and a desktop entry
- Each element in the list of versions under addons creates a instawow profile
- Enabling the addon module creates `sync-addons` and a service to run it on rebuild that will sync the addons installed with instawow to your declared addons
    - `sync-addons <versions.*.name>` can be used to manually do this for a profile in order to see the output
- `addons.tokens` is where you can enter your tokens for any addon repos you would like to use (see instawow readme for more on that)
    - *Important Note* the way this is implemented means the plain text of the tokens object will be copied into the nix store which is readable by any user

The rest of the options are documented [here](options.md)

## Usage
### Quick Start
Each game defined in `battlenet-umu.games` will be available in your launcher of choice

### Full Explanation
Enabling the battlenet-umu module will install a package for each game in `games` named <slugified-game.*.name>-umu that includes an install script for the Battle.net launcher (make sure to leave the location as the default) and if Battle.net is installed will launch the specified path within the wine prefix. It will also build desktop items for each game for launch menus.

Enabling the addons submodule will install the [instawow](https://github.com/layday/instawow) package as well as a `sync-addons` package. `sync-addons <versions.*.name>` is called on every rebuild and boot to sync the addons installed with instawow to your declared addons in the config. `sync-addons <versions.*.name>` can also be run manually for debugging purposes. 

Updating addons is done with the base instawow interface: `instawow -p <versions.*.name> update`
