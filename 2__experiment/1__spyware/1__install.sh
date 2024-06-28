#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/1__spyware;

pushd .;
cd ${HERE};

check "If a patched copy of SIMtrace is already present.";
checkDir "${HERE}/simurai";
if ! checkResult "$?" "SIMurai already present." "SIMurai not present, need to copy."; then
    check "If we can make a copy of SIMurai that we will patch.";
    cp -r ${ROOT}/simurai ${HERE}/simurai;
    if ! checkResult "$?" "SIMurai copied successfully." "Failed to copy SIMurai."; then
        exit 1;
    fi

    pushd .;
    check "If we can patch SIMurai with spyware.";
    cd ${HERE}/simurai/swsim;
    git apply ${HERE}/spyware.patch;
    if ! checkResult "$?" "SIMurai patched successfully." "Failed to patch SIMurai."; then
        exit 1;
    fi
    popd;

    pushd .;
    check "If we can recompile spyware-patched SIMurai.";
    cd ${HERE}/simurai/swsim;
    docker run -v .:/opt/swsim --tty --interactive --rm tomasz-lisowski/swsim:1.0.0;
    if ! checkResult "$?" "Spyware-patched SIMurai recompiled." "Failed to recompile spyware-patched SIMurai."; then
        exit 1;
    fi
    popd;
fi

popd;
exit 0;
