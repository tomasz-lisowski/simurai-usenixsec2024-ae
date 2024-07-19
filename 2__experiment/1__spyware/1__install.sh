#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/1__spyware;

readonly SIMURAI=""${HERE}"/simurai";

pushd .;
cd ${HERE};

check "If a patched copy of SIMtrace is already present.";
checkDir "${HERE}/simurai";
if ! checkResult "$?" "SIMurai already present." "SIMurai not present, need to copy."; then
    check "If SIMurai can be downloaded to \""${SIMURAI}"\".";
    simuraiDownload "${SIMURAI}";
    if ! checkResult "$?" "SIMurai was downloaded." "Failed to download SIMurai."; then
        exit 1;
    fi

    check "If SIMurai exists at \""${SIMURAI}"\".";
    checkDir "${SIMURAI}";
    if ! checkResult "$?" "SIMurai exists." "SIMurai is missing."; then
        exit 1;
    fi

    pushd .;
    check "If we can patch SIMurai with spyware.";
    cd "${SIMURAI}"/swsim;
    git apply ${HERE}/spyware.patch;
    if ! checkResult "$?" "SIMurai patched successfully." "Failed to patch SIMurai."; then
        exit 1;
    fi
    popd;

    pushd .;
    check "If we can recompile spyware-patched SIMurai.";
    (cd "${SIMURAI}"/swsim && ./docker.sh);
    if ! checkResult "$?" "Spyware-patched SIMurai recompiled." "Failed to recompile spyware-patched SIMurai."; then
        exit 1;
    fi
    popd;
fi

popd;
exit 0;
