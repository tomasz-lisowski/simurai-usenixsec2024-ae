#!/bin/bash

FUZZING_TIME=43200

export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1


echo "Starting pcscd"
pkill pcscd;
pcscd;

echo "Starting SIMurai"
cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1  &
sleep 1 # Sleep required to allow pcscd to find swsim

echo "Starting the fuzz for $FUZZING_TIME seconds"
cd /opt/setup/firmwire
timeout $FUZZING_TIME ../AFLplusplus/afl-fuzz -t 500 -i /firmwire/seeds -o /opt/setup/result/out -M main -U -- \
    python3 -u ./firmwire.py \
    /firmwire/modem_files/XT1970-3_KANE_RETEU_11_RSA31.Q1-48-36-23.bin \
    --restore-snapshot usat_fuzz \
    --fuzz usat \
    --fuzz-input @@ \
    --fuzz-persistent 100 \
    --consecutive-ports 11000