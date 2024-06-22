#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -x;          # Print commands after applying all substitutions.

SETUP3_DIR="$PWD/../../0__setup/2__emulated_ue/"
MODEM_DIR="$SETUP3_DIR/modem_files/"
FIRMWIRE_DIR="$SETUP3_DIR/FirmWire/"

platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]]
};

printf "%s\\n" "1. Check platform is ubuntu."
if ! platform; then
    printf "%s\\n" "Platform not supported. Need ubuntu."
    exit 1;
fi


printf "%s\\n" "2. Check if setup 3 was built."
if ! docker image inspect simurai/setup_3:1.0.0 > /dev/null 2>&1 ; then
    printf "%s\\n" "Simurai Setup3 not found. Please run 0__setup/2__emulated_ue/experiment__build.sh."
    exit 1;
fi

printf "%s\\n" "3. Check if AFL was already cloned."
if [ ! -d "AFLplusplus" ] ; then
    echo "Cloning AFL++"
    git clone --branch v4.21c https://github.com/AFLplusplus/AFLplusplus.git
fi

echo "Extracting seed corpus"
tar -xvf seeds.tar.gz

echo "Setting up fuzzing environment"
docker run -v "${MODEM_DIR}":/firmwire/modem_files \
    -v ./result:/opt/setup/result \
    -v "${FIRMWIRE_DIR}":/opt/setup/firmwire \
    -v ./scripts:/opt/setup/scripts \
    -v ./AFLplusplus:/opt/setup/AFLplusplus \
    --tty --interactive --rm \
    --entrypoint /opt/setup/scripts/0__setup_fuzzing.sh \
    simurai/setup_3:1.0.0 \