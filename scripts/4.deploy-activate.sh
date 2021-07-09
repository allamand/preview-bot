#!/bin/bash

aws cloudformation deploy --region $AWS_REGION \
    --stack-name $BOT_NAME \
    --template-file template.yml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides BotEnabled=Yes