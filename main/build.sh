#!/bin/bash 

./.bin/tfswitch -b ./.bin/terraform


./.bin/terraform init
./.bin/terraform validate
./.bin/terraform state replace-provider -auto-approve registry.terraform.io/-/aws registry.terraform.io/hashicorp/aws
./.bin/terraform plan -out=plan
./.bin/terraform apply -parallelism=1 -auto-approve  plan 