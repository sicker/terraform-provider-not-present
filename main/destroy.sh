#!/bin/bash 

./.bin/terraform destroy -auto-approve 
rm terraform.tfstate*