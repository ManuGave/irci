# Tests RTM32 (assembler 1.2.1)

Carpeta autocontenida para ensamblar y ejecutar programas de prueba en RTM32.
Solo requiere Docker.

## Ejecutar

Desde esta carpeta:

```bash
./run.sh                      # ensambla y corre estadisticas.rtm
./run.sh otro_programa.rtm    # cualquier otro programa de esta carpeta
```

`run.sh` ensambla el `.rtm` (regenerando el `.bin`) y lo ejecuta en el
emulador, mostrando la salida de la UART.

## Programa: `estadisticas.rtm`

Dado un arreglo de 10 numeros, calcula suma, maximo, minimo y promedio
(division entera) y los imprime en decimal por la UART.

Con los datos `15 42 8 27 90 3 61 19 34 11` la salida esperada es:

```text
Suma:     310
Maximo:   90
Minimo:   3
Promedio: 31
```

Para probar otros valores, modificar la linea `.word` de `numeros` (y
`cantidad` si cambia la cantidad de elementos). Solo soporta numeros sin signo.

## Archivos

- `estadisticas.rtm`: fuente ensamblador.
- `estadisticas.bin`: imagen MDBG generada por el assembler.
- `rtm32.asm`: assembler 1.2.1 (x86_64-linux-musl, se usa dentro de Docker).
- `rtm32`: emulador RTM32.
- `run.sh`: ensambla y ejecuta.
- `rtm32.asm-1.2.1/`: distribucion original del assembler 1.2.1 (binarios para
  todas las plataformas y la guia `Assembler de RTM32.pdf`).
