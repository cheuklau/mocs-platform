#!/bin/bash

# Parse input
function usage() {
	echo "Make sure Packer is installed and in PATH."
	echo "Make sure environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are set."
	echo "USAGE: $0 [--aws-region string] [--aws-instance-type string] [--help]"
	echo "EXAMPLE:"
	echo "$0 --aws-region us-west-2 --aws-instance-type t2.medium"
	exit 1
}

# Need at least four arguments
if [ $# -lt 4 ]; then
	usage
fi

# Parse two arguments at a time
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
    "aws_instance_type": "${TYPE}"
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user \`aws_access_key\`}}",
    "secret_key": "{{user \`aws_secret_key\`}}",
    "region": "{{user \`aws_region\`}}",
    "source_ami": "{{user \`aws_ami_image\`}}",
    "instance_type": "{{user \`aws_instance_type\`}}",
    "ssh_username": "ubuntu",
    "ami_name" : "kubernetes"
  }],
  "provisioners": [{
    "type": "shell",
    "scripts": [ "setup.sh" ]
  }]
}
EOF

# Build Kubernetes AMI
packer build -machine-readable kubernetes.json | tee kubernetes.log

# Clean up files
sudo rm kubernetes.json