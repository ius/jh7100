{
  lib
, stdenv
, fetchFromGitHub
, buildPackages
, defconfig
}:

stdenv.mkDerivation rec {
  pname = "uboot";
  version = "u-boot-2022.01-rc2-VisionFive-ga5835bea64";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = version;
    sha256 = "1friswdr3zbrmzbxwqd617zfy98x4gn75m9n3smi2ww04fv94747";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = with buildPackages; [
    bison
    flex
    openssl
    which
    #bc # XXX ?
  ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  configurePhase = ''
    runHook preConfigure

    make ${defconfig}_defconfig

    runHook postInstall
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp u-boot.bin u-boot.dtb $out

    runHook postConfigure
  '';
}
