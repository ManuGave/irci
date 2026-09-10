#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -f "$ROOT_DIR/rtm32" ]]; then
    printf 'Error: no se encontro el emulador RTM32 en %s\n' "$ROOT_DIR/rtm32" >&2
    exit 1
fi

if [[ ! -f "$ROOT_DIR/hola_mundo.bin" ]]; then
    printf 'Error: no se encontro %s\n' "$ROOT_DIR/hola_mundo.bin" >&2
    exit 1
fi

docker run --rm \
    --volume "$ROOT_DIR:/emulator:ro" \
    --volume "$ROOT_DIR:/work:ro" \
    --workdir /work \
    ubuntu:22.04 \
    bash -c '
        apt-get update -qq
        apt-get install -y -qq telnet >/dev/null 2>&1

        /emulator/rtm32 -d telnet -p 4444 -x 0x00000000 >/dev/null 2>&1 &
        EMU_PID=$!

        for i in $(seq 1 50); do
            if [ -e /dev/pts/0 ]; then
                break
            fi
            sleep 0.1
        done

        cat /dev/pts/0 &
        CAT_PID=$!

        {
            sleep 1
            echo "load /work/hola_mundo.bin"
            sleep 1
            echo "c"
            sleep 5
        } | telnet localhost 4444 >/dev/null 2>&1

        sleep 1
        kill "$CAT_PID" 2>/dev/null || true
        kill "$EMU_PID" 2>/dev/null || true
        wait "$EMU_PID" 2>/dev/null || true
    '
