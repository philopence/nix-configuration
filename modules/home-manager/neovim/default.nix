{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.neovim;
in

{
  options.features.neovim = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        #   ## TODO: emmet-language-server
        stylua
        eslint_d
        prettierd
        lua-language-server
        nodePackages_latest.typescript-language-server
        vscode-langservers-extracted
        emmet-language-server
      ];
    };

    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/extras/nvim";
  };
}
