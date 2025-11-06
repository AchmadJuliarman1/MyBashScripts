#!/usr/bin/env bash
# scan_ports.sh
# Usage: ./scan_ports.sh <IP> [start_port] [end_port] [concurrency] [timeout_seconds]
# Example: ./scan_ports.sh 192.168.1.10 1 1024 200 1

set -u

IP="${1:-}"
if [[ -z "$IP" ]]; then
  echo "Usage: $0 <IP> [start_port] [end_port] [concurrency] [timeout_seconds]"
  exit 1
fi

START_PORT="${2:-1}"
END_PORT="${3:-1024}"
MAX_JOBS="${4:-200}"       # concurrency
TIMEOUT_SEC="${5:-1}"      # seconds per attempt

if ! [[ "$START_PORT" =~ ^[0-9]+$ ]] || ! [[ "$END_PORT" =~ ^[0-9]+$ ]]; then
  echo "start_port and end_port harus angka."
  exit 2
fi

if (( START_PORT < 1 || END_PORT > 65535 || START_PORT > END_PORT )); then
  echo "Rentang port tidak valid. Harus antara 1 dan 65535."
  exit 3
fi

echo "Scanning $IP ports $START_PORT..$END_PORT (concurrency=$MAX_JOBS, timeout=${TIMEOUT_SEC}s)..."
open_ports=()

# function to probe a single port
probe_port() {
  local ip="$1"; local port="$2"; local to="$3"
  # Use timeout to avoid hanging. Redirect output away.
  if timeout "${to}" bash -c ">/dev/tcp/${ip}/${port}" &>/dev/null; then
    printf "%d\n" "$port"
  fi
}

# control concurrency using wait -n (bash 4.3+). Fallback to simple wait if not supported.
pids=()
jobs_running=0

for ((port=START_PORT; port<=END_PORT; port++)); do
  # start probe in background and capture output to temp file
  {
    result=$(probe_port "$IP" "$port" "$TIMEOUT_SEC")
    if [[ -n "$result" ]]; then
      echo "OPEN: $port"
      echo "$result" >> /tmp/scan_open_ports_$$
    fi
  } &

  ((jobs_running++))

  # throttle
  if (( jobs_running >= MAX_JOBS )); then
    # wait for any job to finish (requires bash 4.3+). If not available, wait for all.
    if wait -n 2>/dev/null; then
      ((jobs_running--))
    else
      wait
      jobs_running=0
    fi
  fi
done

# wait remaining
wait

# collect results
if [[ -f /tmp/scan_open_ports_$$ ]]; then
  echo
  echo ">>> Daftar port terbuka di $IP:"
  sort -n /tmp/scan_open_ports_$$ | uniq
  rm -f /tmp/scan_open_ports_$$
else
  echo
  echo "Tidak ditemukan port terbuka di rentang yang dipindai (atau semua tertutup/filtered)."
fi
