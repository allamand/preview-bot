    #!/bin/bash

ECR_REPO=`aws ecr describe-repositories --region eu-west-1 --repository-names $BOT_NAME --output text --query 'repositories[0].repositoryUri'`
echo $ECR_REPO

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

docker build -t $BOT_NAME .

docker tag $BOT_NAME $ECR_REPO

docker push $ECR_REPO