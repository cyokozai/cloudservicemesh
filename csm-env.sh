#!/bin/bash

# Check the OS & set the path to the credentials file
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux"
    export CREDENTIAL_PATH="$HOME/.config/gcloud/application_default_credentials.json"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running on macOS"
    export CREDENTIAL_PATH="$HOME/.config/gcloud/application_default_credentials.json"
else
    echo "Windows"
    export CREDENTIAL_PATH="%APPDATA%\gcloud\application_default_credentials.json"
fi

# Initialize environment variables
echo "Initializing environment variables..."

# Set the project ID
read -p "Enter FLEET_PROJECT_ID:   " FLEET_PROJECT_ID
read -p "Enter CLUSTER_PROJECT_ID: " CLUSTER_PROJECT_ID
read -p "Enter NETWORK_PROJECT_ID: " NETWORK_PROJECT_ID
read -p "Enter REGION:             " REGION

if [ -z "$FLEET_PROJECT_ID" ] || [ -z "$CLUSTER_PROJECT_ID" ] || [ -z "$NETWORK_PROJECT_ID" ] || [ -z "$REGION" ]; then
    echo "One or more required variables are not set. Exiting..."
    exit 1
fi

# Set the project ID for gcloud
gcloud config set project $FLEET_PROJECT_ID

# Fleet project number
export FLEET_PROJECT_NUMBER=$(gcloud projects describe $FLEET_PROJECT_ID --format="value(projectNumber)")
# Location (zone) of the cluster
export LOCATION=${REGION}-a
# Set the context
export CONTEXT="gke_${FLEET_PROJECT_ID}_${LOCATION}_${CLUSTER_PROJECT_ID}"

# Set the environment variables
echo "Initializing asmctl configuration..."

# Set the home path for Docker container
export HPATH="/home/asm/"
# Set the output directory for the generated files
export OUTPUT_DIR="output/"

echo "Environment variables initialized."

# Create the asmcli.env file
cat <<EOF > ./asm/asmcli.env
FLEET_PROJECT_ID=$FLEET_PROJECT_ID
FLEET_PROJECT_NUMBER=$FLEET_PROJECT_NUMBER
CLUSTER_PROJECT_ID=$CLUSTER_PROJECT_ID
NETWORK_PROJECT_ID=$NETWORK_PROJECT_ID
REGION=$REGION
LOCATION=$LOCATION
CONTEXT=$CONTEXT
HPATH=$HPATH
OUTPUT_DIR=$OUTPUT_DIR
CREDENTIAL_PATH=$CREDENTIAL_PATH
EOF

source ./asm/asmcli.env

if [ $? -eq 0 ]; then
    echo "./asm/asmcli.env file created."
    exit 0
else
    echo "Error creating asmcli.env file."
    exit 1
fi