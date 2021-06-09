#!/bin/bash
set -e

docker build -t jnnksdev/devcontainer_$1 -f devcontainer_$1.Dockerfile .