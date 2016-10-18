#!/bin/bash
set -x
set -e

# Version of go image to use
GO_VERSION="1.6.0"

# Get a gitlab docker image from the current machine
GITLAB_BUILDER_IMAGE="${GITLAB_BUILDER_IMAGE:-`docker images | grep gitlab-runner-build | awk '{printf "%s:%s\n",$1,$2 }' | head -n 1`}"
CONTAINER=`docker run -d --entrypoint=/bin/sleep $GITLAB_BUILDER_IMAGE 600`

# Copy out the file
docker cp $CONTAINER:/usr/bin/gitlab-runner-helper .

docker rm -f $CONTAINER

# Now run the build
sed "s/%%GO_VERSION%%/$GO_VERSION/" Dockerfile.in > Dockerfile
docker build -t go-builder:$GO_VERSION .
