#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/color.sh;

clear;
printf "${CYEL}\\n\\nNetwork is running on a remote host.\\nPlease allow the different components to start, then you can proceed with using scrcpy to control the phones.\\nThe phone that has SIMurai attached to it, might need to be restarted before it will detect the SIM has been inserted. This is a side-effect of using SIMtrace2. Please be patient, it can take some time for the phone to connect to the cellular network and communicate with SIMurai.\\n${CDEF}";
read -p "";
