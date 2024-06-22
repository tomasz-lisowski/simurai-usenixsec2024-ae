#!/bin/bash
if [ -z ${ROOT+x} ]; then
    readonly ROOT=$(dirname "$0")/../..;
    readonly UTIL=${ROOT}/util;
    source ${UTIL}/preamble.sh;
    source ${UTIL}/check_root.sh;
    source ${UTIL}/check_platform.sh;
    source ${UTIL}/check_docker.sh;
fi
readonly HERE=${ROOT}/1__setup/2__srsue;

pushd .;
cd ${HERE};
cd ./docker;
sudo docker build --progress=plain . -t simurai/setup_2:1.0.0 2>&1 | tee build.log;
popd;
