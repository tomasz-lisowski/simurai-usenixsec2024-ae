#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/1__physical_ue";

readonly NETWORK__CHOICE="${1:?Argument 1 is missing: Expected a selection for the type of setup to run: remote (1), local (0), hybrid (2).}";
readonly FLASH_SIMTRACE2="${2:-"1"}"; # False by default to not degrade flash, but this can cause the setup not to work.
readonly FLASH_FW="${3:-"1"}"; # False by default to not degrade flash.
readonly LOAD_FPGA="${4:-"0"}"; # True by default.
readonly EXPERIMENT_2="${5:-"1"}"; # False by default.

pushd .;
cd ${HERE};

mkdir ${HERE}/log;

readonly UE1_ID=ZY3266BBFL; # UE + SIMurai
readonly UE2_ID=ZY32659ZX5; # UE + sysmoUSIM

if [ ${NETWORK__CHOICE} -eq 1 ] || [ ${NETWORK__CHOICE} -eq 2 ]; then
    printf "\\nTo inspect the phones remotely, please ensure that the 'scrcpy' ports are forwarded:\\n${CBLU}ssh -i <key_file> -p 20242 -CN -L5038:localhost:5037 -R27183:localhost:27183 <username>@<host>${CDEF}\\n\\nOnce this is running, you can view the screens of the phones with the following:\\n${CBLU}export ADB_SERVER_SOCKET=tcp:localhost:5038${CDEF}\\n${CBLU}scrcpy -s ${UE1_ID}${CDEF}\\n${CBLU}scrcpy -s ${UE2_ID}${CDEF}\\n";
    read -p "Press any key to continue... You will only be able to inspect the phones once the setup is running.";
fi
if [ ${NETWORK__CHOICE} -eq 0 ]; then
    printf "\\nTo inspect the phones locally, you can view the screens of the phones with the following:\\n${CBLU}scrcpy -s ${UE1_ID}${CDEF}\\n${CBLU}scrcpy -s ${UE2_ID}${CDEF}\\nTo exit tmux, please press \"ctrl-b\" then \":\" then  type in \"kill-session\" and press enter. Alternatively you can use the 'exit' command in each terminal.\\n";
    read -p "Press any key to continue... You will only be able to inspect the phones once the setup is running.";
fi
if [ ${NETWORK__CHOICE} -eq 2 ] || [ ${NETWORK__CHOICE} -eq 0 ]; then
    # check "If a swICC PC/SC reader is installed.";
    # checkFile "/etc/reader.conf.d/libswicc-pcsc" && checkFile "/usr/lib/pcsc/drivers/serial/lib/libswicc-pcsc.so.1.2.0";
    # if ! checkResult "$?" "swICC PC/SC reader installed." "swICC PC/SC reader is missing. Make sure to install setup 1 before running this experiment."; then
    #     exit 1;
    # fi

    check "If a SIMtrace2 device is present.";
    simtrace2-list;
    if ! checkResult "$?" "A SIMtrace2 device is present." "No SIMtrace2 devices are attached, make sure to plug in the SIMtrace2 before running the experiment."; then
        exit 1;
    fi

    if [ ${FLASH_SIMTRACE2} -eq 0 ]; then
        check "SIMtrace2 cardem firmware will be flashed.";
        dfu-util --device 1d50:60e3 --cfg 1 --alt 1 --reset --download ""${HERE}"/result/home/simtrace-cardem-dfu-latest.bin";
        if ! checkResult "$?" "SIMtrace2 cardem firmware was flashed." "SIMtrace2 cardem firmware flashing failed."; then
            exit 1;
        fi
    else
        printf "SIMtrace2 cardem firmware will not be flashed. %sYou need to do this at least one, otherwise it can cause the experiment not to work!%s\\n" "${CRED}" "${CDEF}";
    fi

    if [ ${NETWORK__CHOICE} -eq 0 ]; then
        check "If BladeRF is attached.";
        bladeRF-cli -p;
        if ! checkResult "$?" "BladeRF attached." "BladeRF not attached."; then
            exit 1;
        fi

        if [ ${FLASH_FW} -eq 0 ]; then
            check "If FX3 firmware was flashed.";
            bladeRF-cli --flash-firmware ""${HERE}"/result/home/bladeRF_fw_v2.2.0.img";
            if ! checkResult "$?" "FX3 firmware was flashed." "FX3 firmware flashing failed."; then
                exit 1;
            fi
        else
            printf "FX3 firmware will not be flashed.\\n";
        fi

        if [ ${LOAD_FPGA} -eq 0 ]; then
            check "FPGA bitstream will be loaded.";
            bladeRF-cli --load-fpga ""${HERE}"/result/home/hostedxA4.rbf";
            if ! checkResult "$?" "FPGA bitstream was loaded." "FPGA bitstream loading failed."; then
                exit 1;
            fi
        else
            printf "FPGA bitstream will not be loaded.\\n";
        fi
    fi

    read -p "We are about to start the setup. Remember: to exit tmux, please press \"ctrl-b\" then \":\" then  type in \"kill-session\" and press enter. Alternatively you can use the 'exit' command in each terminal. Press any key to continue...";

    pkill pcscd;
    pcscd;
    adb kill-server;

    mkdir -p ""${HERE}"/log";
    mkdir -p ""${ROOT}"/2__experiment/1__spyware/log";

    if [ ${NETWORK__CHOICE} -eq 0 ]; then
        tmux new-session -d -s main "sudo su root";
    else
        tmux new-session -d -s main;
    fi
    if [ ${NETWORK__CHOICE} -eq 0 ]; then
        tmux send-keys "sudo yate 2>&1 | tee ""${HERE}"/log/yate.log"" 'C-m';
    else
        tmux send-keys "/bin/bash -c ""${HERE}"/msg__nonet.sh"" 'C-m';
    fi
    tmux select-window -t main:0;
    tmux split-window -h;
    if [ ${EXPERIMENT_2} -eq 0 ]; then
        tmux send-keys "sleep 1 && cd ""${ROOT}"/2__experiment/1__spyware/simurai/swsim" && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ""${ROOT}"/2__experiment/1__spyware/fs.simfs" --fs-gen ./data/usim.json 2>&1 | tee ""${ROOT}"/2__experiment/1__spyware/log/simurai.log"" 'C-m';
    else
        tmux send-keys "sleep 1 && cd ""${HERE}"/simurai/swsim" && ./build/swsim.elf --ip 127.0.0.1 --port 37324 --fs ""${HERE}"/fs.simfs" --fs-gen ./data/usim.json 2>&1 | tee ""${HERE}"/log/simurai.log"" 'C-m';
    fi
    tmux split-window -v -t 0
    if [ ${EXPERIMENT_2} -eq 0 ]; then
        tmux send-keys "sleep 4 && simtrace2-cardem-pcsc --pcsc-reader-num=0 --usb-vendor=1d50 --usb-product=60e3 --usb-config=1 --usb-altsetting=0 2>&1 | tee ""${ROOT}"/2__experiment/1__spyware/log/simtrace2.log"" 'C-m';
    else
        tmux send-keys "sleep 4 && simtrace2-cardem-pcsc --pcsc-reader-num=0 --usb-vendor=1d50 --usb-product=60e3 --usb-config=1 --usb-altsetting=0 2>&1 | tee ""${HERE}"/log/simtrace2.log"" 'C-m';
    fi
    tmux split-window -v -t 2;
    tmux send-keys "adb -a nodaemon server start" 'C-m';
    tmux -2 attach-session -t main;
fi

popd;
exit 0;
