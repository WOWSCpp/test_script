#!/bin/bash


clear

rm -rf ../results/overall_iostat.txt
rm -rf ../results/iostat.txt

./iostat.sh  &
./statistic.sh &

fio write_ray.fio

pkill -f memory.sh &
pkill -f statistic.sh &
pkill -f trace.sh &
pkill -9 iostat
pkill -9 fio


