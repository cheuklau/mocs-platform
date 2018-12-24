########################################################################
# Set up AWS networking
########################################################################
module "aws" {

  source = "./modules/aws"

  AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
  AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
  AWS_REGION = "${var.AWS_REGION}"
  PATH_TO_PUBLIC_KEY = "${var.PATH_TO_PUBLIC_KEY}"

}

########################################################################
# Set up Kubernetes cluster
########################################################################
module "kubernetes" {

  source = "./modules/kubernetes"
  
  AMIS = "${lookup(var.AMIS, "kubernetes")}"
  AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
  AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
  AWS_REGION = "${var.AWS_REGION}"
  KEY_NAME = "${module.aws.KEY_NAME}"
  SECURITY_GROUP_ID = "${module.aws.SECURITY_GROUP_ID}"
  SUBNET = "${module.aws.SUBNET}"
  PATH_TO_PRIVATE_KEY = "${var.PATH_TO_PRIVATE_KEY}"
  NUM_MASTERS = "${var.NUM_MASTERS}"
  NUM_WORKERS = "${var.NUM_WORKERS}"
  AWS_TYPE = "${var.AWS_TYPE}"

}

########################################################################
# Set up Elastic Load Balancer
########################################################################
module "elb" {

  source = "./modules/elb"

  SUBNET_1 = "${module.aws.SUBNET_1}"
  SUBNET_2 = "${module.aws.SUBNET_2}"
  SECURITY_GROUP_ID = "${module.aws.SECURITY_GROUP_ID}"

}