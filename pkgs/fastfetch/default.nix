{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, makeWrapper
, pciutils
, imagemagick_light
}:

stdenv.mkDerivation rec {
  pname = "fastfetch";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = "fastfetch";
    rev = "c15f55762dd3d78f30af1606384bf4d79cf7745d";
    hash = "sha256-/M4eT9BQir36NAp1+knKdwiyyFNcuOyNg/yhYEV9eSg=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  runtimeDependencies = [ pciutils imagemagick_light ];

  buildInputs = runtimeDependencies;

  NIX_CFLAGS_COMPILE = [
    "-Wno-macro-redefined"
    "-Wno-implicit-int-float-conversion"
  ];

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/nix-community/nur-combined" +
        "/cd58f18ba81b0a8a79497bbab55c7a86c2639d39" +
        "/repos/vanilla/pkgs/fastfetch/no-install-config.patch";
      hash = "sha256-IKhVhgDRN5qbLNlbnheYM5aMnm/h1VeFgOqsTl/Ww0Q=";
    })
  ];

  cmakeFlags = [ "--no-warn-unused-cli" ];

  LD_LIBRARY_PATH = lib.makeLibraryPath runtimeDependencies;

  postInstall = ''
    wrapProgram $out/bin/fastfetch --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
    wrapProgram $out/bin/flashfetch --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
  '';

  meta = with lib; {
    description = "Like neofetch, but much faster because written in C. ";
    homepage = "https://github.com/LinusDierheimer/${pname}";
    license = licenses.mit;
  };
}

