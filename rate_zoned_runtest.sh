#!/bin/bash


clear

rm -rf ../results/overall_iostat.txt
rm -rf ../results/iostat.txt

# FIO Variables
fio_blocksize="4K"
size="100G"
iodepth="64"
rread=80
rwrite=20
numjob="1"
rate_iops=80000

filename="/dev/bcache0:/dev/bcache1:/dev/bcache2:/dev/bcache3:/dev/bcache4:/dev/bcache5:/dev/bcache6:/dev/bcache7"

#filename="/dev/bcache0"

bssplit="4k/10:64K/40:16K/50"


echo "start statistic"
#./statistic.sh &
./iostat.sh &
./memory.sh &
#./trace.sh&

echo "$hit % Hit_${fio_blocksize} ${iodev}"
fio --rate_iops=${rate_iops} --direct=1 --size=${size} --blocksize=${fio_blocksize} --ioengine=libaio -thread --rw=randwrite --random_distribution=zoned:90/10:10/90 --iodepth=${iodepth} --numjob=${numjob} --group_reporting  --filename=${filename} --name=test  --output=../results/overall_iostat.txt

pkill -f memory.sh &
pkill -f statistic.sh &
pkill -f trace.sh &
pkill -9 iostat


