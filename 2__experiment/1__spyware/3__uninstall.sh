#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/1__spyware;

pushd .;
cd ${HERE};

rm -rf ""${HERE}"/simurai";
rm -f ""${HERE}"/fs.simfs";
rm -rf ""${HERE}"/log";

popd;
