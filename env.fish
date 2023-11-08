#!/usr/bin/env fish
source $__fish_config_dir/config.fish

function get_secret --description 'Get AWS secret.' --argument id secret
    echo $(aws secretsmanager get-secret-value --secret-id $id) | jq -r '.SecretString' | jq -r ".$secret"
end

set -gx ACCOUNT_ID $(get_secret multitenant ACCOUNT_ID)
set -gx AWS_REGION $(get_secret multitenant AWS_REGION)
set -gx AWS_DEFAULT_REGION $(get_secret multitenant AWS_DEFAULT_REGION)
set -gx IAM_ADMIN $(get_secret multitenant IAM_ADMIN)
set -gx LANGUAGE_MODEL $(get_secret multitenant LANGUAGE_MODEL)
set -gx EMBEDDING_MODEL $(get_secret multitenant EMBEDDING_MODEL)
set -gx BEDROCK_SERVICE $(get_secret multitenant BEDROCK_SERVICE)
set -gx KUBECTL_VERSION $(get_secret multitenant KUBECTL_VERSION)
set -gx EKS_CLUSTER $(get_secret multitenant EKS_CLUSTER)
set -gx ISTIO_VERSION $(get_secret multitenant ISTIO_VERSION)
set -gx ENVOY_CONFIG_BUCKET $(get_secret multitenant ENVOY_CONFIG_BUCKET)
set -gx YAML_PATH $(get_secret multitenant YAML_PATH)
set -gx RANDOM_STRING $(get_secret multitenant RANDOM_STRING)
set -gx ECR_REPO_RAGAPI $(get_secret multitenant ECR_REPO_RAGAPI)
set -gx REPO_URI_RAGAPI $(get_secret multitenant REPO_URI_RAGAPI)
set -gx ECR_REPO_CLAUDE $(get_secret multitenant ECR_REPO_CLAUDE)
set -gx REPO_URI_CLAUDE $(get_secret multitenant REPO_URI_CLAUDE)
set -gx EKS_KEY_NAME $(get_secret multitenant EKS_KEY_NAME)
set -gx KMS_KEY_ALIAS $(get_secret multitenant KMS_KEY_ALIAS)
set -gx MASTER_ARN $(get_secret multitenant MASTER_ARN)
