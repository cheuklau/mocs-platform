# Provision AWS networking resources
module "aws" {
  source = "./modules/aws"
  AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
  AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
  AWS_REGION = "${var.AWS_REGION}"
  PATH_TO_PUBLIC_KEY = "${var.PATH_TO_PUBLIC_KEY}"
}

# Provision AWS EC2 instances and set up Kubernetes cluster
# module "kubernetes" {
#   source = "./modules/kubernetes"
#   AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
#   AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
#   AWS_REGION = "${var.AWS_REGION}"
#   KUBE_AMI = "${var.KUBE_AMI}"
#   AWS_TYPE = "${var.AWS_TYPE}"
#   KEY_NAME = "${module.aws.KEY_NAME}"
#   NUM_MASTERS = "${var.NUM_MASTERS}"
#   SECURITY_GROUP_ID = "${module.aws.SECURITY_GROUP_ID}"
#   SUBNET = "${module.aws.SUBNET}"
#   NUM_WORKERS = "${var.NUM_WORKERS}"
#   PATH_TO_PRIVATE_KEY = "${var.PATH_TO_PRIVATE_KEY}"
# }