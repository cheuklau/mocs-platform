# Terraform

[Terraform](https://www.terraform.io) is used to provision AWS resources (e.g., [virtual private cloud](https://aws.amazon.com/vpc/), [security groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html), [subnets]{https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html}, etc) and the [EC2 instances](https://aws.amazon.com/ec2/instance-types/) that make up the Kubernetes cluster. Terraform will configure the Kubernetes cluster using [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/) with [Flannel](https://github.com/coreos/flannel) as the container networking interface (CNI).

## Build Instructions

To provision AWS resources and configure the Kubernetes cluster using Terraform:

1. Make sure Terraform is installed and in the PATH (https://www.terraform.io/downloads.html).
2. Make sure environment variables `TF_VAR_AWS_ACCESS_KEY` and `TF_VAR_AWS_SECRET_KEY` are set.
- Note: These should be the same values as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` used by Packer
- Go to AWS console
- Click on user name then `Security Credentials`
- Click on `Access Keys` then `Create New Access Key`
- `export TF_VAR_AWS_ACCESS_KEY=<aws access key>`
- `export TF_VAR_AWS_SECRET_KEY=<aws secret key>`
3. Make the Terraform build script executable:
```
chmod +x run-terraform.sh
```
4. Create SSH key-pair for EC2 instances:
```
ssh-keygen -f mykey
```
The above command creates `mykey` and `mykey.pub`.
5. Run the Terraform build script:
```
./run-terraform.sh --aws-region us-west-2 \
                   --aws-public-key /path/to/mykey.pub\
                   --aws-private-key /path/to/mykey \
                   --kube-ami <kubernetes AMI id> \
                   --aws-instance-type <ec2 instance type> \
                   --num-kube-masters <number of kubernetes masters> \
                   --num-kube-workers <number of kubernetes workers>
```
