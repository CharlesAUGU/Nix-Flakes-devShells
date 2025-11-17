{
  description = "java-dev-env";
  nixConfig.bash-prompt = "\\[\\e[0m\\][\\[\\e[0;2m\\]nix-develop \\[\\e[0;1m\\]java-dev-env \\[\\e[0;93m\\]\\w\\[\\e[0m\\]\\[\\e[0;94m\\]$(__git_ps1)\\[\\e[0m\\]]\\[\\e[0m\\]$ \\[\\e[0m\\]";

  # inputs is an attribute set of all the dependencies of the flake
  inputs = {
    # latest packages list
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # tool that helps having standardized nix flake files
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Get vscode extensions that are not in nixpkgs
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

############################################################################

  # outputs is a function of one argument that takes an attribute set
  # of all the realized inputs, and outputs another attribute set
  # i.e. uses the inputs to build some outputs (packages, apps, shells,..)

  outputs = { self, nixpkgs, flake-parts, nix-vscode-extensions }@inputs:

    # mkFlake is the main function of flake-parts to build a flake with standardized arguments
    flake-parts.lib.mkFlake { inherit self; inherit inputs; } {

      # list of systems to be built upon
      systems = nixpkgs.lib.systems.flakeExposed;

      # make a build for each system
      perSystem = { system, pkgs, lib, config, self', inputs', ... }: {

        # add overlay to use nix-vscode-extensions
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];
        };


        packages = {
          # code editor with pre-installed extensions
          vscodium = import ./nix/vscodium.nix { inherit pkgs; };
        };

        # Here is the definition of the nix-shell we use for development
        # It comes with all necessary packages + other nice to have tools
        devShells.default = pkgs.mkShell {
              buildInputs = with pkgs; with self'.packages;
                [
                    # Java #
                    jdk21

                    # Devops #
                    ## Docker ##
                    docker
                    docker-compose
                    lazydocker

                    # IDE #
                    vscodium
                    bashInteractive # necessary for vscodium integrated terminal

                    # Utilities #
                    bash-completion
                    jq
                ];
              shellHook = ''
                source <(curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh);
                export LANG=C.utf8;
                codium . --no-sandbox;
              '';
            };
      };
    };

############################################################################################

  # nixConfig is an attribute set of values which reflect the values given to nix.conf.
  # This can extend the normal behavior of a user's nix experience by adding flake-specific
  # configuration, such as a binary cache.
  nixConfig = {
    extra-substituers = [
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    allow-import-from-derivation = "true";
  };
}
