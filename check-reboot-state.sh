#!/bin/sh
#===============================================================================
# Script Name   : check-reboot-state.sh
# Description   : Checks whether a reboot is needed due to updated core OS
#                 components, then checks if the needed keydisk used for 
#                 encryption and if so will reboot the system.
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

if [ -f /var/run/needs_restarting ]; then
        echo "Needs rebooting"
else
        echo "Reboot not needed"
        exit 0
fi

# Check if keydisk available to mount encrypted drives on reboot
KEYDISK_NAME="KEYDISK"
KEYDISK_COUNT=$(lsblk -o label | grep -c "${KEYDISK_NAME}")
if [ ${KEYDISK_COUNT} -eq 1 ]; then
        echo "USB with decryption key ($KEYDISK_NAME) is available, rebooting!"
        /sbin/reboot
fi
