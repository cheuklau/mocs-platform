#!/bin/bash

# Packer is used to generate the Kubernetes AMI. The same AMI is used for both
# master and worker nodes. The rest of the setup including networking between 
# the master and worker nodes is performed by Terraform after the EC2 instances 
# are provisioned.

# Parse input
function usage() {
	echo "USAGE: $0 [--aws-region string] [--aws-instance-type string] [--help]"
	echo "Examples:"
	echo "$0 --aws-region us-west-2 --aws-instance-type t2.medium"
	echo "$0 --aws-region us-east-1 --aws-instance-type t2.micro"
	exit 1
}

if [ $# -lt 4 ]; then
	usage
fi

while [ $# -gt 0 ]
do
	case $1 in
		--aws-region )
            REGION=$2
			shift
			shift
			;;
		--aws-instance-type )
			TYPE=$2
			shift
			shift
			;;
		--help )
			usage
			;;
		* )
			usage
			;;
	esac
done

# Clear old log files
rm -rf *.log

# Create Packer input
cat << EOF | sudo tee kubernetes.json
{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": "",
    "aws_region": "${REGION}",
    "aws_ami_image": "ami-ba602bc2",
    "aws_instance_type": "${TYPE}",
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "{{user `aws_region`}}",
    "source_ami": "{{user `aws_ami_image`}}",
    "instance_type": "{{user `aws_instance_type`}}",
    "ssh_username": "ubuntu",
    "ami_name" : "kubernetes"
  }],
  "provisioners": [{
    "type": "shell",
    "scripts": [ "setup.sh" ]
  }]
}
EOF

# Build the Kubernetes AMI (same for master and worker nodes)
packer build -machine-readable kubernetes.json | tee kubernetes.log

# Clean up files
rm kubernetes.json