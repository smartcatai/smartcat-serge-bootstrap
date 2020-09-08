#!/bin/sh
set -e

# Copy the .ssh directory over to its final destination
# and ensure proper permissions.
#
# Note that under a Windows host, file permissions
# will be reported incorrectly by `ls -l` (as 755),
# but will still work.

cp -R /tmp/.ssh /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
chmod 644 /root/.ssh/*.pub
