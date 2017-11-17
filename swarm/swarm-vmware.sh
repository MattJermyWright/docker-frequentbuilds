#!/bin/bash

# CONSTANTS:
# export AWS_REGION="us-west-2"
# # https://aws.amazon.com/ec2/instance-types/
# export AWS_MASTER_INSTANCE="t2.micro"   
# export AWS_NODE_INSTANCE="t2.micro"   
export NUMBER_OF_NODES="3"
# export NODE_ROOT_SIZE="--amazonec2-root-size 30"
# export AWS_VPC_ID="vpc-e830d38d"

export MASTER_NAME="master1"

# if [ -z "$AWS_ACCESS_KEY_ID"  ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
#   echo "set vars AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY before continuing..."
#   exit 1;
# fi

# Create docker machine master for swarm
docker-machine create --driver vmwarefusion --engine-opt dns=8.8.8.8 $MASTER_NAME

# Docker swarm master IP:
export DOCKER_MASTER_IP=$(docker-machine ip $MASTER_NAME)
docker-machine ssh $MASTER_NAME "sudo docker swarm init --advertise-addr $DOCKER_MASTER_IP" 2>&1 1> token.txt
export DOCKER_NODE_TOKEN=$(./parseToken.py < token.txt)

# Spin up local / private registry
eval $(docker-machine env $MASTER_NAME)
docker service create --name registry --publish 5000:5000 registry:2

# Spin up portainer - need to lock this port down. Should login to change password
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

# Spin up child nodes
for i in `seq 1 $NUMBER_OF_NODES`;
do
	# Spinup Docker Node
	docker-machine create --driver vmwarefusion --engine-opt dns=8.8.8.8 node$i
	docker-machine ssh node$i "sudo docker swarm join --token $DOCKER_NODE_TOKEN $DOCKER_MASTER_IP:2377"
done
