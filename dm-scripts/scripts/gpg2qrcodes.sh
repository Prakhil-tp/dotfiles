#!/bin/bash
# Producing the QR codes:
gpg --export-secret-key 71432F9AE346AD4A | paperkey --output-type raw | base64 > temp
split temp -n 4 IMG
for f in IMG*; do cat $f | qrencode -o $f.png; done
