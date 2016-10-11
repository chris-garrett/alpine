#!/bin/sh

. ./config.sh

VERSION=$VERSION envsubst < ./templates/Dockerfile.template > Dockerfile
VERSION=$VERSION envsubst < ./templates/README.md.template > README.md

docker build --rm=true -t $IMAGE_NAME:$VERSION .
