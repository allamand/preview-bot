#!/bin/bash

#Name of your bot
export BOT_NAME=preview-bot
export AWS_REGION=eu-west-1
export CLUSTER_NAME=jenkins-cluster 
export WHITELIST_USER=allamand
#Tag name of the VPC where to deploy or "default" to deploy in default VPC
export VPC_TAG_NAME=JenkinsKanikoStack/jenkins-vpc