#!/bin/bash

# Authenticate with gcloud
gcloud auth login --no-launch-browser

# Set the project ID
gcloud config set project $FLEET_PROJECT_ID

# Get the project credentials
gcloud container clusters get-credentials $CLUSTER_PROJECT_ID --location $REGION --project $FLEET_PROJECT_ID

# Install Anthos Service Mesh
echo "Installing Anthos Service Mesh"

./asmcli install \
    --project_id "$FLEET_PROJECT_ID" \
    --cluster_name "$CLUSTER_PROJECT_ID" \
    --cluster_location "$REGION" \
    --fleet_id "$FLEET_PROJECT_ID" \
    --output_dir "${HPATH}${OUTPUT_DIR}" \
    --enable_all \
    --ca mesh_ca

  --project_id $FLEET_PROJECT_ID \
  --cluster_name $CLUSTER_PROJECT_ID \
  --cluster_location $REGION \
  --fleet_id $FLEET_PROJECT_ID \
  --output_dir ./asm-output \
  --enable_all \
  --ca mesh_ca \
  --channel rapid

  

if [ $? -ne 0 ]; then
    echo "Failed to install Anthos Service Mesh"
    exit 1
else
    echo "Anthos Service Mesh installed successfully"
fi

# Validate Anthos Service Mesh
echo "Validating Anthos Service Mesh"

./asmcli validate \
    --project_id "$FLEET_PROJECT_ID" \
    --cluster_name "$CLUSTER_PROJECT_ID" \
    --cluster_location "$REGION" \
    --fleet_id "$FLEET_PROJECT_ID" \
    --output_dir "${HPATH}${OUTPUT_DIR}"

if [ $? -ne 0 ]; then
    echo "Failed to validate Anthos Service Mesh"
    exit 1
else
    echo "Anthos Service Mesh validated successfully"
    echo "-------------------------"
    echo "ls ./"
    ls ./
    echo "-------------------------"
    echo "ls .$OUTPUT_DIR"
    ls .$OUTPUT_DIR
    echo "-------------------------"
fi

exit 0