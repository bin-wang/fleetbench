{
  description = "DevShells for cross-compiling Fleetbench for RISC-V on x86_64";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      crossPkgs = pkgs.pkgsCross.riscv64;

      commonPackages = [
        pkgs.bazelisk
      ];

      commonShellHook = ''
        export BAZELISK_HOME=$PWD/.bazelisk_cache

        if [ ! -f .bazelisk_cache/.gitignore ]; then
          mkdir -p .bazelisk_cache
          echo "*" > .bazelisk_cache/.gitignore
        fi

        echo "Bazelisk cache set to local"
      '';
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system} = {
        gcc = pkgs.mkShellNoCC {
          packages = commonPackages ++ [
            crossPkgs.buildPackages.gcc15
            crossPkgs.buildPackages.binutils
          ];

          shellHook = commonShellHook + ''
            export CC=riscv64-unknown-linux-gnu-gcc
            export CXX=riscv64-unknown-linux-gnu-g++
            echo "Loaded GCC 15 Cross-Compiler Environment"
          '';
        };

        llvm = pkgs.mkShellNoCC {
          packages = commonPackages ++ [
            crossPkgs.buildPackages.llvmPackages_22.clang
            crossPkgs.buildPackages.llvmPackages_22.bintools
          ];

          shellHook = commonShellHook + ''
            export CC=riscv64-unknown-linux-gnu-clang
            export CXX=riscv64-unknown-linux-gnu-clang++
            echo "Loaded Clang/LLVM 22 Cross-Compiler Environment"
          '';
        };
      };
    };
}
