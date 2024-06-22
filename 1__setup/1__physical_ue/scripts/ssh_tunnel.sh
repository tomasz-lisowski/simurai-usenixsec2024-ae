#!/bin/bash

# Run the SSH tunnel in the background using nohup
nohup ssh -CN -L5038:localhost:5037 -R27183:localhost:27183 setup1@65.21.243.117 -p 20242 > tunnel_setup.log 2>&1 &

# Capture the PID of the SSH command
SSH_PID=$!

# Give it a few seconds to start
sleep 2

# Check if the SSH command is still running
if ps -p $SSH_PID > /dev/null; then
    echo "SSH command is running with PID $SSH_PID"
else
    echo "SSH command failed to start"
    kill $SSH_PID
    exit 1
fi

# Check if the ports are being forwarded
if netstat -an | grep -q '5038.*LISTEN'; then
    echo "Successfully opened ssh tunnel"
else
    echo "Port forwarding failed"
    kill $SSH_PID
    exit 1
fi