{
  description = ''
    Development tooling for Certora Prover.

    Orignal installation guide: https://docs.certora.com/en/latest/docs/user-guide/getting-started/install.html
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
        version = "3.6.5";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-gN1m/W4kPzaXp4je2DMmQmfOF9xe1J0YK1pR10BIkDI=";
        };
        doCheck = false;
        propagatedBuildInputs = with pkgs.python3Packages; [
          tabulate
          argcomplete
          tqdm 
          click
          pycryptodome
          sly
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
