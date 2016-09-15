#!/bin/bash
# FOSSology docker-entrypoint script
# Copyright Siemens AG 2016, fabio.huser@siemens.com
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
# Description: startup helper script for the FOSSology Docker container

#
# used environmental variables:
#    FOSSOLOGY_DB_HOST
#    FOSSOLOGY_DB_NAME
#    FOSSOLOGY_DB_USER
#    FOSSOLOGY_DB_PASSWORD
#    FOSSOLOGY_SCHEDULER_HOST

set -ex

echo "call parent entrypoint"
/fossology/docker-entrypoint.sh

echo "setup fossology database"
sudo /usr/local/lib/fossology/dbcreate
# sudo /usr/local/lib/fossology/fossinit.php -c /usr/local/etc/fossology

echo "Starnting scheduler..."
if [[ $# = 1 && "$1" == "scheduler" ]]; then
    exec /usr/local/share/fossology/scheduler/agent/fo_scheduler \
            --log /dev/stdout \
            --verbose=3 \
            --reset
fi
exec "$@"
