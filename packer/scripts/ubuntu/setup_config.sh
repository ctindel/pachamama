#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# turn down kswapd activity
echo "vm.swappiness=0" >> /etc/sysctl.conf
echo 1 > /proc/sys/vm/drop_caches

# Need to update this for running elasticsearch without failing bootstrap check
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# Increase open file descriptors for elasticsearch bootstrap checks
echo "fs.file-max=100000" >> /etc/sysctl.conf
echo "* soft nofile 1024000" >> /etc/security/limits.conf
echo "* hard nofile 1024000" >> /etc/security/limits.conf
echo "* soft memlock unlimited" >> /etc/security/limits.conf
echo "* hard memlock unlimited" >> /etc/security/limits.conf
echo "elastic soft nofile 1024000" >> /etc/security/limits.conf
echo "elastic hard nofile 1024000" >> /etc/security/limits.conf
echo "elastic soft memlock unlimited" >> /etc/security/limits.conf
echo "elastic hard memlock unlimited" >> /etc/security/limits.conf
echo "root soft nofile 1024000" >> /etc/security/limits.conf
echo "root hard nofile 1024000" >> /etc/security/limits.conf
echo "root soft memlock unlimited" >> /etc/security/limits.conf
echo "ulimit -Sn 65536" >> /root/.bashrc
echo "ulimit -Hn 65536" >> /root/.bashrc
echo "session required pam_limits.so" >> /etc/pam.d/common-session
echo "session required pam_limits.so" >> /etc/pam.d/common-session-noninteractive
