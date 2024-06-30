{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.lf;
in {
  options.features.lf = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        ignorecase = true;
      };
      commands = {
        drag = "%${pkgs.ripdrag}/bin/ripdrag -a -x $fx";
      };
      keybindings = {};
      extraConfig = let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
          fi

          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
    };
  };
}
