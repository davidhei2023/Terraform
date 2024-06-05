#!/bin/bash

workspaces=$(terraform workspace list | sed 's/*//')

for workspace in $workspaces; do
  echo "Switching to workspace: $workspace"
  terraform workspace select $workspace

  echo "Destroying resources in workspace: $workspace"
  terraform destroy -auto-approve -var-file=region.${workspace}.tfvars
done
