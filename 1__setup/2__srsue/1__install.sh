#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/1__setup/2__srsue;

pushd .;
cd ${HERE};

check "If SIMurai can be downloaded.";
simuraiDownload "${HERE}/docker/simurai";
if ! checkResult "$?" "SIMurai was downloaded." "SIMurai failed to download."; then
    exit 1;
fi

pushd .;
check "If SIMurai docker image can be built.";
cd ${HERE}/docker/simurai;
(./docker.sh);
if ! checkResult "$?" "SIMurai docker image was built." "Failed to build SIMurai docker image."; then
    exit 1;
fi
popd;

check "If setup 2 image was built.";
cd ./docker;
docker build --progress=plain . -t simurai/s2:1.0.0 2>&1 | tee docker.log;
if ! checkResult "$?" "Setup 2 image built." "Failed to build setup 2 image."; then
    exit 1;
fi

popd;
exit 0;
