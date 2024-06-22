#!/bin/bash

SETUP3_DIR="$PWD/../../0__setup/2__emulated_ue/"
MODEM_DIR="$SETUP3_DIR/modem_files/"
FIRMWIRE_DIR="$SETUP3_DIR/FirmWire/"


printf "\033[0;31m"
printf "====================\n"
printf "= IMPORTANT NOTICE = \n"
printf "====================\n\n"
printf "This script is about to run afl-system-config for configuring the host setup for fuzzing\n"
printf "This significantly reduces the security of the system (e.g., by disabling ASLR)\n"
printf "Please ensure that this is acceptable for your current host and consider restarting after the fuzzing campaing\n"
printf "Please continue now or press CTRL+C to abort\n\n"
printf "\033[0m"
read -p "Press any kay to continue...";

sudo ./AFLplusplus/afl-system-config


docker run -v "${MODEM_DIR}":/firmwire/modem_files \
    -v ./result:/opt/setup/result \
    -v "${FIRMWIRE_DIR}":/opt/setup/firmwire \
    -v ./scripts:/opt/setup/scripts \
    -v ./AFLplusplus:/opt/setup/AFLplusplus \
    -v ./seeds:/firmwire/seeds \
    --tty --interactive --rm \
    --entrypoint /opt/setup/scripts/1__run_fuzzing.sh \
    simurai/setup_3:1.0.0 \
