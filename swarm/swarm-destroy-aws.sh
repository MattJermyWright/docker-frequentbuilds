#!/bin/bash
echo "Destroying Swarm cluster ..."

export NUMBER_OF_NODES="2" # Use to delete multiple nodes - assumes same naming convention

# Remove the nodes first
for i in `seq 1 $NUMBER_OF_NODES`
do
	docker-machine rm "aws-swarm-node-$i" -f
done

# Remove the key store and the master last
docker-machine rm aws-swarm-keystore aws-swarm-master -f
