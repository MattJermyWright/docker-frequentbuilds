#!/bin/bash

# CONSTANTS:
export AWS_REGION="us-west-2"
# https://aws.amazon.com/ec2/instance-types/
export AWS_MASTER_INSTANCE="t2.micro"   
export AWS_NODE_INSTANCE="t2.micro"   
export NUMBER_OF_NODES="3"
export NODE_ROOT_SIZE="--amazonec2-root-size 30"
export AWS_VPC_ID="vpc-e830d38d"

if [ -z "$AWS_ACCESS_KEY_ID"  ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "set vars AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY before continuing..."
  exit 1;
fi

# Create docker machine master for swarm
docker-machine create --driver amazonec2 --amazonec2-vpc-id $AWS_VPC_ID --amazonec2-instance-type $AWS_MASTER_INSTANCE $NODE_ROOT_SIZE --amazonec2-region $AWS_REGION --engine-opt dns=8.8.8.8 aws-master1

# Docker swarm master IP:
export DOCKER_MASTER_IP=$(docker-machine ip aws-master1)
docker-machine ssh aws-master1 "sudo docker swarm init --advertise-addr $DOCKER_MASTER_IP" 2>&1 1> token.txt
export DOCKER_NODE_TOKEN=$(./parseToken.py < token.txt)

for i in `seq 1 $NUMBER_OF_NODES`;
do
	# Spinup Docker Node
	docker-machine create --driver amazonec2 --amazonec2-vpc-id $AWS_VPC_ID --amazonec2-instance-type $AWS_NODE_INSTANCE $NODE_ROOT_SIZE --amazonec2-region $AWS_REGION --engine-opt dns=8.8.8.8 aws-node$i
	docker-machine ssh aws-node$i "sudo docker swarm join --token $DOCKER_NODE_TOKEN $DOCKER_MASTER_IP:2377"
done
