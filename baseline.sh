#!/bin/bash

clear

rm -rf ../results/overall_iostat.txt
rm -rf ../results/iostat.txt

# FIO Variables
fio_blocksize="512K"
file_size="16G"
iodepth="64"
numjob="1"

#filename="/dev/bcache0:/dev/bcache1:/dev/bcache2:/dev/bcache3:/dev/bcache4:/dev/bcache5:/dev/bcache6:/dev/bcache7"

filename="/dev/bcache0"

echo "start statistic"
#./statistic.sh &
./iostat.sh &
./memory.sh &

echo "$hit % Hit_${fio_blocksize} ${iodev}"
fio --direct=1 --size=100% --filesize=${file_size} --blocksize=${fio_blocksize} --ioengine=libaio -thread --rw=randrw --iodepth=${iodepth} --numjob=${numjob} --group_reporting  --filename=${filename} --name=test  --output=../results/overall_iostat.txt

pkill -f memory.sh &
pkill -f statistic.sh &
pkill -9 iostat


