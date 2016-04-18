#!/bin/bash

docker-machine restart default
#docker-machine start default
docker-machine regenerate-certs default
eval "$(docker-machine env default)"
