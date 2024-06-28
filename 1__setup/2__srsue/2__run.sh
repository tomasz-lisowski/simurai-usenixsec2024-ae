#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/1__setup/2__srsue;

pushd .;
cd ${HERE};

check "Run docker container.";
rm -rf ./log;
mkdir ./log;
docker run --privileged -v ./log:/opt/setup/log --tty --interactive --rm simurai/s2:1.0.0;
if ! checkResult "$?" "Setup ran successfully." "Failed to run setup."; then
    exit 1;
fi

popd;
exit 0;
