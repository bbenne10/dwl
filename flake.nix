{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system ="x86_64-linux"; }; in
    {
      packages.x86_64-linux = rec {
        dwl = pkgs.dwl.overrideAttrs(oldAttrs: {
          src = ./.;
          buildInputs = oldAttrs.buildInputs ++ (builtins.attrValues {
            inherit (pkgs) libdrm fcft;
          });
        });
        default = dwl;
      };
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs)
            fcft
            gcc
            gnumake
            libdrm
            libinput
            libxkbcommon
            pixman
            pkg-config
            wayland
            wayland-protocols
            wayland-scanner
            wlroots_0_18
            ;
        };
      };
  };
}
