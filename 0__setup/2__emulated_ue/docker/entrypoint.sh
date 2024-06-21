#!/bin/bash

EXPERIMENT_RUNTIME=180
SIMURAI_ICCID="988812010000500180F4"

printf "\\n\\nSIMurai Artifact Evaluation: Setup 3 (FirmWire + SIMurai).\\n";
read -p "Press enter to run step...";

printf "\\n\\n0. swSIM test suite.\\n";
read -p "Press enter to run step...";

cd /opt/setup/simurai/swsim;
./build/test.elf;

printf "\\n\\n1. swICC test suite.\\n";
read -p "Press enter to run step...";

cd /opt/setup/simurai/swicc;
./build/test.elf;

printf "\\n\\n2. Run the emulated baseband with SIMurai.\\n";
printf "\t This experiment will terminate after %d seconds\\n" $EXPERIMENT_RUNTIME;
read -p "Press enter to run step...";

pkill pcscd;
pcscd;

tmux new-session -d -s main;
sleep $EXPERIMENT_RUNTIME && tmux kill-session -t main & # Terminate experiment after expected runtime
tmux send-keys 'cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1 | tee /opt/setup/result/simurai.log' 'C-m';
sleep 1 # give pcscd some time to SIMurai.
tmux select-window -t main:0;
tmux split-window -h;
tmux send-keys 'cd /opt/setup/firmwire && python3 -u ./firmwire.py /firmwire/modem_files/XT1970-3_KANE_RETEU_11_RSA31.Q1-48-36-23.bin 2>&1 | tee /opt/setup/result/firmwire.log' 'C-m';
tmux -2 attach-session -t main;

printf "\\n\\n4. Checking FirmWire log for SIM communication.\\n";
read -p "Press enter to run step...";

N_RAPDU=`grep -a "PCSC RAPDU" /opt/setup/result/firmwire.log  | wc -l`
N_CAPDU=`grep -a "PCSC CAPDU" /opt/setup/result/firmwire.log  | wc -l`

printf "\n\nFound %d C-APDUs and %d R-APDUs!\n" $N_CAPDU $N_RAPDU
printf "Checking for SIMurais ICCID...\n"

grep -a "PCSC RAPDU" /opt/setup/result/firmwire.log  | grep $SIMURAI_ICCID > /dev/null

if [ $? -eq 0 ]; then
  printf "\033[0;32mFound! Experiment succeeded"
else
  printf "\033[0;31mNot found! Experiment failed"
fi
printf "\033[0m"


printf "\\n\\nAll experiments done!\n"
read -p "Press enter to exit...";