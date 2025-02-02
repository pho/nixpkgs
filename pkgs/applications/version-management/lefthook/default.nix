{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let
  pname = "lefthook";
  version = "1.4.2";
in
buildGoModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-rghjOfQXs7udTjBdsCG6Rx7gI/6WGkRPXE/fsGCTCxA=";
  };

  vendorHash = "sha256-xeOWbfKy+LeInxcRM9evE/kmqlWlKy0mcHopWpc/DO0=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd lefthook \
      --bash <($out/bin/lefthook completion bash) \
      --fish <($out/bin/lefthook completion fish) \
      --zsh <($out/bin/lefthook completion zsh)
  '';

  meta = {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/evilmartians/lefthook";
    changelog = "https://github.com/evilmartians/lefthook/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
