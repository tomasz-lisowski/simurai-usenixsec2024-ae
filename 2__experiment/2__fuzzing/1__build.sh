#!/bin/bash
if [ -z ${ROOT+x} ]; then
    readonly ROOT=$(dirname "$0")/../..;
    readonly UTIL=${ROOT}/util;
    source ${UTIL}/preamble.sh;
    source ${UTIL}/check_root.sh;
    source ${UTIL}/check_platform.sh;
    source ${UTIL}/check_docker.sh;
fi
readonly HERE=${ROOT}/2__experiment/2__fuzzing;
readonly SETUP_3=${ROOT}/1__setup/3__emulated_ue;
readonly MODEM="${SETUP_3}/modem_files";
readonly FIRMWIRE="${SETUP_3}/FirmWire";

printf "%sCHECK%s Setup 3 docker image was built.\\n" ${CCHK} ${CDEF};
if ! docker image inspect simurai/setup_3:1.0.0 > /dev/null 2>&1 ; then
    printf "  %sFAIL%s. SIMurai setup3 not found. Please run '${ROOT}/1__install.sh'.\\n" ${CFAIL} ${CDEF};
    exit 1;
else
    printf "  %sPASS%s.\\n" ${CPASS} ${CDEF};
fi

printf "%sCHECK%s Check if AFL was already cloned.\\n" ${CCHK} ${CDEF};
if [ ! -d "AFLplusplus" ] ; then
    printf "  %sFAIL%s. Need to clone AFL++.\\n" ${CFAIL} ${CDEF};
    printf "  %sRUN%s. Cloning AFL++.\\n" ${CRUN} ${CDEF};
    git clone --branch v4.21c https://github.com/AFLplusplus/AFLplusplus.git;
    printf "  %sPASS%s.\\n" ${CPASS} ${CDEF};
else
    printf "  %sPASS%s.\\n" ${CPASS} ${CDEF};
fi

printf "%sRUN%s Extract seed corpus.\\n" ${CRUN} ${CDEF};
tar -xvf seeds.tar.gz;

echo "Setting up fuzzing environment"
docker run -v "${MODEM}":/firmwire/modem_files \
    -v ./result:/opt/setup/result \
    -v "${FIRMWIRE}":/opt/setup/firmwire \
    -v ./scripts:/opt/setup/scripts \
    -v ./AFLplusplus:/opt/setup/AFLplusplus \
    --tty --interactive --rm \
    --entrypoint /opt/setup/scripts/0__setup_fuzzing.sh \
    simurai/setup_3:1.0.0 \
