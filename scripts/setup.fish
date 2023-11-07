#!/usr/bin/env fish
set -gx fish_config $__fish_config_dir/config.fish
source $fish_config

echo "Validating inital setup"
set -gx YAML_PATH yaml
echo "set -gx YAML_PATH yaml" | tee -a $fish_config
[ -d $YAML_PATH ] || mkdir $YAML_PATH

set -gx AWS_DEFAULT_REGION us-east-1
set -gx ACCOUNT_ID $(aws --region $AWS_DEFAULT_REGION sts get-caller-identity --output text --query Account)

set -gx IAM_ADMIN BedrockMultitenant
set -gx LANGUAGE_MODEL anthropic.claude-instant-v1
set -gx EMBEDDING_MODEL amazon.titan-embed-text-v1
set -gx BEDROCK_SERVICE bedrock-runtime
set -gx KUBECTL_VERSION 1.27.1/2023-04-19
set -gx EKS_CLUSTER bedrock-cluster
set -gx ISTIO_VERSION 1.18.3

echo "set -gx IAM_ADMIN $IAM_ADMIN" | tee -a $fish_config
echo "set -gx LANGUAGE_MODEL $LANGUAGE_MODEL" | tee -a $fish_config
echo "set -gx EMBEDDING_MODEL $EMBEDDING_MODEL" | tee -a $fish_config
echo "set -gx BEDROCK_SERVICE $BEDROCK_SERVICE" | tee -a $fish_config
echo "set -gx KUBECTL_VERSION $KUBECTL_VERSION" | tee -a $fish_config
echo "set -gx EKS_CLUSTER $EKS_CLUSTER" | tee -a $fish_config
echo "set -gx ISTIO_VERSION $ISTIO_VERSION" | tee -a $fish_config

if test "x$IAM_ADMIN" = x
    echo -------------------------------------------------------
    echo "Please specify an IAM role with Administrator access."
    echo -------------------------------------------------------
    exit
end

if test "x$LANGUAGE_MODEL" = x
    echo ----------------------------------
    echo "Please specify a language model."
    echo ----------------------------------
    exit
end

if test "x$EMBEDDING_MODEL" = x
    echo --------------------------------------------------
    echo "Please specify an embedding model."
    echo --------------------------------------------------
    exit
end

if test "x$BEDROCK_SERVICE" = x
    echo ------------------------------------------------
    echo "Please specify a name for the Bedrock service."
    echo ------------------------------------------------
    exit
end

if test "x$KUBECTL_VERSION" = x
    echo ---------------------------------------
    echo "Please specify a version for kubectl."
    echo ---------------------------------------
    exit
end

if test "x$EKS_CLUSTER" = x
    echo --------------------------------------------
    echo "Please specify a name for the EKS Cluster."
    echo --------------------------------------------
    exit
end

if test "x$ISTIO_VERSION" = x
    echo -------------------------------------
    echo "Please specify a version for Istio."
    echo -------------------------------------
    exit
end

# Python 3.8, Apple silicon
echo "Installing Python"
curl -sSL https://raw.githubusercontent.com/Homebrew/formula-patches/113aa84/python/3.8.3.patch\?full_index\=1 | pyenv install --patch 3.8.6
pipenv install -q --python 3.8.6

echo "Enabling --user install"
set -gx PROJECT_NAME (echo (string split / --right --max 1  (pwd))[2])
set -x VENV_NAME (ls -al $HOME/.local/share/virtualenvs/ | grep "$PROJECT_NAME.*")
set -gx PROJECT_VENV (echo (string split ' ' $VENV_NAME)[12])
sed -e "s@false@true@" $PROJECT_VENV/pyvenv.cfg | tee $PROJECT_VENV/pyvenv.cfg

echo "Installing botocore"
pipenv run python3.8 -m pip install -q -q --user botocore
echo "Installing boto3"
pipenv run python3.8 -m pip install -q -q --user boto3

echo "Installing jq, kubectl, eksctl, helm, fish completions"
brew upgrade -q
brew tap weaveworks/tap
brew install jq kubectl weaveworks/tap/eksctl
set PATH /opt/homebrew/bin/ $PATH

echo "jq version: $(jq --version)"
# make sure kubectl is within one minor version of cluster (1.27)
echo "kubectl version: $(kubectl version --client)"
echo "eksctl version: $(eksctl version)"
echo "helm version: $(helm version --template='Version: {{.Version}}')"

grep fish /opt/homebrew/share/fish/vendor_completions.d/kubectl.fish | head -1
mkdir -p $HOME/.config/fish/completions
eksctl completion fish >$HOME/.config/fish/completions/eksctl.fish
grep fish $HOME/.config/fish/completions/eksctl.fish | head -1
grep fish /opt/homebrew/share/fish/vendor_completions.d/helm.fish | head -1

echo "Creating S3 bucket policy for envoy dynamic configuration files"
set -gx RANDOM_STRING $(cat /dev/urandom \
    | LC_ALL=C tr -dc '[:alpha:]' \
    | fold -w 9 | head -n 1 \
    | cut -c 1-8 \
    | tr '[:upper:]' '[:lower:]')
echo "set -gx RANDOM_STRING $RANDOM_STRING" | tee -a $fish_config
echo ---------------------
echo $(aws iam list-attached-role-policies --role-name $IAM_ADMIN) | grep AdministratorAccess -q && echo "IAM role valid." || echo "IAM role NOT valid."
echo ---------------------
echo "Setting ACCOUNT_ID"
echo "set -gx ACCOUNT_ID $ACCOUNT_ID" | tee -a $fish_config
echo "Setting AWS_REGION"
echo "set -gx AWS_REGION $AWS_DEFAULT_REGION" | tee -a $fish_config
echo "Setting AWS_DEFAULT_REGION"
echo "set -gx AWS_DEFAULT_REGION $AWS_DEFAULT_REGION" | tee -a $fish_config
echo "Configuring AWS_REGION"
aws configure set default.region $AWS_REGION
echo "Getting default region"
aws configure get default.region
set -gx ENVOY_CONFIG_BUCKET envoy-config-$RANDOM_STRING
aws --region $AWS_DEFAULT_REGION s3 mb s3://$ENVOY_CONFIG_BUCKET

if test $status = 0
    echo "set -gx ENVOY_CONFIG_BUCKET $ENVOY_CONFIG_BUCKET" | tee -a $fish_config
end

envsubst <"iam/s3-envoy-config-access-policy.json" \
    | xargs -J{} -0 aws iam create-policy \
    --policy-name "s3-envy-config-access-policy-$RANDOM_STRING" \
    --policy-document {}

DynamoDB and Bedrock access policy
set tenants silo bridge pool
for tenant in $tenants
    echo "Creating contextual data S3 Bucket for $tenant"
    set -l tenant $tenant
    aws s3 mb s3://contextual-data-$tenant-$RANDOM_STRING

    if test $tenant = silo
        aws s3 cp data/Amazon_SageMaker_FAQs.csv s3://contextual-data-$tenant-$RANDOM_STRING
    else if test $tenant = bridge
        aws s3 cp data/Amazon_EMR_FAQs.csv s3://contextual-data-$tenant-$RANDOM_STRING
    else if test $tenant = pool
        aws s3 cp data/Amazon_SageMaker_FAQs.csv s3://contextual-data-$tenant-$RANDOM_STRING
    end

    echo "S3 access policy for $tenant"
    envsubst <"iam/s3-contextual-data-access-policy.json" \
        | xargs -J{} -0 aws iam create-policy \
        --policy-name s3-contextual-data-access-policy-$tenant-$RANDOM_STRING \
        --policy-document {}

    echo "DynamoDB and Bedrock access policy for $tenant"
    envsubst <iam/dynamodb-access-policy.json \
        | xargs -J{} -0 aws iam create-policy \
        --policy-name dynamodb-access-policy-$tenant-$RANDOM_STRING \
        --policy-document {}
end

Ingest data to FAISS Index
source $fish_config
pipenv run command pip3.8 install -q -q --user -r data_ingestion_to_vectordb/requirements.txt
pipenv run command python3.8 data_ingestion_to_vectordb/data_ingestion_to_vectordb.py

echo "Creating ECR repository for Claude"
set -gx ECR_REPO_CLAUDE $(aws ecr create-repository --repository-name $EKS_CLUSTER-$RANDOM_STRING-claude --encryption-configuration encryptionType=KMS)
set -gx REPO_URI_CLAUDE $(echo $ECR_REPO_CLAUDE| jq -r '.repository.repositoryUri')
set -gx REPO_CLAUDE $(echo $ECR_REPO_CLAUDE|jq -r '.repository.repositoryName')

echo "Creating ECR repository for rag-api"
set -gx ECR_REPO_RAGAPI $(aws ecr create-repository --repository-name $EKS_CLUSTER-$RANDOM_STRING-rag-api --encryption-configuration encryptionType=KMS)
set -gx REPO_URI_RAGAPI $(echo $ECR_REPO_RAGAPI|jq -r '.repository.repositoryUri')
set -gx REPO_RAGAPI $(echo $ECR_REPO_RAGAPI|jq -r '.repository.repositoryName')

echo "set -gx ECR_REPO_CLAUDE $REPO_CLAUDE" | tee -a $fish_config
echo "set -gx REPO_URI_CLAUDE $REPO_URI_CLAUDE" | tee -a $fish_config
echo "set -gx ECR_REPO_RAGAPI $REPO_RAGAPI" | tee -a $fish_config
echo "set -gx REPO_URI_RAGAPI $REPO_URI_RAGAPI" | tee -a $fish_config

echo "Building docker images"
fish image-build/build-claude-image.fish
docker rmi -f $(docker images -a -q) >/dev/null 2>&1
fish image-build/build-rag-api-image.fish
docker rmi -f $(docker images -a -q) >/dev/null 2>&1

echo "Generating a new key"
echo y | ssh-keygen -t rsa -N '' -f $HOME/.ssh/id_rsa
echo set -gx EC2_KEY_NAME $EKS_CLUSTER_NAME-$RANDOM_STRING
aws ec2 import-key-pair --key-name $EC2_KEY_NAME --public-key-material fileb://~/.ssh/id_rsa.pub
echo set -gx EC2_KEY_NAME $EC2_KEY_NAME | tee -a $fish_config

echo "Creating KMS key and alias"
echo set -gx KMS_KEY_ALIAS $EKS_CLUSTER_NAME-$RANDOM_STRING
aws kms create-alias --alias-name alias/$KMS_KEY_ALIAS \
    --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)
echo set -gx KMS_KEY_ALIAS $KMS_KEY_ALIAS | tee -a $fish_config
echo set -gx MASTER_ARN $(aws kms describe-key --key-id alias/$KMS_KEY_ALIAS \
    --query KeyMetadata.Arn --output text)
echo set -gx MASTER_ARN $MASTER_ARN | tee -a $fish_config
