#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/1__physical_ue";

readonly NETWORK__LOCAL="${1:?Arg1 is missing: network remote (1) local (0).}";

pushd .;
cd ${HERE};

mkdir ${HERE}/log;

readonly UE1_ID=ZY3266BBFL;
readonly UE2_ID=ZY32659ZX5;

if ${NETWORK__LOCAL}; then
    check "If BladeRF is attached.";
    bladeRF-cli -p;
    if ! checkResult "$?" "BladeRF attached." "BladeRF not attached."; then
        exit 1;
    fi

    printf "\\nThe setup is local, if you would like to inspect the phones attached to the remote setup, you can view the screens of the phones with the following:\\n${CBLU}scrcpy -s ${UE1_ID}${CDEF}\\n${CBLU}scrcpy -s ${UE2_ID}${CDEF}\\n";
    read -p "Press any key to start the setup. Note that you will only be able to inspect the phones once the setup is running...";

    tmux new-session -d -s main;
    tmux send-keys "yate | tee ""${HERE}"/log/yate.log"" 'C-m';
    tmux select-window -t main:0;
    tmux split-window -h;
    tmux send-keys "pkill pcscd && pcscd && sleep 1 && cd ""${HERE}"/simurai/swsim" && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ./fs.simurai__fs --fs-gen ./data/usim.json 2>&1 | tee ""${HERE}"/log/simurai.log"" 'C-m';
    tmux split-window -v -t 0
    tmux send-keys "sleep 4 && simtrace2-cardem-pcsc --pcsc-reader-num=0 --usb-vendor=1d50 --usb-product=60e3 --usb-config=1 --usb-altsetting=0 2>&1 | tee ""${HERE}"/log/simtrace2.log"" 'C-m';
    tmux split-window -v -t 2;
    tmux send-keys "adb kill-server && adb -a nodaemon server start" 'C-m';
    tmux -2 attach-session -t main;
else
    printf "\\nThe setup is remote, if you would like to inspect the phones attached to the remote setup, please ensure that the 'scrcpy' ports are forwarded:\\n${CBLU}ssh -i <key_file> -p 20242 -CN -L5038:localhost:5037 -R27183:localhost:27183 <username>@<host>${CDEF}\\n\\nOnce this is running, you can view the screens of the phones with the following:\\n${CBLU}export ADB_SERVER_SOCKET=tcp:localhost:5038${CDEF}\\n${CBLU}scrcpy -s ${UE1_ID}${CDEF}\\n${CBLU}scrcpy -s ${UE2_ID}${CDEF}\\n";
    read -p "Press any key to continue...";
fi

popd;
exit 0;
