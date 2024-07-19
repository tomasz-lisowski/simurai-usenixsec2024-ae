#!/bin/bash
adb start-server;
sleep 1;

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
