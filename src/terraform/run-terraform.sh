#!/bin/bash

# Parse input
function usage() {
  echo "Make sure Terraform is installed and in PATH."
  echo "Make sure environment variables TF_VAR_AWS_ACCESS_KEY and TF_VAR_AWS_SECRET_KEY are set."
  echo "USAGE: $0 [--aws-region string] \ "
  echo "          [--aws-public-key string] \ "
  echo "          [--aws-private-key string] \ "
  echo "          [--kube-ami string] \ "
  echo "          [--aws-instance-type string] \ "
  echo "          [--num-kube-masters int] \ "
  echo "          [--num-kube-workers int] \ "
  echo "          [--help] "
  echo "Example:"
  echo "$0 --aws-region us-west-2 \ "
  echo "   --aws-public-key /Users/cheuklau/.ssh/mykey.pub \ "
  echo "   --aws-private-key /Users/cheuklau/.ssh/mykey \ "
  echo "   --kube-ami ami-0982784284e84efa9 \ "
  echo "   --aws-instance-type t2.medium \ "
  echo "   --num-kube-masters 2 \ "
  echo "   --num-kube-workers 2 "
  exit 1
}

# Need at least 14 arguments
if [ $# -lt 14 ]; then
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
    --aws-instance-type )
      TYPE=$2
      shift
      shift
      ;;
    --num-kube-masters )
      NMASTERS=$2
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

# Clean up old files
sudo rm vars.tf

# Create Terraform variable input
cat << EOF | sudo tee vars.tf
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" { default = "${REGION}" }
variable "KUBE_AMI" { default = "${KUBEAMI}" }
variable "AWS_TYPE" { default = "${TYPE}" }
variable "PATH_TO_PUBLIC_KEY" { default = "${PUBLICKEY}" }
variable "PATH_TO_PRIVATE_KEY" { default = "${PRIVATEKEY}" }
variable "NUM_MASTERS" { default = "${NMASTERS}" }
variable "NUM_WORKERS" { default = "${NWORKERS}" }
EOF

# Run Terraform
terraform init
terraform apply