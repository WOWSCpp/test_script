#!/bin/bash


clear

rm -rf ../results/verify.txt

# FIO Variables
fio_blocksize="4K"
size="8G"
iodepth="64"
numjob="1"

#filename="/dev/bcache0:/dev/bcache1:/dev/bcache2:/dev/bcache3:/dev/bcache4:/dev/bcache5:/dev/bcache6:/dev/bcache7"

filename="/dev/nvme0n1p1"

echo "$hit % Hit_${fio_blocksize} ${iodev}"

fio --verify=crc32c --direct=1 --size=${size} --blocksize=${fio_blocksize} --ioengine=libaio -thread --rw=randwrite --iodepth=${iodepth} --numjob=${numjob} --filename=${filename} --output=../results/verify.txt --name=test



