#!/usr/bin/env bash

podman build -t teknikuglen/ansible-runner:alpine  -f Containerfile.alpine .
