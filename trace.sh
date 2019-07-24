#!/bin/bash

clear

rm -rf /test_mnt/results/trace.txt

strace -f -p `pidof fio` &>> /test_mnt/results/trace.txt

