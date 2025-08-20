#!/bin/sh
#===============================================================================
# Script Name   : mkinitrd_post_upgrade-all.sh
# Description   : Compares the running kernel version with any updated version
#                 and generates a new initrd if needed.
# Author        : Phil Jensen
# Date Created  : 2025-08-20
# Last Modified : 2025-08-20
#===============================================================================
# Copyright (c) 2025 Phil Jensen
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#===============================================================================
#
# mkinitrd_command_generator.sh revision 1.45
#
# This script will now make a recommendation about the command to use
# in case you require an initrd image to boot a kernel that does not
# have support for your storage or root filesystem built in
# (such as the Slackware 'generic' kernels').
# A suitable 'mkinitrd' command will be:

RUNNING_KERNEL=$(uname -r)
NEW_KERNEL=$(ls /lib/modules/ | tr -d '/')

generate_initrd() {
        echo "Creating a new initrd for ${NEW_KERNEL}"
        mkinitrd -c -k ${NEW_KERNEL}  \
                -f ext4 \
                -r /dev/cryptvg/root \
                -m usb-storage:xhci-hcd:jbd2:mbcache:crc32c_intel:crc32c_generic:ext4 \
                -C /dev/sda2 \
                -L -u \
                -o /boot/initrd.gz \
                -K LABEL=KEYDISK:/beeslack.key
        # $(ls /lib/modules/ | tr -d '/')
        #5.15.187
}

if [ "${RUNNING_KERNEL}" != "${NEW_KERNEL}" ]; then
        echo -n "${RUNNING_KERNEL} != ${NEW_KERNEL} generate a new initrd? ('yes' to confirm) "
        read ANS
        if [ "${ANS}" == "yes" ]; then
                generate_initrd
                echo "Running lilo"
                lilo
        else
                echo "**********************************************"
                echo "*                                            *"
                echo "*  WARNING: System might not boot correctly  *"
                echo "*                                            *"
                echo "**********************************************"
                exit 1
        fi
else
        echo "${RUNNING_KERNEL} == ${NEW_KERNEL} nothing to do!"
fi
exit 0
