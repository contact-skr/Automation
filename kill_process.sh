#!/bin/bash

# Function to kill processes matching a pattern
kill_processes() {
    local pattern="$1"
    local signal="${2:-TERM}"  # Default to SIGTERM if no signal specified

    # Find PIDs of processes matching the pattern
    pids=$(pgrep -f "$pattern")

    if [ -z "$pids" ]; then
        echo "No processes found matching: $pattern"
        return
    fi

    echo "Found processes matching: $pattern"
    echo "PIDs: $pids"

    # Kill each process
    for pid in $pids; do
        echo "Killing process $pid with signal $signal"
        kill -"$signal" "$pid"
    done

    # Wait a moment to allow processes to terminate
    sleep 1

    # Check if any processes are still running
    remaining_pids=$(pgrep -f "$pattern")
    if [ -n "$remaining_pids" ]; then
        echo "Some processes are still running. PIDs: $remaining_pids"
        echo "You may want to use a stronger signal or check these processes manually."
    else
        echo "All matching processes have been terminated."
    fi
}

# Main script

# Check if a pattern is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <process_pattern> [signal]"
    echo "Example: $0 'python script.py' KILL"
    exit 1
fi

# Get the process pattern from the first argument
pattern="$1"

# Get the signal from the second argument (optional)
signal="${2:-TERM}"

# Call the function to kill processes
kill_processes "$pattern" "$signal"
