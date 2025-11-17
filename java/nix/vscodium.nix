{ pkgs }:
pkgs.vscode-with-extensions.override {
  vscode = pkgs.vscodium;
  vscodeExtensions = [
    pkgs.vscode-extensions.bbenoist.nix
    pkgs.vscode-extensions.shardulm94.trailing-spaces
    pkgs.vscode-extensions.vscjava.vscode-java-pack
    pkgs.vscode-extensions.vscjava.vscode-java-debug
    pkgs.vscode-extensions.vscjava.vscode-java-test
    pkgs.vscode-extensions.vscjava.vscode-java-dependency
    pkgs.vscode-extensions.vscjava.vscode-gradle
    pkgs.vscode-extensions.vscjava.vscode-maven
    pkgs.vscode-extensions.redhat.java
    pkgs.vscode-marketplace.vmware.vscode-boot-dev-pack
    pkgs.vscode-extensions.vscjava.vscode-spring-initializr
    pkgs.vscode-marketplace.vscjava.vscode-spring-boot-dashboard
    pkgs.vscode-marketplace.vmware.vscode-spring-boot
  ];
}
