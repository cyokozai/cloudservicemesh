#!/bin/bash

# Authenticate with gcloud
gcloud auth login --no-launch-browser

# Set the project ID
gcloud config set project $FLEET_PROJECT_ID

# Gwt the project credentials
gcloud clusters get-credentials $CLUSTER_PROJECT_ID --regino $REGION --project $FLEET_PROJECT_ID

# Validate Anthos Service Mesh
echo "Validating Anthos Service Mesh"

./asmcli validate \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $HPATH/$OUTPUT_DIR

echo "Validation complete"

# Install Anthos Service Mesh
echo "Installing Anthos Service Mesh"

./asmcli install \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $HPATH/$OUTPUT_DIR \
    --enable_all \
    --ca mesh_ca

echo "-------------------------"
echo "ls ./"
ls ./
echo "-------------------------"
echo "ls .$OUTPUT_DIR"
ls .$OUTPUT_DIR
echo "-------------------------"

exit 0