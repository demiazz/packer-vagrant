#!/bin/bash

mkdir /tmp/parallels
mount -o loop /home/<%= username %>/prl-tools-lin.iso /tmp/parallels
/tmp/parallels/install --install-unattended-with-deps
umount /tmp/parallels
rmdir /tmp/parallels
rm /home/<%= username %>/*.iso
