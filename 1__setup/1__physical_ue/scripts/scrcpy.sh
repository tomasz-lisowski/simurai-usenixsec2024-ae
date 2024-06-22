if [ -z "${UE1_ID}" ]; then
  echo "Set default UE1_ID"
  UE1_ID=ZY3266BBFL
fi

if [ -z "${UE2_ID}"]; then
  echo "Set default UE2_ID"
  UE2_ID=ZY32659ZX5
fi

# Check if the ports are being forwarded
if netstat -an | grep -q '5038.*LISTEN'; then
    echo "SSH tunnel working correctly"
    export ADB_SERVER_SOCKET=tcp:localhost:5038
else
    echo "Please open ssl tunnel first and keep it oepn"
    echo "SSH tunnel command:"
    echo '"ssh -i simurai_ae.key -p 20242 -CN -L5038:localhost:5037 -R27183:localhost:27183 setup1@65.21.243.117"'
    echo ""
    kill $SSH_PID
    exit 1
fi

scrcpy -s ${UE1_ID} &
sleep 5

scrcpy -s ${UE2_ID} &