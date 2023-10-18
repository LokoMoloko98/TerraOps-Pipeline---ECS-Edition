#!/bin/bash
yum update -y
sysctl -w vm.max_map_count=262144
aws ecs put-account-setting --region eu-west-1 --name awsvpcTrunking  -value enabled
echo ECS_CLUSTER=terraops-cluster >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
yum install python3 -y
yum install python3-pip -y
yum install git -y
pip3 install git-remote-codecommit

# Extract information about the Instance
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $${TOKEN}" -v http://169.254.169.254/latest/meta-data/instance-id`


DOMAIN_NAME="moloko-mokubedi.co.za"
LOWERCASE_TENANT_ID="terraops"
RECORD_NAME="$LOWERCASE_TENANT_ID.$DOMAIN_NAME."
HOSTED_ZONE_ID="Z0813318CUEYPH91ZE2Q" # replace with your Route53 Hosted Zone ID
TTL=300 # time to live for the record in seconds


# Get the IP address of the EC2 instance
IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/ -H "X-aws-ec2-metadata-token: $${TOKEN}")

# Check if the A record already exists
EXISTING_RECORD=$(aws route53 list-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --query "ResourceRecordSets[?Name=='$RECORD_NAME'].ResourceRecords[].Value | [0]" --output text)


# If the record exists and the IP is different, or if the record does not exist, upsert the record
if [ "$EXISTING_RECORD" != "$IP" ]; then
    JSON=$(cat <<EOM
{
    "Comment": "Update record",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "$RECORD_NAME",
                "Type": "A",
                "TTL": $TTL,
                "ResourceRecords": [
                    {
                        "Value": "$IP"
                    }
                ]
            }
        }
    ]
}
EOM
)
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$JSON"
fi


cd /
git clone https://github.com/LokoMoloko98/Infrastructure-Testing-Nginx-Server-Container.git
chmod 777 Infrastructure-Testing-Nginx-Server-Container
chmod 777 Infrastructure-Testing-Nginx-Server-Container/* 
cd /Infrastructure-Testing-Nginx-Server-Container
./build_image.sh



