#!/bin/bash

clear

rm -rf ../results/overall_iostat.txt
rm -rf ../results/iostat.txt

# FIO Variables
fio_blocksize="512K"
file_size="500G"
iodepth="64"
rread=70
rwrite=30
numjob="1"

filename="/dev/bcache0"

#echo "start statistic"
#./statistic.sh &
#./iostat.sh &

echo "$hit % Hit_${fio_blocksize} ${iodev}"
fio --direct=1 --size=100% --filesize=${file_size} --blocksize=${fio_blocksize} --ioengine=libaio -thread --rw=randwrite  --iodepth=${iodepth} --numjob=${numjob} --group_reporting --filename=${filename} --name=test  --output=../results/overall_iostat.txt


pkill -f statistic.sh &
pkill -9 iostat


