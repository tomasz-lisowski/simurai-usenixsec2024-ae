#!/bin/bash
export SIMURAI_SKIP_ADB_CHECK="1";

readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/3__emulated_ue";

pushd .;
cd ${HERE};

rm -r ""${HERE}"/FirmWire";
rm -r ""${HERE}"/docker/simurai";
rm ""${HERE}"/FirmWire.tar.gz";
rm ""${HERE}"/docker/docker.log";

popd;
exit 0;
