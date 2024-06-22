#!/bin/bash
readonly ROOT=$(dirname "$0");
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
source ${UTIL}/check_root.sh;
source ${UTIL}/check_platform.sh;
source ${UTIL}/check_docker.sh;

printf "%sRUN%s Build setup 1.\\n" ${CRUN} ${CDEF};
read -p "Press enter to run step...";
pushd .;
cd ./1__setup;
cd ./2__srsue;
./1__build.sh;
popd;
printf "  %sDONE%s.\\n" ${CPASS} ${CDEF};

printf "%sRUN%s Build setup 2.\\n" ${CRUN} ${CDEF};
read -p "Press enter to run step...";
pushd .;
cd ./1__setup;
cd ./3__emulated_ue;
./1__build.sh;
popd;
printf "  %sDONE%s.\\n" ${CPASS} ${CDEF};
