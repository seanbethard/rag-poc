#!/usr/bin/env fish
source $__fish_config_dir/config.fish

set -gx  EKS_CLUSTER_VERSION 1.27
echo "Deploying Cluster $EKS_CLUSTER with EKS $EKS_CLUSTER_VERSION"
eksctl create cluster -f $YAML_PATH/cluster-config.yaml
aws eks update-kubeconfig --name=$EKS_CLUSTER

Associate an OIDC provider with the EKS Cluster
echo "Associating an OIDC provider with the EKS Cluster"
eksctl utils associate-iam-oidc-provider \
--region=$AWS_REGION \
--cluster=$EKS_CLUSTER \
--approve

set -gx OIDC_PROVIDER $(aws eks describe-cluster \
                      --name $EKS_CLUSTER \
                      --query "cluster.identity.oidc.issuer" \
                      --output text)

echo "Installing AWS Load Balancer Controller"

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

helm repo add eks https://aws.github.io/eks-charts

helm repo update

Setting AWS Load Balancer Controller Version
set -gx VPC_ID $(aws eks describe-cluster \
                --name $EKS_CLUSTER \
                --query "cluster.resourcesVpcConfig.vpcId" \
                --output text)

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$EKS_CLUSTER \
  --set serviceAccount.create=false \
  --set region=$AWS_REGION \
  --set vpcId=$VPC_ID \
  --set serviceAccount.name=aws-load-balancer-controller

kubectl -n kube-system rollout status deployment aws-load-balancer-controller

set -gx OIDC_PROVIDER $(aws eks describe-cluster \
                      --name $EKS_CLUSTER \
                      --query "cluster.identity.oidc.issuer" \
                      --output text)

set -gx OIDC_ID $(echo $OIDC_PROVIDER | awk -F/ '{print $NF}')

echo "Creating S3 Access Role in IAM"
set -gx S3_ACCESS_ROLE $EKS_CLUSTER-s3-access-role-$RANDOM_STRING
set -gx ENVOY_IRSA $(
envsubst < iam/s3-access-role-trust-policy.json | \
xargs -0 -J{} aws iam create-role \
              --role-name $S3_ACCESS_ROLE \
              --assume-role-policy-document {} \
              --query 'Role.Arn' \
              --output text
)
echo "Attaching S3 Bucket policy to S3 Access Role"
aws iam attach-role-policy \
    --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/s3-envoy-config-access-policy-$RANDOM_STRING" \
    --role-name $S3_ACCESS_ROLE

echo $ENVOY_IRSA
echo "set -gx ENVOY_IRSA $ENVOY_IRSA" | tee -a $__fish_config_dir/config.fish

set tenants silo bridge pool
for tenant in $tenants
  set -gx NAMESPACE $tenant-ns
  set -gx SA_NAME $tenant-sa

  echo "Creating DynamoDB / Bedrock Access Role in IAM"
  set -gx CHATBOT_ACCESS_ROLE $EKS_CLUSTER-$tenant-chatbot-access-role-$RANDOM_STRING
  set -gx CHATBOT_IRSA $(
  envsubst < iam/chatbot-access-role-trust-policy.json \
  | xargs -J{} -0 aws iam create-role \
  --role-name $CHATBOT_ACCESS_ROLE \
  --assume-role-policy-document {} \
  --query 'Role.Arn' \
  --output text
  )
  echo "Attaching S3 Bucket and DynamoDB policy to Chatbot Access Role"
  aws iam attach-role-policy \
      --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/s3-contextual-data-access-policy-$tenant-$RANDOM_STRING \
      --role-name $CHATBOT_ACCESS_ROLE

  aws iam attach-role-policy \
      --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/dynamodb-access-policy-$tenant-$RANDOM_STRING \
      --role-name $CHATBOT_ACCESS_ROLE
end
