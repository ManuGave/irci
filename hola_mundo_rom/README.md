# ROM Hola Mundo RTM32

Esta carpeta es independiente del resto del proyecto y contiene una ROM
minima que solo imprime `Hola, mundo!` por la UART del procesador.

## Ejecutar

Desde esta carpeta:

```bash
./run.sh
```

La salida esperada es:

```text
Hola, mundo!
```

## Archivos

- `hola_mundo.rtm`: fuente ensamblador.
- `hola_mundo.bin`: imagen MDBG que se carga en RTM32.
- `x86_64-linux-musl-rtm32.asm`: ensamblador para regenerar la imagen.
- `rtm32`: emulador RTM32 compatible.
- `run.sh`: lanzador autocontenido.
