let
  newlibPkgs = import <nixpkgs> {
    crossSystem = {
      config = "riscv64-none-elf";
      libc = "newlib";
    };
  };

  patchPhase = ''
    runHook prePatch

    substituteInPlace build/Makefile \
      --replace "--specs=nano.specs" ""

    patchShebangs build/fsz.sh

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    cd build
    make CROSSCOMPILE=${newlibPkgs.stdenv.cc.targetPrefix}

    runHook postBuild
  '';
in
{
  ddrinit = newlibPkgs.stdenv.mkDerivation {
    pname = "jh7100-ddrinit";
    version = "211102";

    src = newlibPkgs.fetchFromGitHub {
      owner = "starfive-tech";
      repo = "JH7100_ddrinit";
      rev = "ddrinit-2133-211102";
      sha256 = "1q1p94l6sh7n0m60sxk6lv9yxif7d2skdzx9zrpmm26c62x5cw4k";
    };

    inherit patchPhase buildPhase;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      install -m0644 ddrinit-*.{asm,bin,elf} $out

      runHook postInstall
    '';

    dontStrip = true;
    dontPatchELF = true;
  };

  secondBoot = newlibPkgs.stdenv.mkDerivation {
    pname = "jh7100-bootloader";
    version = "211102";

    src = newlibPkgs.fetchFromGitHub {
      owner = "starfive-tech";
      repo = "JH7100_secondBoot";
      rev = "bootloader-211102_VisionFive_JH7100";
      sha256 = "1szsksxgpri9jvj092hkv1z491bnbn50mb6l7q4nzlls2zrl6mfi";
    };

    inherit patchPhase buildPhase;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      install -m0644 bootloader*.{asm,bin,elf} $out

      runHook postInstall
    '';

    dontStrip = true;
    dontPatchELF = true;
  };
}
