#!/bin/bash

# CONSTANTS:
export AWS_REGION="us-west-2"
export AWS_NODE_INSTANCE="t2.micro"   # https://aws.amazon.com/ec2/instance-types/
export AWS_SWARM_PORT="8500"	# Seems to be fixed - keep it at 8500 to have it work
export NUMBER_OF_NODES="2"		# Used to setup multiple nodes
export NODE_ROOT_SIZE="--amazonec2-root-size 30"  # Size of root, in GB
export KEYSTORE_NAME="aws-swarm-keystore1"

if [ -z "$AWS_ACCESS_KEY_ID"  ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_VPC_ID" ]; then
  echo "set vars AWS_ACCESS_KEY_ID , AWS_SECRET_ACCESS_KEY and AWS_VPC_ID"
  exit 1;
fi
echo "Creating Swarm Host Keystore"
docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID \
	--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $AWS_VPC_ID \
	--amazonec2-region $AWS_REGION --amazonec2-instance-type t2.micro \
        $NODE_ROOT_SIZE \
	--engine-opt dns=8.8.8.8 $KEYSTORE_NAME
eval "$(docker-machine env $KEYSTORE_NAME)"
echo "Starting Consul at Keystore Machine"
docker run -d -p "$AWS_SWARM_PORT:$AWS_SWARM_PORT" -h "consul"  progrium/consul -server -bootstrap
echo "Now its time to log in https://console.aws.amazon.com/ec2/ and setup the 'docker-machine' group inbound rules."
echo "DON'T PROCEED UNTIL inbound rules is configured - default case is to open up port $AWS_SWARM_PORT to the VPC"
echo "If the 'docker-machine' group is configured, click any key to continue..."
read key
echo "Creating Swarm master ..."
docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID \
	--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $AWS_VPC_ID \
	--engine-opt dns=8.8.8.8 --amazonec2-region $AWS_REGION \
	--amazonec2-instance-type $AWS_NODE_INSTANCE $AWS_SWARM_MASTER_AMI \
	--swarm --swarm-master --swarm-strategy "spread" \
        $NODE_ROOT_SIZE \
	--swarm-discovery="consul://$(docker-machine ip $KEYSTORE_NAME):$AWS_SWARM_PORT" \
	--engine-opt="cluster-store=consul://$(docker-machine ip $KEYSTORE_NAME):$AWS_SWARM_PORT" \
	--engine-opt="cluster-advertise=eth0:2376" aws-swarm-master

# Create each node here
for i in `seq 1 $NUMBER_OF_NODES`;
do
	echo "Creating Swarm node $i ..."
	docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID \
		--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $AWS_VPC_ID \
		--engine-opt dns=8.8.8.8 --amazonec2-region $AWS_REGION \
                $NODE_ROOT_SIZE \
		--amazonec2-instance-type $AWS_NODE_INSTANCE $AWS_SWARM_NODE_AMI \
		--swarm --swarm-discovery="consul://$(docker-machine ip $KEYSTORE_NAME):$AWS_SWARM_PORT" \
		--engine-opt="cluster-store=consul://$(docker-machine ip $KEYSTORE_NAME):$AWS_SWARM_PORT" \
		--engine-opt="cluster-advertise=eth0:2376"  "aws-swarm-node-$i"
done
# Setup docker to use new swarm configuration

# I seem to have to do this manually...Not sure why since the one above works just fine
eval "$(docker-machine env --swarm aws-swarm-master)"
