#!/bin/bash
# Initialize environment variables
echo "Initializing environment variables..."

# ------ DO NOT COMMIT YOUR CREDENTIALS ------ #

export FLEET_PROJECT_ID=sreake-intern
export CLUSTER_PROJECT_ID=yinoue-csm-bookinfo
export NETWORK_PROJECT_ID=yinoue-csm-vpc

# ------ DO NOT COMMIT YOUR CREDENTIALS ------ #

export REGION=asia-northeast1
export LOCATION=asia-northeast1-a
export CONTEXT="gke_${FLEET_PROJECT_ID}_${LOCATION}_${CLUSTER_PROJECT_ID}"

echo "Initializing asmctl configuration..."

export HPATH=/home/asm/
export OUTPUT_DIR=output

echo "Environment variables initialized."

cat <<EOF > ./asm/asmcli.env
export FLEET_PROJECT_ID=$FLEET_PROJECT_ID
export CLUSTER_PROJECT_ID=$CLUSTER_PROJECT_ID
export NETWORK_PROJECT_ID=$NETWORK_PROJECT_ID
export REGION=$REGION
export LOCATION=$LOCATION
export CONTEXT=$CONTEXT
export HPATH=$HPATH
export OUTPUT_DIR=$OUTPUT_DIR
EOF

echo "./asm/asmcli.env file created."