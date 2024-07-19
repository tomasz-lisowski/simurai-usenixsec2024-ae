#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;

clear;
printf "${CRED}\\n\\nNetwork is running on a remote host.\\nPlease allow the different components to start, then you can proceed with using scrcpy to control the phones.\\nThe phone that has SIMurai attached to it, needs to be restarted before it will detect the SIM has been inserted. This is a side-effect of using SIMtrace2.\\n${CDEF}";
