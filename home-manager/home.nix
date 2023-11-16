{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  features = {
    dkwm.enable = true;
    rime.enable = true;
    picom.enable = true;
    kitty.enable = true;
    dunst.enable = true;
    rofi.enable = true;
    lf.enable = true;
    neovim.enable = true;
    mpd.enable = true;
  };

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  nixpkgs = {
    overlays = [
      # inputs.neovim-nightly-overlay.overlay
    ] ++ (builtins.attrValues outputs.overlays);
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "philopence";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      gcc
      gnumake
      nodePackages_latest.nodejs
      unzip
      ripgrep
      fd
      maim
      jq
      xclip
      keepassxc
      qmk
      brightnessctl
      trashy
      kicad-small
      pcmanfm
      cava
    ];
    pointerCursor = {
      # package = pkgs.catppuccin-cursors.mochaLavender;
      # name = "Catppuccin-Mocha-Lavender-Cursors";
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
      # package = pkgs.bibata-cursors;
      # name = "Bibata-Original-Classic";
      # size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      FLAKE = "${config.home.homeDirectory}/Documents/nix-configuration";
    };
    sessionPath = [
      "$XDG_DATA_HOME/npm/bin"
    ];

    file = {
      ".npmrc".text = ''
        registry = https://registry.npmmirror.com
        prefix = ''${XDG_DATA_HOME}/npm
        cache = ''${XDG_CACHE_HOME}/npm
      '';
      # ".background-image".source = ../extras/nix-catppuccin-mocha.png;
        ".background-image".source = pkgs.fetchurl {
          ## CAT
          # url = "https://w.wallhaven.cc/full/o3/wallhaven-o3j1yl.jpg";
          # sha256 = "sha256-z/a1v4wQ0MFil1oluwFnEluKRGV1x+yz4bRSmZWCJFY=";
          ## PEPE
          url = "https://w.wallhaven.cc/full/jx/wallhaven-jxyopy.png";
          sha256 = "sha256-tQTqSltVlQhlfONeyCy2lcSgla2agurO8zB5ghnVZSU=";
          ## NIGHT GIRL
          # url = "https://w.wallhaven.cc/full/gj/wallhaven-gjyoq7.png";
          # sha256 = "sha256-3vcKZ8x+58Ys5ZlcQMoW2lORILpSAmzrRwzCA1DljcU=";
        };
        };

    };

    gtk = {
      enable = true;
      font = {
        name = "Sans";
        size = 10;
      };
      theme = {
        package = pkgs.materia-theme;
        name = "Materia-dark-compact";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
    };

    xsession = {
      enable = true;
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; } ## immersive-translate
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } ## ublock-origin
        { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } ## google-translate
        { id = "hkbdddpiemdeibjoknnofflfgbgnebcm"; } ## youtube-dual-subtitles
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; } ## react-developer-tools
      ];
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
        # fish_prompt = ''
        #   set_color magenta
        #   echo -n (prompt_pwd)" "
        #   set_color -o cyan
        #   if fish_is_root_user
        #     echo -n "# "
        #   else
        #     echo -n "\$ "
        #   end
        #   set_color normal
        # '';
      };
    };

    programs.zoxide.enable = true;
    programs.ripgrep.enable = true;
    programs.bat.enable = true;
    programs.fzf.enable = true;


    programs.lazygit.enable = true;

    programs.eza = {
      enable = true;
      enableAliases = true;
    };
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };

    services.udiskie.enable = true;

    programs.git = {
      enable = true;
      userName = "philopence";
      userEmail = "epcroo@yeah.net";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };


    programs.home-manager.enable = true;

    systemd.user.startServices = "sd-switch";
  }
