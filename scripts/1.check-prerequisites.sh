#!/bin/bash


validateVar() {
  if [ -z ${!1+x} ]; then 
    echo "${1} is unset"; 
    exit 1; 
  else 
    echo "${1} is set to ${!1} "; 
  fi
}

validateVar ACCOUNT_ID
validateVar BOT_NAME
validateVar AWS_REGION
validateVar CLUSTER_NAME
validateVar WHITELIST_USER