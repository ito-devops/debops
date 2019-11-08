#!/usr/bin/env bash

# Check the ITO DebOps Docker image build

# Copyright (C) 2019 Nick Patel <nick@rads.io>
# Copyright (C) 2017 Maciej Delmanowski <drybjed@gmail.com>
# Copyright (C) 2017 DebOps https://debops.org/

# This script needs to be executed in the root of the DebOps monorepo.
# You can use it by running:
#
#     make ito-docker


set -o nounset -o pipefail -o errexit

if type docker > /dev/null 2>&1 ; then

    printf "%s\\n" "Testing Dockerfile syntax with hadolint, ignoring DL3008,DL3013..."
    docker run --rm -i lukasmartinelli/hadolint hadolint --ignore DL3008 --ignore DL3013 - < Dockerfile.ito

    if [ -n "$(docker image ls -q ito-devops/docker-debian10-ansible)" ] ; then
        printf "%s\\n" "Found existing 'ito-devops/docker-debian10-ansible' Docker image, rebuilding..."
        #docker image rm ito-devops/docker-debian10-ansible -f
    fi

    printf "%s\\n" "Building the 'ito-devops/docker-debian10-ansible' Docker image..."
    docker build -f Dockerfile.ito -t ito-devops/docker-debian10-ansible .

    # add tag to push to docker hub
    #docker image tag ito-devops/docker-debian10-ansible:latest itodevops/docker-debian10-ansible:latest
    #printf "%s\\n" "Publish: docker push ito-devops/docker-debian10-ansible"

    printf "%s\\n" "Testing the viability of 'ito-devops/docker-debian10-ansible' Docker image..."
    docker run -it --rm ito-devops/docker-debian10-ansible bash -c 'ls -l && cd src/controller && debops service/core --diff'

else
    printf "%s\\n" "Docker is not installed, skipping Docker tests"
fi
