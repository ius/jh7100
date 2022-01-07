{
  lib
, stdenv
, fetchFromGitHub
, withPlatform ? "generic"
, withPayload ? null
, withFDT ? null
}:

stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "v1.0";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = version;
    sha256 = "0srqkhd9b1mq4qkqk31dlrzy4mhljr49bzjxm0saylsbwhgxq31s";
  };

  installFlags = [
    "I=$(out)"
  ];

  makeFlags = [
    "PLATFORM=${withPlatform}"
  ] ++ lib.optionals (withPayload != null) [
    "FW_PAYLOAD_PATH=${withPayload}"
  ] ++ lib.optionals (withFDT != null) [
    "FW_FDT_PATH=${withFDT}"
  ];

  dontStrip = true;
  dontPatchELF = true;
}
