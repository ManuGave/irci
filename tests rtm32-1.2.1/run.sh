#!/usr/bin/env bash
# Ensambla un programa .rtm con rtm32.asm 1.2.1 y lo ejecuta en el emulador RTM32.
# Uso: ./run.sh [programa.rtm]   (por defecto: estadisticas.rtm)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROGRAMA="${1:-estadisticas.rtm}"
PROGRAMA="$(basename "$PROGRAMA" .rtm)"

for f in rtm32 rtm32.asm "$PROGRAMA.rtm"; do
    if [[ ! -f "$ROOT_DIR/$f" ]]; then
        printf 'Error: no se encontro %s\n' "$ROOT_DIR/$f" >&2
        exit 1
    fi
done

docker run --rm \
    --volume "$ROOT_DIR:/work" \
    --workdir /work \
    --env PROGRAMA="$PROGRAMA" \
    ubuntu:22.04 \
    bash -c '
        set -e
        ./rtm32.asm "$PROGRAMA.rtm" -o "$PROGRAMA.bin"

        apt-get update -qq
        apt-get install -y -qq telnet >/dev/null 2>&1

        ./rtm32 -d telnet -p 4444 -x 0x00000000 >/dev/null 2>&1 &
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
            echo "load /work/$PROGRAMA.bin"
            sleep 1
            echo "c"
            sleep 5
        } | telnet localhost 4444 >/dev/null 2>&1 || true

        sleep 1
        kill "$CAT_PID" 2>/dev/null || true
        kill "$EMU_PID" 2>/dev/null || true
        wait "$EMU_PID" 2>/dev/null || true
    '
