{
  lib,
  stdenv,
  swift,
  swiftpm,
  swiftpm2nix,
  src,
}:

let
  generated = swiftpm2nix.helpers ./.;
in
stdenv.mkDerivation {
  pname = "license-plist";
  version = "3.25.1";
  inherit src;

  patches = [
    ./patches/remove-spm-plugin-binary-target.patch
  ];

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    swift build -c release --disable-automatic-resolution --product license-plist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    mkdir -p "$out/bin"
    cp "$binPath/license-plist" "$out/bin/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line tool that generates a plist of dependency licenses";
    homepage = "https://github.com/mono0926/LicensePlist";
    license = licenses.mit;
    mainProgram = "license-plist";
    platforms = platforms.darwin;
  };
}
