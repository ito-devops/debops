#!/bin/bash
# Author: Niraj Patel <niraj@vipana.com>
# Description: run molecule test harness for each role in debops/roles
# Usage: ./tests/run-all-molecule.sh
shopt -s nullglob

_roles="roles"
_logfile="/tmp/ito-molecule-log.txt"
driver="docker"


cd $_roles
for role in *
do
    cd $role
    if [ -d molecule ]
    then
        echo "Running Molecule tests for role: $role"
    else
        echo "Molecule not setup yet. Setting up molecule for role $role..."
        molecule init scenario -r $role -d docker
    fi
    molecule test | tee -a $_logfile
    cd ..
done
