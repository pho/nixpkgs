{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchPypi
, ruff
, pygls
, lsprotocol
, hatchling
, typing-extensions
, pytestCheckHook
, python-lsp-jsonrpc
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.32";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "ruff_lsp";
    hash = "sha256-n69Ibm+SFpjEkwPoYAJxVmmgtrRhzWh0PLfRe+iLxdo=";
  };

  postPatch = ''
    # ruff binary added to PATH in wrapper so it's not needed
    sed -i '/"ruff>=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pygls
    lsprotocol
    typing-extensions
  ];

  # fails in linux sandbox
  doCheck = stdenv.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    python-lsp-jsonrpc
    ruff
  ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath [ ruff ]}"
  ];

  meta = with lib; {
    description = "A Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/astral-sh/ruff-lsp";
    changelog = "https://github.com/astral-sh/ruff-lsp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
