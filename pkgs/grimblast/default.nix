{ lib
, stdenvNoCC
, fetchFromGitHub
, coreutils
, scdoc
, makeWrapper
, wl-clipboard
, libnotify
, slurp
, grim
, jq
, bash
, hyprland ? null
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "grimblast";
  version = "0.1";

  prefetch = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "37c8121f98d76f57caa00dd7106877876e0d7483";
    hash = "sha256-Z0pbBVtijv4xbL42rPzMoYFSOqALFRYDMN9iOumSEso=";
  };

  src = "${prefetch}/${pname}";

  buildInputs = [ bash scdoc ];
  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/grimblast --prefix PATH ':' \
      "${lib.makeBinPath ([
        wl-clipboard
        coreutils
        libnotify
        slurp
        grim
        jq
      ]
      ++ lib.optional (hyprland != null) hyprland)}"
  '';

  meta = with lib; {
    description = "A helper for screenshots within hyprland, based on grimshot";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ misterio77 ];
  };
}
