#!/bin/sh
IMAGE=djangoflow/zerotier:latest
docker build -t ${IMAGE} . && docker push ${IMAGE}
