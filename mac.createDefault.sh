#!/bin/bash

docker-machine rm -f default
docker-machine create --driver vmwarefusion default
