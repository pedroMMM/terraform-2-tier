# terraform-2-tier
Simple Terraform for creating a 2 tier application

## Overview

This a generic 2 tier docker application, utilizing Aurora PostgreSQL as a database and ECSto house 
the docker containers.

## Networking

We are creating a fresh VPC with some generic CIDR blocks. The CIDR should be tailored to the exact 
use case.

In the VPC there are 3 Public Subnets, 3 Private Subnets and 3 Private Database Subnets. They are 
equally divided across the AZs by having 1 Subnet of each type on each AZ. This allows for High 
Availability (in the Region) and compartmentalization of access.

The Public Subnets contain the Nat Gateways and the ALB. This allow both services to be HA in the 
VPC. The Nat Gateway are used for egress access for all Private Subnets. The ALB is used to expose 
the ECS Service to the outside. 

The Private Subnets contain the EC2 instances that compose the ECS Cluster. The docker containers 
running in the these EC2 instances are only accessible in the VPC and via the ALB.

The Private Database Subnets contain only the Aurora Cluster. The Aurora Endpoints are only 
accessible in the VPC and by a Security Group that is attached to the ECS instances.

## ECS Cluster

Using a ECS Cluster is a simple choice and very capable. A Kubernetes cluster might prove easier to 
develop against but at the moment (until EKS is fully launched) it's harder to maintain and set up 
via Terraform. While outputting a kops configuration to a Terraform template would make for an 
almost full Terraform solution, that approach makes for a complex solution that requires another 
automation tool like Bash, Python, etc. 

Using a ALB to expose a ECS Service allows for SSL termination and for having more than 1 docker 
container as a target in a single ECS Cluster instances. As for why 1 ALB per Service VS 1 ALB per 
Cluster it depends on the use case, 1 ALB per Service is simpler but it will become more expensive. 
Adding SSL termination for the ALB would require at least a signed certificate.

The ECS Cluster Terraform module in use has the capability to deploy Consul to be used for Key 
Value store and service discovery. While it been nice to have a temporary solution the Kubernetes 
move would probably be a better long term solution.

## Aurora Cluster

The Aurora Cluster is a stand-in for a use case dependant solution, while been a fully managed 
solution which is simple to implement and powerful. Aurora is easily scaled.

I picked PostgreSQL just because I have used in the pass, but using MySQL would be a matter of 
changing a variable or two (if you want the port to be the default).

There is just a simple security matter to perform after this Aurora cluster is created via 
Terraform, changing the master password. By changing the master password in Terraform after 
creation it will apply to the master account but it will not reflect the changes from made from the 
PostgreSQL engine directly. The data is encrypted at rest and it supports SSL encrypted access.

## Upgrade Path

One major thing missing is a Terraform Backend, which can be managed by S3 and DynamoDB. These have 
to be created before this Terraform template is configured to use them. This will save the 
Terraform State to the S3 bucket and use the DynamoDB table as a locking mechanism. This will allow 
for multiple actors to utilize the Terraform template while keeping the State save. I usually 
create these resources by using another "helper" Terraform template with delete protection.

Creating SSL certificates to have SSL termination at the ALB.

Configuring Consul and Vault to introduce a regular Kay Value store and a secret store. Consul would
also help with service discovery. This could also be replaced by Kubernetes native APIs.