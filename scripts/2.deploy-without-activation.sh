#!/bin/bash

VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=ecsworkshop-base/BaseVPC | jq -r '.Vpcs[].VpcId')
echo $VPC_ID

#choose Public or private subnet ?
SUBNET_IDS=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:aws-cdk:subnet-type,Values=Public" \
    --query 'Subnets[*].SubnetId' \
    --output text | tr "\\t" ",")
echo $SUBNET_IDS

aws cloudformation deploy --region $AWS_REGION \
    --stack-name $BOT_NAME \
    --template-file template.yml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        Vpc=$VPC_ID \
        Subnets=$SUBNET_IDS \
        EcsClusterName=$CLUSTER_NAME \
        BotUser=$BOT_NAME \
        WhitelistedUsers=$WHITELIST_USER \
        GitHubTokenParameter=preview-bot-github-token \
        BotEnabled=No