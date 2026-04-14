{
  description = "RMK Corne devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
              "llvm-tools"
            ];
            targets = [ "thumbv7em-none-eabihf" ];
          })
          pkgs.flip-link
          pkgs.cargo-make
          pkgs.probe-rs-tools
          pkgs.libclang
        ];
        LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
      };
    };
}
