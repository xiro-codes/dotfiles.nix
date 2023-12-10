{
  description = "Desktop";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    home-manager.url = "github:xiro-codes/home-manager";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-steamdeck.url = "github:Jovian-Experiments/Jovian-NixOS";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-generators,
    nixos-steamdeck,
  }: let
    system = "x86_64-linux";
    version = "23.11";
    inherit (nixpkgs.lib) foldl head tail nixosSystem;
    reduce = f: list: (foldl f (head list) (tail list));
    mapReduce = f: list: reduce (cs: s: cs // s) (map f list);
  in {
    nixosConfigurations =
      mapReduce
      (elem: let
        inherit (elem) hostName earlyModules lateModules;
      in {
        ${hostName} = nixosSystem {
          inherit system;
          modules = earlyModules ++ [(import ./hosts/${hostName} {inherit system version hostName self;})] ++ lateModules;
        };
      }) [
        {
          hostName = "Ruby";
          earlyModules = [
            nixos-steamdeck.nixosModules.default
          ];
          lateModules = [];
        }
        {
          hostName = "Sapphire";
          earlyModules = [
            home-manager.nixosModules.default
            nixos-generators.nixosModules.all-formats
          ];
          lateModules = [
            ({lib, ...}: {
              formatConfigs.iso = {config, ...}: {
                home-manager.users.tod = import ./home/home.nix;
                fileSystems = lib.mkDefault {};
                swapDevices = lib.mkForce [];
              };
            })
          ];
        }
      ];
  };
}
