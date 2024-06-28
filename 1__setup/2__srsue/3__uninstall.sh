#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/2__srsue";

pushd .;
cd ${HERE};

rm -r ""${HERE}"/docker/simurai";
rm ""${HERE}"/docker/docker.log";
rm -r ""${HERE}"/result";

popd;
exit 0;
