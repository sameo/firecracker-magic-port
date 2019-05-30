#!/bin/bash

export FC_BUILD=/tmp/fc-build

curl --unix-socket $1 -i \
    -X PUT 'http://localhost/boot-source'   \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{
        "kernel_image_path": "'$FC_BUILD'/linux-stable/vmlinux",
        "boot_args": "console=ttyS0 reboot=k panic=1 pci=off init=/init"
    }'

curl --unix-socket $1 -i \
    -X PUT 'http://localhost/drives/rootfs' \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{
        "drive_id": "rootfs",
        "path_on_host": "'$FC_BUILD'/rootfs/fc-rootfs.ext4",
        "is_root_device": true,
        "is_read_only": false
    }'


rm -rf /tmp/logs.fifo
rm -rf /tmp/metrics.fifo
mkfifo /tmp/logs.fifo
mkfifo /tmp/metrics.fifo

curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT "http://localhost/logger" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{
             \"log_fifo\": \"/tmp/logs.fifo\",
	     \"level\": \"Info\",
             \"metrics_fifo\": \"/tmp/metrics.fifo\"
    }"

curl --unix-socket $1 -i \
    -X PUT 'http://localhost/actions'       \
    -H  'Accept: application/json'          \
    -H  'Content-Type: application/json'    \
    -d '{
        "action_type": "InstanceStart"
     }'
