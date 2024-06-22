#!/bin/bash
export ADB_SERVER_SOCKET=tcp:localhost:5038

# UE1
scrcpy -s ZY3266BBFL &

sleep 5
# UE2
scrcpy -s ZY32659ZX5 &