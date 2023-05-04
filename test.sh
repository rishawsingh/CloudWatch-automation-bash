#!/bin/bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
apt-get update

JSON='{
 "agent": {
  "metrics_collection_interval": 60,
  "run_as_user": "cwagent"
 },
 "metrics": {
  "aggregation_dimensions": [
   [
    "InstanceId"
   ]
  ],
  "metrics_collected": {
   "mem": {
    "measurement": [
     "mem_used_percent"
    ],
    "metrics_collection_interval": 60
   }
  }
 }
}'

echo "$JSON" > /opt/aws/amazon-cloudwatch-agent/bin/config.json

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
