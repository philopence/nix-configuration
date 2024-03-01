# Nix Configuration

Super + Mods --> WM

Ctrl / Shift / Alt --> Neovim

Ctrl + Shift / Ctrl + Shift + Alt --> Term

## TODO

- [x] [emmet-language-server](https://github.com/NixOS/nixpkgs/pull/255524)
- [ ] https://github.com/IBM/plex

## Install Guide

```text

boot from usb-device
# umount <usb-device>
# dd if=<path-to-image> of=<usb-device> bs=4M conv=fsync

$ sudo -i

# systemctl start wpa_supplicant.service

# wpa_cli
  > add_network
  > set_network <id> ssid "<ssid>"
  > set_network <id> psk "<passphrase>"
  > set_network <id> scan_ssid 1 # for hidden SSID
  > enable_network <id>
  > quit

# <editor> /etc/resolv.conf
nameserver 119.29.29.29
nameserver 223.5.5.5
nameserver 223.6.6.6

Partitioning and formatting
<boot-device> 1G EFI-System
<nix-device>     Linux filesystem

# fdisk <nixos-device>
# mkfs.vfat -n BOOT <boot-device>
# mkfs.ext4 -L NIX <nix-device>

<root>(tmp) -- /mnt
<boot>      -- /mnt/boot
<nix>       -- /mnt/nix

# mount -t tmpfs none /mnt
# mount --mkdir <boot-device> /mnt/boot
# mount --mkdir <nix-device> /mnt/nix
# mkdir /mnt/nix/persistent

# nixos-generate-config --root /mnt

# export NIX_CONFIG="experimental-features = nix-command flakes"

# nix-shell -p git (or nix shell <registry>#git)

# git init /mnt/nix/persistent/nix-configuration
# cd /mnt/nix/persistent/nix-configuration
# nix flake init -t github:misterio77/nix-starter-config#standard
# cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
# <editor> ./nixos/hardware-configuration.nix

fileSystems."/" = {
  device = "none";
  fsType = "tmpfs";
  options = [ "defaults" "size=3G" "mode=755" ];
};

# <editor> ./flake.nix

inputs: impermanence.url = "github:nix-community/impermanence";
Fix Others

# <editor> ./nixos/configuration.nix
imports: inputs.impermanence.nixosModules.impermanence

environment.persistence."/persistent" = {
  directories = [
    "/etc/nixos"
  ];
  files = [];
  users."<username>" = {
    directories = [];
    files = [];
  };
};

programs.<shell>.enable = true;
users = {
  mutableUsers = false;
  defaultUserShell = <shell>;
  users = {
    root.initialPassword = "<password>";
    "<username>" = {
      initialPassword = "<password>";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
};

## Others: boot timezone network hostname proxy neovim git

nixos-install --no-root-passwd --flake <flake-url>#<hostname>

## Backup:
/mnt/etc/nixos /mnt/nix/persistent/etc/nixos
```

## Next Step

- home-manager
- hardware (gpu sound...)
- xserver(compositor) or wayland
- environment variables
- i18n
- fonts
- DE or WM
- gtk & qt
- DevDependencies: git gnumake gcc ...
- terminal emulator
- editor
- web browser
- app launcher
- notification
- wallpaper
- screenshot
- cli-tools: ripgrep fd fzf bat exa zoxide tmux btop lazygit lf udiskie

## Other Modules

- [nixos-hardware](https://github.com/NixOS/nixos-hardware)
- [impermanence](https://github.com/nix-community/impermanence)
- [sops-nix](https://github.com/Mic92/sops-nix)
- [nix-colors](https://github.com/Misterio77/nix-colors)
- [neovim-nightly-overlay](https://github.com/nix-community/neovim-nightly-overlay)

## Impermanence Guide

## Sops(-nix) Guide
