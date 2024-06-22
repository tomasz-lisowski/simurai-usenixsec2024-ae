#!/bin/bash

# Run the first script (launch_tunnel.sh)
./scripts/ssh_tunnel.sh

# Check the exit status of the first script
if [ $? -ne 0 ]; then
    echo "ssh_tunnel.sh failed"
    exit 1
fi

sleep 0.5
# Run the second script (launch_scrcpy.sh)
./scripts/launch_scrcpy.sh

# Check the exit status of the second script
if [ $? -ne 0 ]; then
    echo "launch_scrcpy.sh failed"
    exit 1
fi

# If both scripts ran successfully
echo "Both scripts ran successfully"