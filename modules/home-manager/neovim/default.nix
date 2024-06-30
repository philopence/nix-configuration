{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  cfg = config.features.neovim;
in {
  options.features.neovim = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      # package = pkgs.neovim;
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      ## npm install -g @vue/language-server @vue/typescript-plugin
      ## npm install -g @vtsls/language-server
      extraPackages = with pkgs; [
        fswatch # https://github.com/neovim/neovim/pull/27347
        luajitPackages.luarocks # lazy.nvim
        stylua
        # nixpkgs-fmt
        eslint_d
        prettierd
        lua-language-server
        nodePackages_latest.eslint
        nodePackages_latest.typescript-language-server
        nodePackages_latest."@prisma/language-server"
        vscode-langservers-extracted
        tailwindcss-language-server
        marksman
        # typescript
        emmet-language-server
        # gopls
        # gofumpt
      ];
    };

    # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/extras/nvim";
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${flake}/extras/nvim";
  };
}
