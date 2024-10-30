#!/usr/bin/env bash

podman run --rm -v $(pwd)/workdir:/home/ansible/workdir teknikuglen/ansible-runner:alpine ansible-playbook -i inventory main.yml
