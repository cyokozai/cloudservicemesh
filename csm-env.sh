#!/bin/bash
# Initialize environment variables
echo "Initializing environment variables..."

read -p "Enter FLEET_PROJECT_ID:   " FLEET_PROJECT_ID
read -p "Enter CLUSTER_PROJECT_ID: " CLUSTER_PROJECT_ID
read -p "Enter NETWORK_PROJECT_ID: " NETWORK_PROJECT_ID
read -p "Enter REGION:             " REGION

export LOCATION=${REGION}-a
export CONTEXT="gke_${FLEET_PROJECT_ID}_${LOCATION}_${CLUSTER_PROJECT_ID}"

echo "Initializing asmctl configuration..."

export HPATH=/home/asm/
export OUTPUT_DIR=output

echo "Environment variables initialized."

cat <<EOF > ./asm/asmcli.env
FLEET_PROJECT_ID=$FLEET_PROJECT_ID
CLUSTER_PROJECT_ID=$CLUSTER_PROJECT_ID
NETWORK_PROJECT_ID=$NETWORK_PROJECT_ID
REGION=$REGION
LOCATION=$LOCATION
CONTEXT=$CONTEXT
HPATH=$HPATH
OUTPUT_DIR=$OUTPUT_DIR
EOF

echo "./asm/asmcli.env file created."
source ./asm/asmcli.env