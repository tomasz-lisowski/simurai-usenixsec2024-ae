#!/bin/bash
export SIMURAI_SKIP_ADB_CHECK="1";

readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
source ${UTIL}/check_root.sh;

readonly HERE="${ROOT}/2__experiment/2__fuzzing"
readonly SETUP3="${ROOT}/1__setup/3__emulated_ue"
readonly MODEM="${SETUP3}/modem_files"
readonly FIRMWIRE="${SETUP3}/FirmWire"

pushd .;
cd ${HERE};

printf "%s\\n%s\\n%s\\n%s\\n\\n%s\\n%s\\n%s\\n%s\\n%s\\n\\n" \
    ${CRED} \
    "====================" \
    "= IMPORTANT NOTICE =" \
    "====================" \
    "This script is about to run afl-system-config for configuring the host setup for fuzzing" \
    "This significantly reduces the security of the system (e.g., by disabling ASLR)" \
    "Please ensure that this is acceptable for your current host and consider restarting after the fuzzing campaing" \
    "Please continue now or press CTRL+C to abort" \
    "" \
    "These changes will be unrolled upon a system reboot" \
    ${CDEF};
read -p "Press any key to continue...";

${HERE}/AFLplusplus/afl-system-config


docker run -v "${MODEM}":/firmwire/modem_files \
    -v ${HERE}/result:/opt/setup/result \
    -v "${FIRMWIRE}":/opt/setup/firmwire \
    -v ${HERE}/scripts:/opt/setup/scripts \
    -v ${HERE}/AFLplusplus:/opt/setup/AFLplusplus \
    -v ${HERE}/seeds:/firmwire/seeds \
    --tty --interactive --rm \
    --entrypoint /opt/setup/scripts/2__run_fuzzing.sh \
    simurai/s3:1.0.0 \
;
# AFL++ creates the out directory not world writeable and as root user, hence we fix it here.
chmod -R +rX ${HERE}/result/
popd;
exit 0;
