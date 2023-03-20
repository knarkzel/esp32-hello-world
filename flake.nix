{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esp-dev.url = "github:thiskappaisgrey/nixpkgs-esp-dev-rust";
  };

  outputs = {
    self,
    nixpkgs,
    esp-dev,
  }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ (import "${esp-dev}/overlay.nix") ];
    };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        wget
        flex
        bison
        gperf
        cmake
        ninja
        gnumake
        ncurses5
        pkgconfig
        llvm-xtensa
        rust-xtensa
        openocd-esp32-bin
        gcc-xtensa-esp32-elf-bin
        (python3.withPackages (pypkgs: [pypkgs.pip pypkgs.virtualenv]))
      ];

      shellHook = ''
        export ESP_IDF_VERSION="v4.4"
        export LIBCLANG_PATH="${pkgs.llvm-xtensa}/lib"
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libxml2 pkgs.zlib pkgs.stdenv.cc.cc.lib ]}"
      '';
    };
  };
}
