{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "emmet-language-server";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FF4bV+0ZDPe+Qoo/aI3ANdOLRPvU5t6VNiaY3nMM/Bg=";
  };

  npmDepsHash = "sha256-pUFj6YvslDTl1o9RNqY2/aOqkHI3elaPUUU0f6mezpo=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "A language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    license = licenses.mit;
    # maintainers = with maintainers; [ winter ];
  };
}
