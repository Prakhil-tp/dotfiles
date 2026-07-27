#!/bin/bash
for z in /dev/zram*; do
  swapoff "$z" 2>/dev/null || true
  zramctl --reset "$z" 2>/dev/null || true
done
