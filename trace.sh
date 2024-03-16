#!/bin/bash

# Function to enable tracing
enable_tracing() {
    iptables -t raw -A PREROUTING -p tcp --dport 9898 -j TRACE
    iptables -t raw -A OUTPUT -p tcp --dport 9898 -j TRACE
    echo "Tracing enabled."
}

# Function to disable tracing
disable_tracing() {
    iptables -t raw -D PREROUTING -p tcp --dport 9898 -j TRACE
    iptables -t raw -D OUTPUT -p tcp --dport 9898 -j TRACE
    echo "Tracing disabled."
}

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--trace) enable_tracing; exit 0 ;;
        -d|--untrace) disable_tracing; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Usage: $0 {-a|--trace|-d|--untrace}"
exit 1
