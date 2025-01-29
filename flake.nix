{
  description = "Arubos";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, flake-utils, devshell, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlays.default ];

          config.permittedInsecurePackages = [ ];
        };
      in pkgs.devshell.mkShell {
        name = "arubos.dev";
        packages = [
          pkgs.pkg-config
          pkgs.gcc
          pkgs.sqlite
          pkgs.gnumake
          pkgs.ruby_3_3
          pkgs.libyaml.dev
          pkgs.openssl_3_2.dev
          pkgs.postgresql_16.dev
          pkgs.autoconf269
          pkgs.automake
          pkgs.autogen
          pkgs.libtool
          pkgs.libffi.dev
          pkgs.gnum4
          pkgs.secp256k1
        ];
        env = [
          {
            name = "PKG_CONFIG_PATH";
            value =
              "${pkgs.pkg-config}:${pkgs.openssl_3_2.dev}/lib/pkgconfig:${pkgs.libyaml.dev}/lib/pkgconfig:${pkgs.postgresql_16.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig:${pkgs.secp256k1}/lib/pkgconfig";
          }
          {
            name = "LIBTOOL";
            value = "${pkgs.libtool}";
          }
          {
            name = "NIXPKGS_ALLOW_INSECURE";
            value = "1";
          }
        ];
        commands = [
          {
            name = "install";
            category = "devshell";
            help = "Install all dependencies";
            command = "bin/install";
          }
          {
            name = "update";
            category = "devshell";
            help = "Update dependencies";
            command = "bin/update";
          }
          {
            name = "clean";
            category = "devshell";
            help = "Remove build artifacts";
            command = "bin/run clean";
          }
          {
            name = "lint";
            category = "devshell";
            help = "Check code style";
            command = "bin/run lint";
          }
          {
            name = "format";
            category = "devshell";
            help = "Format code";
            command = "bin/run format";
          }
          {
            name = "test";
            category = "devshell";
            help = "Run tests";
            command = "bin/run test";
          }
          {
            name = "build";
            category = "devshell";
            help = "Build the project";
            command = "bin/run build";
          }
          {
            name = "dev";
            category = "devshell";
            help = "Run the development server";
            command = "bin/run dev";
          }
          {
            name = "start";
            category = "devshell";
            help = "Start the production server";
            command = "bin/run start";
          }
        ];
      };
    });
}
