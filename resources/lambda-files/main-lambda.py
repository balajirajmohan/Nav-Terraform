import json
import boto3

def lambda_handler(event, context):
    s3_resource = boto3.resource('s3')
    mybucket = s3_resource.Bucket ('navvis-demo-bucket')
    key= 'buildjars/*-SNAPSHOT.jar'

    sns_client = boto3.client('sns')
    #Adding the message attributes

    obj1 = client.get_object(Bucket='navvis-demo-bucket', Key='buildjars/*-notdefault-SNAPSHOT.jar')
    obj2 = client.get_object(Bucket='navvis-demo-bucket', Key='buildjars/*-default-SNAPSHOT.jar')

    if obj1:
        print ('I am going to send notification to topic that can deploy from different S3 bucket')
        sns_client.publish(TopicArn='arn of the non-default topic',Message='non-default jar')

    elif obj2:
        print ( 'I am going to send notification to topic tjat supports deployment from default s3 bucket')
        sns_client.publish(TopicArn='arn of the default topic',Message='default jar')
