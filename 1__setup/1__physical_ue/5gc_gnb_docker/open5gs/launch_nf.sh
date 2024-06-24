#!/bin/bash

# Directory where configuration files are located
# config_dir="/open5gs/install/etc/open5gs"
config_dir="/open5gs/install/etc/open5gs"

# Array of processes to start with their respective configuration files
processes=(
    "open5gs-amfd $config_dir/amf.yaml"
    "open5gs-bsfd $config_dir/bsf.yaml"
    "open5gs-hssd $config_dir/hss.yaml"
    "open5gs-nrfd $config_dir/nrf.yaml"
    "open5gs-pcfd $config_dir/pcf.yaml"
    "open5gs-scpd $config_dir/scp.yaml"
    "open5gs-sgwud $config_dir/sgwu.yaml"
    "open5gs-smfd $config_dir/smf.yaml"
    "open5gs-udrd $config_dir/udr.yaml"
    "open5gs-ausfd $config_dir/ausf.yaml"
    "open5gs-mmed $config_dir/mme.yaml"
    "open5gs-nssfd $config_dir/nssf.yaml"
    "open5gs-pcrfd $config_dir/pcrf.yaml"
    "open5gs-sgwcd $config_dir/sgwc.yaml"
    "open5gs-udmd $config_dir/udm.yaml"
    "open5gs-upfd $config_dir/upf.yaml"
)

# Function to start a process and monitor it
start_process() {
    local process="$1"
    local config_file="$2"

    while true; do
        # Launch the process with its configuration file in background
        "$process" -c "$config_file" &

        # Capture the PID of the process
        local pid=$!

        # Monitor the process
        wait $pid
        echo "Process $process exited with status $?"

        # Sleep for 2 seconds before restarting
        sleep 2
    done
}

# Start each process
for process_config in "${processes[@]}"; do
    start_process $process_config &
done

# Wait for all processes to complete
wait