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
  version = "3.27.2";
  inherit src;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
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
