{
  description = "Desktop";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
  }: let
    system = "x86_64-linux";
    version = "23.11";
    hostName = "Sapphire";
  in {
    nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        home-manager.nixosModules.home-manager
        (import ./host {inherit system version hostName;})
        {
          home-manager.users.tod = import ./home {inherit system version;};
        }
      ];
    };
  };
}
