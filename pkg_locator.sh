#!/bin/sh
#===============================================================================
# Script Name   : pkg_locator.sh
# Description   : Gets the full pathname for a command and then displays which
#                 Slackware Linux package it belongs to.
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

if [ "$1" == "" ]; then
        echo "Usage: $0 <cmd>"
        echo "Where the <cmd> is the command to locate the source package."
        exit 0
fi

CMD=$1

CMD_PATH=$(which ${CMD} 2> /dev/null)
if [ $? -ne 0 ]; then
        echo "Command '${CMD}' not found, exiting!"
        exit 0
fi

# check if symlink
for FILE in $(which -a ${CMD})
do
        FILE_TYPE=$(stat --printf="%F" ${FILE})
        echo "FULL COMMAND LINE: ${FILE} (${FILE_TYPE})"
        if [ "${FILE_TYPE}" == "regular file" ]; then
                STRIPPED_CMD_PATH=$(echo ${FILE} | cut -c2-)
                PKG_PATH="/var/lib/pkgtools/packages/"
                if [ ! -d ${PKG_PATH} ]; then
                        echo "${PKG_PATH} does not exist, exiting!"
                        exit 0
                fi
                grep LOCATION $(grep ^${STRIPPED_CMD_PATH}$ /var/lib/pkgtools/packages/* | cut -f1 -d":")
        fi
done

exit 0
