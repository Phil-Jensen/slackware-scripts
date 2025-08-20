#!/bin/sh
#===============================================================================
# Script Name   : update-noprompts.sh
# Description   : Completes a Slackware Linux upgrade without prompting.
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


SLACKPKG="/usr/sbin/slackpkg"
${SLACKPKG} check-updates
if [ $? -eq 0 ]; then
        exit 0
fi
${SLACKPKG} update
${SLACKPKG} -dialog=off -batch=on -default_answer=y upgrade-all
