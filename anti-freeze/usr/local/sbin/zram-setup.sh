#!/bin/bash
set -e
for z in /dev/zram*; do
  swapoff "$z" 2>/dev/null || true
  zramctl --reset "$z" 2>/dev/null || true
done
TOTAL=$(awk '/MemTotal/{printf "%d",$2*1024}' /proc/meminfo)
SIZE=$((TOTAL * 50 / 100))
ZDEV=$(zramctl --find --size "$SIZE" --algorithm zstd)
mkswap -U clear "$ZDEV"
swapon --priority 100 "$ZDEV"
