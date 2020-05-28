#!/usr/bin/env bash

pip install -r ../src/requirements.txt -t python/lib/python3.6/site-packages/
zip -r lambda-layer.zip python

# ideally this would be done with terraform
# but it's annoying I have to build this within a lambci/lambda:python-3.6 docker image
# it's a two step process, lambda layer needs to exist before lambda can be deployed
export AWS_DEFAULT_REGION=ap-southeast-2
export AWS_REGION=ap-southeast-2
aws s3 cp lambda-layer.zip s3://insar-atmospheric-correction-dev
aws lambda publish-layer-version --layer-name insar-atmospheric-correction-python36 --content S3Bucket=insar-atmospheric-correction-dev,S3Key=lambda/lambda-layer.zip --compatible-runtimes python3.6
