#!/bin/bash

# Terraform is used to provision AWS networking and the EC2 instances to 
# run the Kubernetes cluster. Terraform is also responsible for setting 
# up networking using Flannel and initializing the Kubernetes cluster using
# Kubeadm. An AWS Elastic Load Balancer (ELB) is also placed in front of 
# the Kubernetes nodes.

# Parse input
function usage() {
	echo "USAGE: $0 [--aws-region string] [--aws-public-key string] [--aws-private-key string]"
    echo "[--kube-ami string] [--aws-type string] [--num-kube-masters int] [--num-kube-workers int] [--help]"
	echo "Example:"
	echo "$0 --aws-region us-west-2 --aws-public-key /path/to/public/key --aws-private-key /path/to/public/key"
    echo "--kube-ami ami-abc-1234 --aws-type t2.medium --num-kube-masters 2 --num-kube-workers 4"
	exit 1
}

if [ $# -lt 14 ]; then
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
		--aws-public-key )
			PUBLICKEY=$2
			shift
			shift
			;;
        --aws-private-key )
            PRIVATEKEY=$2
            shift
            shift
            ;;
        --kube-ami )
            KUBEAMI=$2
            shift
            shift
            ;;
        --aws-type )
            TYPE=$2
            shift
            shift
            ;;
        --num-kube-masters )
            NMASTER=$2
            shift
            shift
            ;;
        --num-kube-workers )
            NWORKERS=$2
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

# Create Terraform variable input
cat << EOF | sudo tee vars.tf
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" { default = "${REGION}" }
variable "AMIS" {
  type = "map"
  default = {
    kubernetes = "${KUBEAMI}"
  }
}
variable "AWS_TYPE" {default = "${TYPE}" }
variable "PATH_TO_PUBLIC_KEY" { default = "${PUBLICKEY}" }
variable "PATH_TO_PRIVATE_KEY" { default = "${PRIVATEKEY}" }
variable "NUM_MASTERS" { default = "${NMASTERS}" }
variable "NUM_WORKERS" { default = "${NWORKERS}" }
EOF

# Run Terraform
terraform init
terraform apply