#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -x;          # Print commands after applying all substitutions.


platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]]
};

printf "%s\\n" "1. Check platform is ubuntu."
if ! platform; then
    printf "%s\\n" "Platform not supported. Need ubuntu."
    exit 1;
fi

echo "Cloning and building FirmWire"
if [ ! -d "FirmWire" ] ; then
    git clone --branch v1.1.0 git@github.com:FirmWire/FirmWire.git
    pushd .
    cd ./FirmWire
    git apply ../patches/simurai__firmwire_usim_peripheral_patches.diff
    popd 
else
    echo "Found FirmWire directory, skip cloning"
fi

pushd .
cd ./FirmWire
docker build --progress=plain . -t simurai/firmwire_base:1.0.0 2>&1
popd

pushd .
cd ./docker
docker build --progress=plain . -t simurai/setup_3:1.0.0 2>&1 | tee build.log
popd
