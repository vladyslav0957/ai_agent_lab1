#!/usr/bin/env bash
set -e

echo "1. Компіляція та симуляція Verilog (Icarus Verilog)"
iverilog -o spi_tb.vvp spi_master.v spi_tb.v
vvp spi_tb.vvp

echo "2. Синтез проєкту для ПЛІС та підрахунок LUT / Flip-Flops"
yosys -p "read_verilog spi_master.v; synth_ice40 -top spi_master -json spi_synth.json; stat" > resources.txt

echo "3. Часовий аналіз (Timing Analysis, Fmax)"
nextpnr-ice40 --hx8k --package ct256 --json spi_synth.json --asc spi_routed.asc > timing.txt 2>&1

# проміжні службові файли видалити, щоб папка залишалася чистою
rm -f spi_tb.vvp spi_synth.json spi_routed.asc

echo "Готово! Створено файли: wave.vcd, resources.txt, timing.txt"