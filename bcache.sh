#!/bin/bash

clear

# Cache Variables
b1="/dev/sda1"
b2="/dev/sdb1"
b3="/dev/sdd1"
b4="/dev/sde1"
b5="/dev/sdf1"
b6="/dev/sdg1"
b7="/dev/sdh1"
b8="/dev/sdc1"

cache_device="/dev/nvme0n1p1"
cache_policy="lru"
cache_mode="wb"
cache_block_size="32768"
cache_bucket_size="512k"


bcache_create()
{
    echo "Formatting device"
   # sudo mkfs.ext4 ${b1}
   # sudo mkfs.ext4 ${b2}
   # sudo mkfs.ext4 ${b3}
   # sudo mkfs.ext4 ${b4}
   # sudo mkfs.ext4 ${b5}
   # sudo mkfs.ext4 ${b6}
   # sudo mkfs.ext4 ${b7}
   # sudo mkfs.ext4 ${b8}
    sudo mkfs.ext4 ${cache_device}

   # sudo wipefs -a ${b1}
   # sudo wipefs -a ${b2}
   # sudo wipefs -a ${b3}
   # sudo wipefs -a ${b4}
   # sudo wipefs -a ${b5}
   # sudo wipefs -a ${b6}
   # sudo wipefs -a ${b7}
   # sudo wipefs -a ${b8}
    sudo wipefs -a ${cache_device}

    #sudo blkdiscard ${b1}
    #sudo blkdiscard ${b2}
    #sudo blkdiscard ${b3}
    #sudo blkdiscard ${b4}
    #sudo blkdiscard ${b5}
    #sudo blkdiscard ${b6}
    #sudo blkdiscard ${b7}
    #sudo blkdiscard ${b8}
    sudo blkdiscard ${cache_device}

    sudo modprobe -f bcache
    echo "Creating a cache"
   
   # make-bcache -B ${b1}  -C ${cache_device} --bucket ${cache_bucket_size} --discard --writeback
    make-bcache -B ${b1}  ${b2} ${b3} ${b4} ${b5} ${b6} ${b7} ${b8} --wipe-bcache  -C ${cache_device} --bucket ${cache_bucket_size} --writeback

   # make-bcache -B ${source_device1} ${source_device2} ${source_device3} ${source_device4} -C ${cache_device} --bucket ${cache_bucket_size} --discard --writeback

    sleep 2
    if [ $cache_mode = "wb" ]; then
        echo "Setting cache mode: $cache_mode"
        sudo chmod 777 /sys/block/bcache0/bcache/cache_mode
	echo writeback > /sys/block/bcache0/bcache/cache_mode

    fi    

    sudo chmod 777 /sys/block/bcache0/bcache/sequential_cutoff
    echo 0 > /sys/block/bcache0/bcache/sequential_cutoff

    echo "cache $cache created successfully"
    return 0   
}



# Create a cache
bcache_create 
sleep 2

sudo chmod 777 /sys/fs/bcache/register
echo /dev/nvme0n1p1 > /sys/fs/bcache/register


var="$(sudo bcache-super-show /dev/nvme0n1p1 | grep cset.uuid)"
aaa=($var)
#echo 3 > /sys/fs/bcache/"${aaa[1]}"/internal/gc_after_writeback

sudo bcache-super-show /dev/nvme0n1p1
lsblk
cat /sys/block/bcache0/bcache/cache_mode
cat /sys/block/bcache0/bcache/state
tail /sys/block/bcache0/bcache/stats_total/*

