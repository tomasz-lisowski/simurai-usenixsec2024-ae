#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/2__fuzzing;

pushd .;
cd ${HERE};

rm -r ${HERE}/seeds;
rm -r ${HERE}/AFLplusplus;

popd;

printf "Local uninstallation done. ${CRED}To revert changes of afl-system-config, please reboot the system.${CDEF}\\n";

exit 0;
