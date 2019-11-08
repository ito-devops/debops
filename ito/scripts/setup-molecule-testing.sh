#!/bin/bash
# Author: Niraj Patel <niraj@vipana.com>
# Description: setup molecule test harness for each role in debops/roles
# Usage: ./tests/setup-molecule-testing.sh
shopt -s nullglob

_roles="roles"

cd $_roles
for role in *
do
    cd $role
    if [ -d molecule ]
    then
        echo "Molecule already setup for $role"
    else
        echo "Setting up molecule for role $role"
        molecule init scenario -r $role -d docker
    fi
    cd ..
done
