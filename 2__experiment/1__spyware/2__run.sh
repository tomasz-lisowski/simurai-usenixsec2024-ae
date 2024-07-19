#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/1__spyware;

readonly NETWORK__CHOICE="${1:?Argument 1 is missing: Expected a selection for the type of setup to run: remote (1), local (0), hybrid (2).}";
readonly FLASH_SIMTRACE2="${2:-"1"}"; # False by default to not degrade flash, but this can cause the setup not to work.
readonly FLASH_FW="${3:-"1"}"; # False by default to not degrade flash.
readonly LOAD_FPGA="${4:-"0"}"; # True by default.


pushd .;
cd ${HERE};

""${ROOT}"/1__setup/1__physical_ue/2__run.sh" "${NETWORK__CHOICE}" "${FLASH_SIMTRACE2}" "${FLASH_FW}" "${LOAD_FPGA}" 0;

popd;
