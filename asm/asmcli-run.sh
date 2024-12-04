#!/bin/bash
# Set the path to the directory containing the asmcli binary

# Validate Anthos Service Mesh
echo "Validating Anthos Service Mesh"
./asmcli validate \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $PATH/output
echo "Validation complete"

# Install Anthos Service Mesh
echo "Installing Anthos Service Mesh"
./asmcli install \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $PATH/output \
    --enable_all \
    --ca mesh_ca
echo "Installation complete"