#!/bin/bash
make ARCH=riscv64-rocket
scp build/rwcp-riscv64-rocket.bin root@10.30.5.42:/root/zcq/pard
