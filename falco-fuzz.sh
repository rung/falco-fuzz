#!/bin/bash

echo '/tmp/core.%h.%e.%t' > /proc/sys/kernel/core_pattern
ulimit -c unlimited

cd /sys/devices/system/cpu
echo performance | tee cpu*/cpufreq/scaling_governor
afl-fuzz -i traces-positive/ -t 10000 -m 1024 -o output -- falco -r /usr/local/etc/falco/falco_rules.yaml -e @@
