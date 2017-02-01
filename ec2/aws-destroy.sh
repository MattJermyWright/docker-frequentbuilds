#!/bin/bash
echo "Destroying EC2 Setup ..."

# Remove the key store and the master last
docker-machine rm aws-m1 -f
