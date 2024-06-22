#!/bin/bash

echo "Build AFL++"
cd /opt/setup/AFLplusplus && make -j $(nproc) 

echo "Starting pcscd"
pkill pcscd;
pcscd;

echo "Starting SIMurai"
cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1  &
sleep 1 # Sleep required to allow pcscd to find swsim

echo "Building fuzzing tasks"
cd /opt/setup/firmwire/modkit && make

echo "Getting FirmWire snapshot"
cd /opt/setup/firmwire
python3 -u ./firmwire.py \
    /firmwire/modem_files/XT1970-3_KANE_RETEU_11_RSA31.Q1-48-36-23.bin \
    --fuzz-triage usat \
    --fuzz-input /tmp/not_existing \
    --snapshot-at 0x41bdeb1b,usat_fuzz \
    2>&1 | tee /opt/setup/result/firmwire_snapshot.log