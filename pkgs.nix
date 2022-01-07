with import <nixpkgs> {
  crossSystem = {
    config = "riscv64-unknown-linux-gnu";
  };
};
rec {
  opensbi-jh7100 = callPackage ./opensbi.nix {
    withPayload = "${uboot-jh7100}/u-boot.bin";
    withFDT = "${uboot-jh7100}/u-boot.dtb";
  };

  uboot-jh7100 = callPackage ./uboot.nix { defconfig = "starfive_jh7100_visionfive_smode"; };

  linux = linuxManualConfig rec {
    inherit lib stdenv;

    version = "5.16.0-rc2";

    src = fetchFromGitHub {
      owner = "starfive-tech";
      repo = "linux";
      rev = "linux_5.16_rc2_2021.11.27";
      sha256 = "0hpl08dbp805xa407ks1dqnllkv9zv6llplm9iy7frkc7zlb2czf";
    };

    configfile = ./starfive_jh7100_config;
  };
}
