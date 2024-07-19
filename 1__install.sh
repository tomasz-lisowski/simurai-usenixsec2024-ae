#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0"))";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;
source ${UTIL}/check_network_local.sh;

printf "%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n" \
    "Please select a setup/experiment/case study to install. Advise the appendix for any hardware dependencies." \
    "Select one of the following options:" \
    " - \"${CCYN}S1${CDEF}\": Setup 1 for physical UE." \
    " - \"${CCYN}S2${CDEF}\": Setup 2 uses the emulation capabilities of srsRAN, srsUE, and SIMurai to create an emulated network, UE, and SIM (respectively)." \
    " - \"${CCYN}S3${CDEF}\": Uses the FirmWire emulation platform and SIMurai to emulate a COTS UE baseband with SIMurai attached to it as the SIM." \
    " - \"${CCYN}E1${CDEF}\": Demonstrates a spyware that extracts location information from UE1, and sends this, via SMS, to UE2 (without making user of UE1 aware of the infiltration)." \
    " - \"${CCYN}E2${CDEF}\": Demonstrates SIMurai-aided fuzzing." \
    " - \"${CCYN}CS1${CDEF}\": Demonstrates how an interposer inserted inbetween the UE and SIM (in this case SIMurai), can manipulate and monitor data sent between the two devices." \
    " - \"${CCYN}CS2${CDEF}\": Demonstrates how a rogue carrier may covertly install and remove spyware from a deployed SIM, easily, and at any time." >&2;
read -p "> " selection;
case "$selection" in
    S1 )
        check "Install setup 1.";
        (./1__setup/1__physical_ue/1__install.sh "${NETWORK__CHOICE}");
        if ! checkResult "$?" "Setup 1 was installed." "Setup 1 failed to install."; then
            exit 1;
        fi
        ;;
    S2 )
        check "Install setup 2.";
        (./1__setup/2__srsue/1__install.sh);
        if ! checkResult "$?" "Setup 2 was installed." "Setup 2 failed to install."; then
            exit 1;
        fi
        ;;
    S3 )
        check "Install setup 3.";
        (./1__setup/3__emulated_ue/1__install.sh);
        if ! checkResult "$?" "Setup 3 was installed." "Setup 3 failed to install."; then
            exit 1;
        fi
        ;;
    E1 )
        check "Install experiment 1.";
        (./2__experiment/1__spyware/1__install.sh);
        if ! checkResult "$?" "Experiment 1 was installed." "Experiment 1 failed to install."; then
            exit 1;
        fi
        ;;
    E2 )
        check "Install experiment 2.";
        (./2__experiment/2__fuzzing/1__install.sh);
        if ! checkResult "$?" "Experiment 2 was installed." "Experiment 2 failed to install."; then
            exit 1;
        fi
        ;;
    CS1 ) printf "Nothing needs to be done.\\n"; exit 0;;
    CS2 ) printf "Nothing needs to be done.\\n"; exit 0;;
    * ) printf "%sInvalid%s.\\n" ${CRED} ${CDEF} >&2; exit 1;;
esac
