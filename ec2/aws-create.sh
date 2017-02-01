#!/bin/bash

# CONSTANTS:
export AWS_REGION="us-west-1"
export AWS_NODE_INSTANCE="c4.8xlarge"   # https://aws.amazon.com/ec2/instance-types/

if [ -z "$AWS_ACCESS_KEY_ID"  ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_VPC_ID" ]; then
  echo "set vars AWS_ACCESS_KEY_ID , AWS_SECRET_ACCESS_KEY and AWS_VPC_ID"
  exit 1;
fi
echo "Creating EC2 Machine"
docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID \
	--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $AWS_VPC_ID \
	--amazonec2-region $AWS_REGION --amazonec2-instance-type $AWS_NODE_INSTANCE \
	--engine-opt dns=8.8.8.8 aws-m1
eval "$(docker-machine env aws-m1)"
