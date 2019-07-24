#!/bin/bash


clear
rm -rf ../results/memory.txt
for i in {1..1000000}
        do
		read junk total used free shared buffers cached junk < <(free -m  | grep ^Mem)
		echo $used >> "../results/memory.txt"
		sleep 1
	done

