#!/bin/bash

# Edit these four variables
IP_ADDRESS=""
PASSWORD="splk"
TA_NAME=""
TA_VERSION="1.0.0"

echo "Building Splunk Add-On with UCC"
ucc-gen build --ta-version=${TA_VERSION}
echo "Building Splunk Add-On with UCC - Finished!"

echo "Delpoying Splunk Add-On to Remote"
read -p "Are you running this script for the first time? If so, we need to set the right permission for the /opt/splunk/etc/apps/ folder. Want to do it now? [Type 'y' or 'Y'] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo "Setting right permissions...."
    `sshpass -p ${PASSWORD} ssh splunker@${IP_ADDRESS} -T "sudo chmod 777 /opt/splunk/etc/apps/"`
else
    echo ""
fi

echo "Syncing TA..."
`sshpass -p ${PASSWORD} rsync -r ./output/${TA_NAME}/ splunker@${IP_ADDRESS}:/opt/splunk/etc/apps/${TA_NAME}`

echo "Delpoying Splunk Add-On to Remote - Finished"
