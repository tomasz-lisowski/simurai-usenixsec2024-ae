#!/bin/bash
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -o errexit;  # Abort on non-zero exit status.

printf "\\nSIMurai Artifact Evaluation: Setup 2 (srsRAN + srsUE + SIMurai).\\n\\n";
read -p "Press enter to run step... ";
printf "\\n";

printf "Run emulated network and UE with SIMurai.\\n\\n";
read -p "Press enter to run step... ";
printf "\\n";

pkill pcscd || true;
pcscd;
ip netns add ue1
ip netns list
printf "\\n";

printf "We are using tmux to display multiple consoles at once. Use 'CTRL-b + d' to exit the tmux session once the experiment is finished. The experiment is finished when the upper left window (SIMurai) indicates 'Milenage: authenticated'.\\n\\n";
read -p "I understood the instructions and want to continue by pressing enter... ";
printf "\\n";

tmux new-session -d -s main;
tmux send-keys 'cd /opt/setup/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1 | tee /opt/setup/log/simurai.log' 'C-m';
tmux select-window -t main:0;
tmux split-window -h;
tmux send-keys 'cd /opt/setup/srsran && ./srsenb/src/srsenb 2>&1 | tee /opt/setup/log/srsenb.log' 'C-m';
tmux split-window -v -t 0
tmux send-keys 'cd /opt/setup/srsran && sleep 8 && ./srsue/src/srsue 2>&1 | tee /opt/setup/log/srsue.log' 'C-m';
tmux split-window -v -t 2;
tmux send-keys 'cd /opt/setup/srsran && ./srsepc/src/srsepc 2>&1 | tee /opt/setup/log/srsepc.log' 'C-m';
tmux -2 attach-session -t main;
