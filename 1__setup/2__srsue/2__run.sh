#!/bin/bash
if [ -z ${UTIL+x} ]; then
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
rm -rf ./result;
mkdir ./result;
sudo docker run --privileged -v ./result:/opt/setup/result --tty --interactive --rm simurai/setup_2:1.0.0;
popd;
