#!/bin/bash

# Retrieve the instance ID using AWS CLI and store it in a variable
instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Jenkins-server" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

# Check if instance_id is empty or not
if [ -z "$instance_id" ]; then
    echo "No instances found with the tag Name=Jenkins-server"
    exit 1
fi

# Execute the command on the instance using Systems Manager
aws ssm send-command \
    --instance-ids "$instance_id" \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=["cat /var/jenkins_home/secrets/initialAdminPassword"]' \
    --output text \
    --query "Command.{Status:Status,Output:Output}"
