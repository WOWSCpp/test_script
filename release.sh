#!/bin/bash

clear

var="$(sudo bcache-super-show /dev/nvme0n1p1 | grep cset.uuid)"
aaa=($var)

sudo chmod 777 /sys/block/bcache0/bcache/detach
sudo chmod 777 /sys/block/bcache1/bcache/detach
sudo chmod 777 /sys/block/bcache2/bcache/detach
sudo chmod 777 /sys/block/bcache3/bcache/detach
sudo chmod 777 /sys/block/bcache4/bcache/detach
sudo chmod 777 /sys/block/bcache5/bcache/detach
sudo chmod 777 /sys/block/bcache6/bcache/detach
sudo chmod 777 /sys/block/bcache7/bcache/detach

sudo bcache-super-show /dev/nvme0n1p1 | grep cset.uuid


echo cset.uuid > /sys/block/bcache0/bcache/detach
echo cset.uuid > /sys/block/bcache1/bcache/detach
echo cset.uuid > /sys/block/bcache2/bcache/detach
echo cset.uuid > /sys/block/bcache3/bcache/detach
echo cset.uuid > /sys/block/bcache4/bcache/detach
echo cset.uuid > /sys/block/bcache5/bcache/detach
echo cset.uuid > /sys/block/bcache6/bcache/detach
echo cset.uuid > /sys/block/bcache7/bcache/detach

echo 1 > /sys/block/bcache0/bcache/stop
echo 1 > /sys/block/bcache1/bcache/stop
echo 1 > /sys/block/bcache2/bcache/stop
echo 1 > /sys/block/bcache3/bcache/stop
echo 1 > /sys/block/bcache4/bcache/stop
echo 1 > /sys/block/bcache5/bcache/stop
echo 1 > /sys/block/bcache6/bcache/stop
echo 1 > /sys/block/bcache7/bcache/stop



echo 1 > /sys/block/sda/bcache/stop
echo 1 > /sys/block/sdb/bcache/stop
echo 1 > /sys/block/sdc/bcache/stop
echo 1 > /sys/block/sdd/bcache/stop
echo 1 > /sys/block/sde/bcache/stop
echo 1 > /sys/block/sdf/bcache/stop
echo 1 > /sys/block/sdg/bcache/stop
echo 1 > /sys/block/sdh/bcache/stop




echo 1 > /sys/fs/bcache/"${aaa[1]}"/stop

echo 1 > /sys/block/"${aaa[1]}"/bcache/set/unregister



#sudo chmod 777 /sys/block/bcache0/bcache/detach
#echo cset.uuid > /sys/block/bcache0/bcache/detach
#sudo chmod 777 /sys/block/bcache3/bcache/detach
#echo cset.uuid > /sys/block/bcache3/bcache/detach
#sudo chmod 777 /sys/block/bcache4/bcache/detach
#echo cset.uuid > /sys/block/bcache4/bcache/detach
