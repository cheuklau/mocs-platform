# Packer

[Packer](https://www.packer.io/intro/) is used to generate the Kubernetes [Amazon Machine Images (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html). The same AMI is used for both the master and worker nodes. The rest of the Kubernetes cluster setup is performed by Terraform after the [AWS EC2 instances](https://aws.amazon.com/ec2/instance-types/) are provisioned.

## Build Instructions

To generate the Kubernetes AMI using Packer:

1. Make sure Packer is installed and in the PATH (https://www.packer.io/downloads.html).
2. Make sure environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set.
- Go to AWS console
- Click on user name then `Security Credentials`
- Click on `Access Keys` then `Create New Access Key`
- `export AWS_ACCESS_KEY_ID=<aws access key>`
- `export AWS_SECRET_ACCESS_KEY=<aws secret key>`
3. Make Packer build script executable:
```
chmod +x run-packer.sh
```
3. Run Packer build script:
```
./run-packer.sh --aws-region us-west-2 --aws-instance-type t2.medium 
```