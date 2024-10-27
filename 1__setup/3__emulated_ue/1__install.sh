#!/bin/bash
export SIMURAI_SKIP_ADB_CHECK="1";

readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/1__setup/3__emulated_ue;

pushd .;
cd ${HERE};

check "If SIMurai can be downloaded.";
simuraiDownload "${HERE}/docker/simurai";
if ! checkResult "$?" "SIMurai was downloaded." "SIMurai failed to download."; then
    exit 1;
fi

pushd .;
check "If SIMurai can be built.";
cd "${HERE}/docker/simurai";
(./docker.sh);
if ! checkResult "$?" "SIMurai was built." "SIMurai failed to build."; then
    exit 1;
fi
popd;

check "Check if FirmWire was already downloaded.";
checkDir "FirmWire";
if ! checkResult "$?" "Found FirmWire directory, no need to re-download." "Need to download FirmWire." ; then
    check "If FirmWire was downloaded successfully.";
    wget -O FirmWire.tar.gz https://github.com/FirmWire/FirmWire/archive/8b540a63bfe80850d338df15a671e5bab08214eb.tar.gz;
    if ! checkResult "$?" "FirmWire was downloaded." "FirmWire still missing after downloading."; then
        exit 1;
    fi

    check "FirmWire tarball checkum verification.";
    echo "f177d56d28d59f77345a5d153ef55ffadd9132fc975f3b2de55257509ff8add6 FirmWire.tar.gz" | sha256sum --check --status;
    if ! checkResult "$?" "FirmWire checksum is valid." "FirmWire checksum is invalid."; then
        exit 1;
    fi

    check "FirmWire tarball extraction.";
    mkdir FirmWire;
    tar -xzf FirmWire.tar.gz --strip-components=1 -C ./FirmWire;
    checkDir "FirmWire";
    if ! checkResult "$?" "FirmWire tarball extracted." "FirmWire tarball extraction failed."; then
        exit 1;
    fi

    check "If we can apply SIMurai patches to FirmWire";
    pushd .;
    cd ./FirmWire;
    patch -p1 -i ../patches/simurai__firmwire_usim_peripheral_patches.diff
    if ! checkResult "$?" "FirmWire patched." "FirmWire NOT patched."; then
        exit 1;
    fi
    popd;
fi

check "If we can build FirmWire base image.";
pushd .;
cd ./FirmWire;
docker build --progress=plain . -t simurai/s3__firmwire:1.0.0 2>&1 | tee docker.log;
if ! checkResult "$?" "FirmWire base image was built." "FirmWire base image was NOT built."; then
    exit 1;
fi
popd;

check "If we can build setup image.";
pushd .;
cd ./docker;
docker build --progress=plain . -t simurai/s3:1.0.0 2>&1 | tee docker.log;
if ! checkResult "$?" "Setup image was built." "Setup image was NOT built."; then
    exit 1;
fi
popd;

popd;
exit 0;
