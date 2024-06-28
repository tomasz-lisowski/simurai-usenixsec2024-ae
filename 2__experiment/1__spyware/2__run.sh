#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
readonly HERE=${ROOT}/2__experiment/1__spyware;

pushd .;
cd ${HERE};

readonly UE1_ID=ZY3266BBFL;
readonly UE2_ID=ZY32659ZX5;

check "If a swICC PC/SC reader is installed.";
checkFile "/etc/reader.conf.d/libswicc-pcsc" && checkFile "/usr/lib/pcsc/drivers/serial/lib/libswicc-pcsc.so.1.2.0";
if ! checkResult "$?" "swICC PC/SC reader installed." "swICC PC/SC reader is missing. Make sure to install setup 1 before running this experiment."; then
    exit 1;
fi

check "If SIMtrace2 Cardem PC/SC is installed.";
which simtrace2-cardem-pcsc;
if ! checkResult "$?" "SIMtrace2 Cardem PC/SC is installed." "SIMtrace2 Cardem PC/SC is missing. Make sure to install setup 1 before running this experiment."; then
    exit 1;
fi

check "If a SIMtrace2 device is present.";
simtrace2-list;
if ! checkResult "$?" "A SIMtrace2 device is present." "No SIMtrace2 devices are attached, make sure to plug in the SIMtrace2 before running the experiment."; then
    exit 1;
fi

check "If PC/SC daemon can be restarted.";
pkill pcscd || true;
pcscd;
if ! checkResult "$?" "PC/SC daemon was restarted." "Failed to restart PC/SC daemon."; then
    exit 1;
fi

tmux new-session -d -s main;
tmux send-keys 'scrcpy -s ${UE1_ID}' 'C-m';
tmux select-window -t main:0;
tmux split-window -h;
tmux send-keys 'scrcpy -s ${UE2_ID}' 'C-m';
tmux split-window -v -t 0
tmux send-keys 'cd ${HERE}/simurai/swsim && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1 | tee simurai.log' 'C-m';
tmux split-window -v -t 2;
tmux send-keys 'simtrace2-cardem-pcsc --pcsc-reader-num=0 --usb-vendor=1d50 --usb-product=60e3 --usb-config=1 --usb-altsetting=0 2>&1 | tee simtrace2.log' 'C-m';
tmux -2 attach-session -t main;

popd;
