#!/bin/bash

clear

rm -rf ../results/iostat.txt

iostat -x 1 >> ../results/iostat.txt

