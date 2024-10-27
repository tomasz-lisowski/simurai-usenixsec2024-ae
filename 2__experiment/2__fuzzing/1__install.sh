#!/bin/bash
export SIMURAI_SKIP_ADB_CHECK="1";

readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;


readonly HERE="${ROOT}/2__experiment/2__fuzzing"
readonly SETUP3="${ROOT}/1__setup/3__emulated_ue"
readonly MODEM="${SETUP3}/modem_files"
readonly FIRMWIRE="${SETUP3}/FirmWire"

pushd .;
cd ${HERE};

check "If setup 3 docker image was built";
docker image inspect simurai/s3:1.0.0 > /dev/null 2>&1;
if ! checkResult "$?" "Setup 3 docker image exists." "Setup 3 docker image does not exist. Please run the install script first."; then
    exit 1;
fi

check "If AFL was already cloned";
checkDir "${HERE}/AFLplusplus";
if ! checkResult "$?" "AFL++ already cloned." "Need to clone AFL++."; then
    check "If we could clone AFL++.";
    git clone --depth 1 --branch v4.21c https://github.com/AFLplusplus/AFLplusplus.git;
    if ! checkResult "$?" "AFL++ cloned successfully." "AFL++ still missing after re-cloning."; then
        exit 1;
    fi
fi

check "If we can extract seed corpus.";
tar -xzf ${HERE}/seed.tar.gz;
if ! checkResult "$?" "Seed corpus extracted successfully." "Seed corpus failed to extract."; then
    exit 1;
fi

check "If we can setup the fuzzing environment.";
docker run -v ${MODEM}:/firmwire/modem_files \
    -v ${HERE}/result:/opt/setup/result \
    -v "${FIRMWIRE}":/opt/setup/firmwire \
    -v ${HERE}/scripts:/opt/setup/scripts \
    -v ${HERE}/AFLplusplus:/opt/setup/AFLplusplus \
    --tty --interactive --rm \
    --entrypoint /opt/setup/scripts/1__setup_fuzzing.sh \
    simurai/s3:1.0.0 \
;
if ! checkResult "$?" "Fuzzing environment setup was successful." "Failed to setup the fuzzing environment."; then
    exit 1;
fi

popd;
exit 0;
