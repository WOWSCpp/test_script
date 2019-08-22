#!/bin/bash

clear
#~/test_scripts/release.sh
sudo cp ~/kernel/linux-5.2.4/drivers/md/bcache/bcache.ko /lib/modules/5.2.4-1.el7.elrepo.x86_64/kernel/drivers/md/
sudo depmod -a
rmmod /lib/modules/5.2.4-1.el7.elrepo.x86_64/kernel/drivers/md/bcache.ko
insmod /usr/lib/modules/5.2.4-1.el7.elrepo.x86_64/kernel/lib/crc64.ko
insmod /lib/modules/5.2.4-1.el7.elrepo.x86_64/kernel/drivers/md/bcache.ko
