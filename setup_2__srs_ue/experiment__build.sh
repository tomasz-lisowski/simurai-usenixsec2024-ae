#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -x;          # Print commands after applying all substitutions.

if [ `id -u` -ne 0 ]; then
    echo Please run this script as root or using sudo!;
    exit 1;
fi

platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]]
};

printf "%s\\n" "1. Check platform is ubuntu."
if ! platform; then
    printf "%s\\n" "Platform not supported. Need ubuntu."
    exit 1;
fi

pushd .
cd ./docker
sudo docker build --progress=plain . -t simurai/setup_2:1.0.0 2>&1 | tee build.log
popd
