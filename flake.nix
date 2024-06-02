{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system ="x86_64-linux"; }; in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs)
            gcc
            gnumake
            libinput
            libxkbcommon
            pixman
            pkg-config
            wayland
            wayland-protocols
            wayland-scanner
            wlroots
            ;
        };
      };
  };
}
