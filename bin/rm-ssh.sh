#!/usr/bin/env bash
#
# Simplify using ec2-instance-connect
#

ssh-usage() { echo "Usage: ./rm-ssh.sh <instance>" 1>&2; }
if [ $# -ne 1 ]; then ssh-usage; exit 1; fi;

INSTANCE=$1

if [ -z "$RM_USER" ]; then
  RM_USER=$USER
fi

# if instance starts with i- then we've already got the id
if [[ $INSTANCE == i-* ]]; then
  INSTANCE_ID=$INSTANCE
else
# otherwise lookup by name
  INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE" --output text --query 'Reservations[*].Instances[*].InstanceId')
  if [ -z "$INSTANCE_ID" ]; then
    echo "Could not find $INSTANCE, are you logged in?"
    exit 1
  else
    echo "Found instance $INSTANCE_ID with name $INSTANCE"
  fi
fi

SECURITY_GROUP_ID=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[].Instances[].SecurityGroups[]" | jq -r '.[] | select( .GroupName | contains("SSH Whitelist"))| .GroupId')

EXTERNAL_IP=$(curl -s ipv4.icanhazip.com)

echo "Adding IP $EXTERNAL_IP with user $RM_USER"
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$EXTERNAL_IP/32,Description=$RM_USER}]" || true

aws ec2-instance-connect ssh --instance-id $INSTANCE_ID

