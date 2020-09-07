#!/bin/sh 
set -x
#export AWS_DEFAULT_OUTPUT="text"
#export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

export AWS_DEFAULT_REGION=ap-south-1
export STACK=$1-api-gateway
export BUCKET=uc-deploy-api-gateway-$1

echo "$DOMAIN_URL $USER_URL $1"

DOMAIN_URL="http://ucbeanstalkapplications-stage.eba-emtxm8qt.ap-south-1.elasticbeanstalk.com"
#ORIGIN_URL="https://$1-ui.udchalo.com"
echo $ORIGIN_URL

#sed -i='' "s@<DOMAIN_URL>@$DOMAIN_URL@g" swagger.yaml
#sed -i='' "s@<USER_URL>@$USER_URL@g" swagger.yaml
#sed -i -e "s@<ORIGIN_URL>@$ORIGIN_URL@g" swagger.yaml
#sed -i='' "s/<NODE_ENV>/$1/g" swagger.yaml
sed -i='' "s/<NODE_ENV>/$1/g" template.yaml

#aws s3 mb s3://$BUCKET

# Uploads files to S3 bucket and creates CloudFormation template
sam package --template-file template.yaml --s3-bucket $BUCKET --output-template-file package.yaml

# Deploys your stack   

sam deploy --template-file package.yaml --stack-name $STACK --capabilities CAPABILITY_IAM --no-fail-on-empty-changeset



# Delete CloudFormation Stack
#aws cloudformation delete-stack --stack-name $STACK
