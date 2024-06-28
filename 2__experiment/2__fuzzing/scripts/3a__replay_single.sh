#!/bin/bash

echo "Starting pcscd"
pkill pcscd;
pcscd;

echo "Starting SIMurai"
cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1  &
sleep 1 # Sleep required to allow pcscd to find swsim

cd /opt/setup/firmwire

echo "Replaying $1"

SIMURAI_USAT_FUZZ=1 \
    python3 -u ./firmwire.py \
    /firmwire/modem_files/XT1970-3_KANE_RETEU_11_RSA31.Q1-48-36-23.bin \
    --restore-snapshot usat_fuzz \
    --fuzz-triage usat \
    --fuzz-input /firmwire/replay/$1 \
    2>&1 | tee "/opt/setup/result/replay_${1}.log" \
    ; 