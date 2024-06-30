{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  flake = "/home/philopence/Documents/nix-configuration";
in {
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      inputs.sops-nix.nixosModules.sops

      ./hardware-configuration.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  features.xserver.enable = true;

  ## FIXED neovim :h fswatch-limitations
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 100000;
    "fs.inotify.max_queued_events" = 100000;
  };
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    overlays =
      [
        # inputs.neovim-nightly-overlay.overlays.default
      ]
      ++ (builtins.attrValues outputs.overlays);
    config = {
      allowUnfree = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs flake;};
    users = {
      "philopence" = import ../home-manager/home.nix;
    };
  };

  sops = {
    age.sshKeyPaths = [];
    gnupg.sshKeyPaths = [];
    defaultSopsFile = ../extras/secrets.yaml;
    age.generateKey = true;
    age.keyFile = "/nix/persistent/var/lib/sops-nix/key.txt";
    secrets = {
      "wireless.env" = {};
      "id_ed25519" = {
        owner = "philopence";
        path = "/home/philopence/.ssh/id_ed25519";
      };
      "id_ed25519.pub" = {
        owner = "philopence";
        path = "/home/philopence/.ssh/id_ed25519.pub";
      };
      "id_rsa" = {
        owner = "philopence";
        path = "/home/philopence/.ssh/id_rsa";
      };
      "id_rsa.pub" = {
        owner = "philopence";
        path = "/home/philopence/.ssh/id_rsa.pub";
      };
      "proxy/server".owner = "philopence";
      "proxy/password".owner = "philopence";
    };
  };

  # NOTE mkpasswd -m SHA-512 -s "<PASSWD>"
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users = {
      root = {
        initialHashedPassword = "$6$aXXcWWvfrOnLVjBF$38D8mmf.vHgWJFpOo7NHePs7To/1ftYU/hYzeE1ND2./7o.KLQsNplFn0mUoQFk9u72MKAHlt9Altb71jE6Te/";
      };
      philopence = {
        initialHashedPassword = "$6$3hTuLWjxU8H5MYyN$CUR97rhioR5X7CNvMKDWvQmN9EupnRSFL1N4A1SxDLqOdrjHuRxHTv7nK4YmeUr8LuQq/E75JNZZdBRpWu7la/";
        # hashedPasswordFile = config.sops.secrets."philopence".path;
        isNormalUser = true;
        extraGroups = ["wheel"];
      };
    };
  };

  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [];
    variables = {
      SOPS_AGE_KEY_FILE = "/run/media/philopence/SanDisk/keys.txt";
    };
    persistence."/nix/persistent" = {
      directories = [
        "/etc/v2raya"
        "/etc/ssh"
        "/var/lib/docker"
        "/var/lib/sops-nix" # host age keys
        "/var/lib/private/ollama"
      ];
      files = [];
      users."philopence" = {
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
          ".cache"
          ".config"
          ".local"
          ".ssh"
        ];
        files = [];
      };
    };
  };

  networking = {
    hostName = "nixos";
    firewall = {
      enable = false;
    };
    wireless = {
      enable = true;
      environmentFile = "/run/secrets/wireless.env";
      networks = {
        "ERROR" = {
          hidden = true;
          pskRaw = "@ERROR@";
        };
        "hotspot" = {
          pskRaw = "6589d759a80278d2fd8b3d105934f19b877fafe3896e0c4632632dd846635f7e";
        };
      };
    };
  };

  # networking.proxy.default = "192.168.0.100:2333";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # services.v2raya.enable = true;

  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "tun";
          tag = "tun-in";
          interface_name = "tun";
          inet4_address = "172.19.0.1/30";
          auto_route = true;
          sniff = true;
          sniff_override_destination = false;
          gso = true;
          # mtu = 1500;
          # stack = "gvisor";
        }
      ];
      route = {
        auto_detect_interface = true;
        rules = [
          {
            protocol = "dns";
            outbound = "dns-out";
          }
          {
            protocol = "quic";
            outbound = "block-out";
          }
          {
            rule_set = ["geoip-cn" "geosite-geolocation-cn"];
            outbound = "direct-out";
          }
        ];
        final = "proxy-out";
        rule_set = [
          {
            tag = "geoip-cn";
            format = "binary";
            type = "remote";
            url = "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs";
            download_detour = "proxy-out";
          }
          {
            tag = "geosite-geolocation-cn";
            format = "binary";
            type = "remote";
            url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-geolocation-cn.srs";
            download_detour = "proxy-out";
          }
        ];
      };
      dns = {
        rules = [
          {
            outbound = "any";
            server = "direct-dns";
          }
          {
            rule_set = "geosite-geolocation-cn";
            server = "direct-dns";
          }
        ];
        final = "proxy-dns";
        servers = [
          {
            tag = "proxy-dns";
            address = "https://1.1.1.1/dns-query";
            detour = "proxy-out";
          }
          {
            tag = "direct-dns";
            address = "https://223.5.5.5/dns-query";
            detour = "direct-out";
          }
        ];
      };
      outbounds = [
        {
          tag = "proxy-out";
          type = "shadowsocks";
          server._secret = /run/secrets/proxy/server;
          password._secret = /run/secrets/proxy/password;
          server_port = 11025;
          method = "aes-128-gcm";
        }
        {
          tag = "direct-out";
          type = "direct";
        }
        {
          tag = "dns-out";
          type = "dns";
        }
        {
          tag = "block-out";
          type = "block";
        }
      ];
      experimental = {
        cache_file = {
          enabled = true;
        };
      };
    };
  };

  time.timeZone = "Asia/Shanghai";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      jost
      sarasa-gothic
      lxgw-neoxihei
      lxgw-wenkai
      comic-mono
      fantasque-sans-mono
      recursive
      cascadia-code
      jetbrains-mono
      ibm-plex
      # ✿
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Jost*" "LXGW WenKai" "Sarasa Mono SC" "LXGW Neo XiHei" "Noto Color Emoji"];
        sansSerif = ["Jost*" "LXGW Neo XiHei" "Sarasa Mono SC" "LXGW WenKai" "Noto Color Emoji"];
        monospace = ["Sarasa Term SC" "LXGW Neo XiHei" "LXGW WenKai" "Noto Color Emoji"];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Arial</string></test>
            <edit name="family" mode="assign" binding="same"><string>sans-serif</string></edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Helvetica</string></test>
            <edit name="family" mode="assign" binding="same"><string>sans-serif</string></edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Noto Sans</string></test>
            <edit name="family" mode="assign" binding="same"><string>sans-serif</string></edit>
          </match>
        </fontconfig>
      '';
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.ollama = {
    enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
  };

  services.udisks2.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 7d";
    inherit flake;
  };

  programs.dconf.enable = true;

  programs.fish.enable = true;

  programs.git.enable = true;

  programs.neovim.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc # NOTE codeium language_server_linux_x64
      openssl # NOTE prisma
    ];
  };

  virtualisation.docker.enable = true;

  # services.ratbagd.enable = true; # for piper

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
