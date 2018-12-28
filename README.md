# MOCS Platform

## Table of Contents

1. [Introduction](README.md#introduction)
2. [Infrastructure-as-Code Tools](README.md#infrastructure-as-code-tools)
3. [Data Engineering Tools](README.md#data-engineering-tools)
4. [Use Cases](README.md#use-cases)

## Introduction

The goal of the monitored one-click solution (MOCS) platform is to automate the deployment of [data engineering pipelines](https://en.wikipedia.org/wiki/Extract,_transform,_load) onto [Amazon Web Services (AWS)](https://aws.amazon.com). The user supplies basic information about their data engineering pipeline and the MOCS platform will generate a recommended cloud architecture along with an estimated cost. If the user agrees, the MOCS platform will automatically provision the proposed cloud architecture onto AWS. In addition, the user will be provided with all the tools needed to make sure the deployment is healthy e.g., centralized logging, monitoring, alerting and access to the API endpoints of each service. The MOCS platform should effectively abstract away the complexities of [infrastructure-as-code (IaC)](https://www.hashicorp.com/resources/what-is-infrastructure-as-code) from the user.

## Infrastructure-as-Code Tools

In summary, [Terraform](https://www.terraform.io) and [Packer](https://www.packer.io/intro/) are used to provision a [Kubernetes](https://kubernetes.io) cluster on AWS. All of the required data engineering tools are deployed as a [Helm](https://helm.sh) application on Kubernetes. [Traefik](https://traefik.io)is used to route all external and internal traffic. [Prometheus](https://prometheus.io) will be used to monitor metrics (e.g., CPU, memory) on the cluster, application and pod level. [Elastic Stack](https://www.elastic.co) will be used for centralized logging. The official documentations are linked above. For more information on a specific techonology's usage see `/src/<technology>/README.md`. 

## Data Engineering Tools

The list of supported data engineering tools will continuously grow. The currently supported data engineering tools are:

- [Spark](https://spark.apache.org) is a distributed system tool for performing map, filter and reduce operations on big data. 
- [Kafka](https://kafka.apache.org) is a distributed system tool for message queuing.

## Use Cases

### AirAware

The [AirAware](https://github.com/agaiduk/AirAware) data engineering pipeline is summarized below:
- 500GB of data in S3
- Spark batch-processes data
- Processed data is stored in Postgres

The MOCS input (`airaware.yaml`) is provided below:
```
extract:
    metadata:
        app: airaware
    storage:
    - type: s3
      location: <link to s3 bucket>
      size: 500
transform:
    metadata:
        app: airaware
    stages:
    - tool: spark
      type: batch
load:
    metadata:
        app: airaware
    storage:
    - type: postgres
      size: 50
```

To generate the recommended architecture: `mocs --plan airaware.yaml`. To provision the recommended architecture: `mocs --apply airaware.yaml`.