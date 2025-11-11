{ pkgs }:
pkgs.vscode-with-extensions.override {
  vscode = pkgs.vscodium;
  vscodeExtensions = [
    pkgs.vscode-extensions.bbenoist.nix
    pkgs.vscode-extensions.shardulm94.trailing-spaces
    pkgs.vscode-extensions.vscjava.vscode-java-pack
    pkgs.vscode-marketplace.vmware.vscode-boot-dev-pack
  ];
}
