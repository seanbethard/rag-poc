#!/usr/bin/env fish
source $fish_config

echo $(aws ecr get-login-password --region $AWS_REGION) | docker login --username AWS \
  --password-stdin $REPO_URI_CLAUDE

set -gx ECR_IMAGE $(
    aws ecr list-images \
         --repository-name $ECR_REPO_CLAUDE \
         --query 'imageIds[0].imageDigest' \
         --output text
    )

aws ecr batch-delete-image \
     --repository-name $ECR_REPO_CLAUDE \
     --image-ids imageDigest=$ECR_IMAGE

docker build -f image-build/Dockerfile-app -t $REPO_URI_CLAUDE:latest .
docker push $REPO_URI_CLAUDE:latest
