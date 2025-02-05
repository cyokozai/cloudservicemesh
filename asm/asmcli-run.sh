#!/bin/bash
# Set the path to the directory containing the asmcli binary

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
echo "ls ./$OUTPUT_DIR"
ls ./$OUTPUT_DIR
echo "-------------------------"

exit 0