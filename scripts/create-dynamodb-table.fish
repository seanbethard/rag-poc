#!/usr/bin/env fish
source $__fish_config_dir/config.fish

set -x tenants silo bridge pool

for tenant in $tenants
    set -x TABLE_NAME Sessions_"$tenant"_"$RANDOM_STRING"
    echo "Creating DynamoDB table $TABLE_NAME"
    set DDB_TABLE $(aws dynamodb create-table \
                        --table-name $TABLE_NAME \
                        --attribute-definitions \
                            AttributeName=TenantId,AttributeType=S \
                        --provisioned-throughput \
                            ReadCapacityUnits=5,WriteCapacityUnits=5 \
                        --key-schema \
                            AttributeName=TenantId,KeyType=HASH \
                            --table-class STANDARD
	)
    set -x TABLE_NAME ChatHistory_"$tenant"_"$RANDOM_STRING"
    echo "Creating DynamoDB table $TABLE_NAME"
    set DDB_TABLE $(aws dynamodb create-table \
                        --table-name $TABLE_NAME \
                        --attribute-definitions \
                            AttributeName=SessionId,AttributeType=S \
                        --provisioned-throughput \
                            ReadCapacityUnits=5,WriteCapacityUnits=5 \
                        --key-schema \
                            AttributeName=SessionId,KeyType=HASH \
                        --table-class STANDARD
        )
end
