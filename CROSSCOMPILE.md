# Cross-compiling Fleetbench for RISC-V on x86_64 Linux

## Nix Setup

Install Nix from the package manager on your Linux distribution, or follow the instructions at https://nixos.org/download/#nix-install-linux.

After installing Nix, enable experimental features by adding the following lines to your `~/.config/nix/nix.conf` file:

```
experimental-features = nix-command flakes
```

## Entering devShell

### GCC setup

```bash
nix develop .#gcc --ignore-env
```

### LLVM setup

```bash
nix develop .#llvm --ignore-env
```
