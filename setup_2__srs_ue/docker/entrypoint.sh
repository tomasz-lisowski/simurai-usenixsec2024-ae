#!/bin/bash

printf "\\n\\nSIMurai Artifact Evaluation: Setup 2 (srsRAN + srsUE + SIMurai).\\n";
read -p "Press enter to run step...";

printf "\\n\\n0. swSIM test suite.\\n";
read -p "Press enter to run step...";

cd /opt/setup/simurai/swsim;
./build/test.elf;

printf "\\n\\n1. swICC test suite.\\n";
read -p "Press enter to run step...";

cd /opt/setup/simurai/swicc;
./build/test.elf;

printf "\\n\\n2. Run emulated network and UE with SIMurai.\\n";
read -p "Press enter to run step...";


pkill pcscd;
pcscd;
ip netns add ue1
ip netns list

tmux new-session -d -s main;
tmux send-keys 'cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1 | tee /opt/setup/result/simurai.log' 'C-m';
tmux select-window -t main:0;
tmux split-window -h;
tmux send-keys 'cd /opt/setup/srsran && ./srsepc/src/srsepc 2>&1 | tee /opt/setup/result/srsepc.log' 'C-m';
tmux split-window -v -t 0
tmux send-keys 'cd /opt/setup/srsran && ./srsenb/src/srsenb 2>&1 | tee /opt/setup/result/srsenb.log' 'C-m';
tmux split-window -v -t 2;
tmux send-keys 'cd /opt/setup/srsran && sleep 5 && ./srsue/src/srsue 2>&1 | tee /opt/setup/result/srsue.log' 'C-m';
tmux -2 attach-session -t main;

/bin/bash;
