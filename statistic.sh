#!/bin/bash

clear
rm -rf ../results/bcache_stat.txt

sleep 5
uuid=`bcache-super-show -f /dev/nvme0n1p1 | grep cset.uuid | awk '{ print $2 }'`


for i in {1..1000000}
	do
		# cache	
		block_size=`cat /sys/fs/bcache/${uuid}/block_size`
		bucket_size=`cat /sys/fs/bcache/${uuid}/bucket_size`
		btree_size=`cat /sys/fs/bcache/${uuid}/btree_cache_size`
		cache_available_percent=`cat /sys/fs/bcache/${uuid}/cache_available_percent`
		average_key_size=`cat /sys/fs/bcache/${uuid}/average_key_size`


		cache_res="cache info: block_size : $block_size, bucket_size : $bucket_size, btree_size : $btree_size, cache_available_percent : $cache_available_percent, average_key_size : $average_key_size"



		# backing

		bypassed=`cat /sys/fs/bcache/${uuid}/stats_total/bypassed`
		cache_hits=`cat /sys/fs/bcache/${uuid}/stats_total/cache_hits`
		cache_hit_ratio=`cat /sys/fs/bcache/${uuid}/stats_total/cache_hit_ratio`
		cache_misses=`cat /sys/fs/bcache/${uuid}/stats_total/cache_misses`

		backing_res="backing info: bypassed : $bypassed, cache_hits : $cache_hits, cache_hit_ratio : $cache_hit_ratio, cache_misses : $cache_misses"


		#echo $cache_res
		#echo $backing_res
		echo $cache_res >> "../results/bcache_stat.txt"
		echo $backing_res >> "../results/bcache_stat.txt"




		sleep 1
	done


