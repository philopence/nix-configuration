# Nix Configuration

## TODOS

- [ ] CHECK: https://github.com/nix-community/disko
- [ ] CHECK: https://github.com/nix-community/kickstart-nix.nvim

## Tips and Tricks

Get sha256: `nix store prefetch-file <url>`

### Disko

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix

nixos-generate-config --no-filesystems [...]

nixos-install

reboot
```

## References

- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix Starter Config](https://github.com/Misterio77/nix-starter-configs)
