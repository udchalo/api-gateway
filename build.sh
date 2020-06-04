#!/bin/bash

#export AWS_DEFAULT_OUTPUT="text"
#export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

export AWS_DEFAULT_REGION=ap-south-1
export STACK=$NODE_ENV-api-gateway
export BUCKET=uc-api-gateway-$NODE_ENV


# Replace the variable with the real value

sed -i=' ' "s/<NODE_ENV>/$NODE_ENV/g" swagger.yaml
sed -i=' ' "s/<DOMAIN_URL>/$DOMAIN_URL/g" swagger.yaml
sed -i=' ' "s/<USER_URL>/$USER_URL_URL/g" swagger.yaml
#sed -i=' ' "s/<STACK>/$STACK/g" template.yaml
sed -i=' ' "s/<NODE_ENV>/$NODE_ENV/g" template.yaml

aws s3 mb s3://$BUCKET

# Uploads files to S3 bucket and creates CloudFormation template
sam package --template-file template.yaml --s3-bucket $BUCKET --output-template-file package.yaml

# Deploys your stack   
sam deploy --template-file package.yaml --stack-name $STACK --capabilities CAPABILITY_IAM



# Delete CloudFormation Stack
#aws cloudformation delete-stack --stack-name $STACK
