{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs: {
    nixosConfigurations."nixos-workstation" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ (import ./hosts/nixos-workstation) ];
    };
    nixosConfigurations."nixos-laptop" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ (import ./hosts/nixos-laptop) ];
    };
  };
}