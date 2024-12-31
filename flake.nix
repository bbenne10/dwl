{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      getExe = pkgs.lib.meta.getExe;
      autostart = pkgs.writeScriptBin "dwl_autostart.sh" ''
        ${getExe pkgs.wbg} ~/pictures/wallpaper.jpg &
        kanshi &
        emacs &
        librewolf &
      '';

      dwl = pkgs.dwl.overrideAttrs (oldAttrs: {
        src = ./.;
        buildInputs =
          oldAttrs.buildInputs
          ++ (builtins.attrValues {
            inherit (pkgs) libdrm fcft libinput;
          });
        patchPhase = ''
          substituteInPlace \
            config.def.h \
            --replace-fail "kitty" ${getExe pkgs.kitty} \
            --replace-fail "bemenu-run" "${pkgs.bemenu}/bin/bemenu-run" \
            --replace-fail "brightnessctl" ${getExe pkgs.brightnessctl} \
            --replace-fail "pamixer" ${getExe pkgs.pamixer} \
            --replace-fail "swaylock" ${getExe pkgs.swaylock} \
            --replace-fail "autostart.sh" ${getExe autostart}

          substituteInPlace \
            dwl.c \
            --replace-fail "/bin/sh" "${getExe pkgs.bash}"
        '';
      });
      slstatus = pkgs.slstatus.overrideAttrs (oldAttrs: {
        preBuild = ''
          cp ${./slstatus_config.h} config.h
        '';
      });
      dwls = pkgs.writeScriptBin "dwls" ''
        ${getExe slstatus} -s | ${getExe dwl}
      '';
    in
    {
      packages.x86_64-linux = rec {
        inherit dwl dwls;

        default = dwls;
      };
      devShells.x86_64-linux.default = pkgs.mkShell {
        packagesFrom = dwl;
        packages = [
          pkgs.pkg-config
          pkgs.ccls
        ];
      };
    };
}
