#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0"))";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;
source ${UTIL}/check_network_local.sh;

printf "Please select a setup/experiment/case study to run: ${CCYN}S1${CDEF}, ${CCYN}S2${CDEF}, ${CCYN}S3${CDEF}, ${CCYN}E1${CDEF}, ${CCYN}E2${CDEF}, ${CCYN}CS1${CDEF}, ${CCYN}CS2${CDEF}.\\n" >&2;
read -p "> " selection;
case "$selection" in
    S1 ) "${ROOT}"/1__setup/1__physical_ue/2__run.sh "${NETWORK__CHOICE}";;
    S2 ) "${ROOT}"/1__setup/2__srsue/2__run.sh;;
    S3 ) "${ROOT}"/1__setup/3__emulated_ue/2__run.sh;;
    E1 ) "${ROOT}"/2__experiment/1__spyware/2__run.sh "${NETWORK__CHOICE}";;
    E2 ) "${ROOT}"/2__experiment/2__fuzzing/2__run.sh;;
    CS1 ) printf "CS1 doesn't have a run script.\\n" >&2;;
    CS2 ) printf "CS2 doesn't have a run script.\\n" >&2;;
    * ) printf "Invalid\\n" >&2; exit 1;;
esac
