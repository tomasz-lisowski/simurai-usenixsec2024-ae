#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0"))";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;
source ${UTIL}/check_network_local.sh;

printf "Please select a setup/experiment/case study to install: ${CCYN}S1${CDEF}, ${CCYN}S2${CDEF}, ${CCYN}S3${CDEF}, ${CCYN}E1${CDEF}, ${CCYN}E2${CDEF}, ${CCYN}CS1${CDEF}, ${CCYN}CS2${CDEF}.\\n" >&2;
read -p "> " selection;
case "$selection" in
    S1 )
        check "If we can uninstall setup 1.";
        (./1__setup/1__physical_ue/3__uninstall.sh "${NETWORK__LOCAL}");
        if ! checkResult "$?" "Setup 1 was uninstalled." "Setup 1 failed to uninstall."; then
            exit 1;
        fi
        ;;
    S2 )
        check "If we can uninstall setup 2.";
        (./1__setup/2__srsue/3__uninstall.sh);
        if ! checkResult "$?" "Setup 2 was uninstalled." "Setup 2 failed to uninstall."; then
            exit 1;
        fi
        ;;
    S3 )
        check "If we can uninstall setup 3.";
        (./1__setup/3__emulated_ue/3__uninstall.sh);
        if ! checkResult "$?" "Setup 3 was uninstalled." "Setup 3 failed to uninstall."; then
            exit 1;
        fi
        ;;
    E1 )
        check "If we can uninstall experiment 1.";
        (./2__experiment/1__spyware/3__uninstall.sh "${NETWORK__LOCAL}");
        if ! checkResult "$?" "Experiment 1 was uninstalled." "Experiment 1 failed to uninstall."; then
            exit 1;
        fi
        ;;
    E2 )
        check "If we can uninstall experiment 2.";
        (./2__experiment/2__fuzzing/4__uninstall.sh);
        if ! checkResult "$?" "Experiment 2 was uninstalled." "Experiment 2 failed to uninstall."; then
            exit 1;
        fi
        ;;
    * ) printf "%sInvalid%s.\\n" ${CRED} ${CDEF} >&2; exit 1;;
esac


