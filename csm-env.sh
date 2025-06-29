#!/bin/bash

# This script initializes environment variables for Cloud Service Mesh (CSM) setup.
set_env() {
    echo "Setting up environment variables for Cloud Service Mesh..."

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

    # Set a Cloud DNS ID
    export CLOUD_DNS_ID="gke-csm-dns"
    # Set the DNS name for the cluster
    export DESCRIPTION="This DNS is used by Cloud Service Mesh"
    # Set the DNS name for the cluster
    export DNS_SUFFIX="handson.com"
    # Set the DNS name for the cluster
    export UNIQUE_CLUSTER_DOMAIN="csm.$DNS_SUFFIX"

    echo "Environment variables initialized."

    # Create the asmcli.env file
    cat <<EOF > ./asmcli.env
FLEET_PROJECT_ID="$FLEET_PROJECT_ID"
FLEET_PROJECT_NUMBER=$FLEET_PROJECT_NUMBER
CLUSTER_PROJECT_ID="$CLUSTER_PROJECT_ID"
NETWORK_PROJECT_ID="$NETWORK_PROJECT_ID"
FIREWALL="${NETWORK_PROJECT_ID}-fw"
REGION="$REGION"
LOCATION="$LOCATION"
CONTEXT=$CONTEXT
HPATH="$HPATH"
OUTPUT_DIR="$OUTPUT_DIR"
CREDENTIAL_PATH="$CREDENTIAL_PATH"
CLOUD_DNS_ID="$CLOUD_DNS_ID"
CLOUD_DNS_NAME="$CLOUD_DNS_ID.$DNS_SUFFIX"
CLOUD_DNS_ZONE="$CLOUD_DNS_ID"
CLOUD_DNS_ZONE_ID="$CLOUD_DNS_ID"
EOF

    if [ $? -eq 0 ]; then
        echo "./asm/asmcli.env file created."
        source ./asm/asmcli.env
        exit 0
    else
        echo "Error creating asmcli.env file."
        exit 1
    fi
}

# Check if the script is being sourced or executed
unset_env () {
    echo "Cleaning up environment variables..."

    unset FLEET_PROJECT_ID
    unset FLEET_PROJECT_NUMBER
    unset CLUSTER_PROJECT_ID
    unset NETWORK_PROJECT_ID
    unset FIREWALL
    unset REGION
    unset LOCATION
    unset CONTEXT
    unset HPATH
    unset OUTPUT_DIR
    unset CREDENTIAL_PATH
    unset CLOUD_DNS_ID
    unset CLOUD_DNS_NAME
    unset CLOUD_DNS_ZONE
    unset CLOUD_DNS_ZONE_ID
    unset UNIQUE_CLUSTER_DOMAIN
    unset DESCRIPTION

    echo "Environment variables have been unset."
}

# Entry point
if [[ "$1" == "-cleanup" ]]; then
  unset_env
else
  set_env
fi