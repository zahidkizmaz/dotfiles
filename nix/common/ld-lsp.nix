with import <nixpkgs> <./ld.nix> {};
mkShell {
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    go
    nodejs_21
    python3
    rustup
  ];
  NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
}
