#!/usr/bin/env fish
source $fish_config

echo $(aws ecr get-login-password --region us-east-1) | docker login --username AWS \
  --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker tag $ECR_REPO_CLAUDE:latest $REPO_URI_CLAUDE:latest
docker push $REPO_URI_CLAUDE:latest
