{
  description = ''
    Development tooling for Certora Prover.

    Orignal installation guide: https://docs.certora.com/en/latest/docs/user-guide/getting-started/install.html
  '';

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
    certora-cli = p: with p; [(
      buildPythonPackage rec {
        pname = "certora-cli";
        version = "3.6.8";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-1j3KNxvY3+bZzxAELGoLtSyL8HFvrO8gMYq1pjkZWOU=";
        };
        pythonRelaxDeps = true;
        propagatedBuildInputs = with pkgs.python3Packages; [
          setuptools
          tabulate
          argcomplete
          tqdm
          click
          pycryptodome
          sly
          requests
        ];
        doCheck = false;
        pythonImportsCheck = [
          "certora_cli"
        ];
    })];
    devInputs = with pkgs; [
      python3
      (python3.withPackages certora-cli)
      jdk
    ];
  in {
    devInputs = devInputs;
    devShells.default = with pkgs; mkShell {
      buildInputs = devInputs;
    };
  });
}
