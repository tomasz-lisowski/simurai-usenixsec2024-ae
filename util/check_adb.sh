#!/bin/bash

if [[ "${SIMURAI_SKIP_ADB_CHECK:-0}" -eq "1" ]]; then
    printf "%sSkipping ADB check.%s\n" "${CCHK}" "${CDEF}";
else

    adb start-server;

    # Make sure that server is up and devices had a chance to register
    sleep 3;

    check "If UE1 is connected and visible to ADB."
    adb -s "${UE1_SERIAL}" get-state;
    if ! checkResult "${?}" "UE1 is present." "Please plug in UE1. It is possible that you did not configure the serial number of UE1 correctly, take a look at \"util/adb_serial.sh\"."; then
        exit 1;
    fi

    check "If UE2 is connected and visible to ADB."
    adb -s "${UE2_SERIAL}" get-state;
    if ! checkResult "${?}" "UE2 is present." "Please plug in UE2. It is possible that you did not configure the serial number of UE2 correctly, take a look at \"util/adb_serial.sh\"."; then
        exit 1;
    fi

    adb kill-server;

fi