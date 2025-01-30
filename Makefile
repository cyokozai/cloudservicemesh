# Initialize environment variables
init:
	@echo "Initializing environment variables..."

	#------ DO NOT COMMIT YOUR CREDENTIALS ----------#

	@export FLEET_PROJECT_ID=<FLEET_PROJECT_ID>
	@export CLUSTER_PROJECT_ID=<CLUSTER_PROJECT_ID>
	@export NETWORK_PROJECT_ID=<NETWORK_PROJECT_ID>

	#------ DO NOT COMMIT YOUR CREDENTIALS ----------#

	@export REGION=asia-northeast1
	@export LOCATION=asia-northeast1-a
	@export CONTEXT="gke_${FLEET_PROJECT_ID}_${LOCATION}_${CLUSTER_PROJECT_ID}"

	@echo "Initializing asmctl configuration..."

	@export HPATH=/home/asm/
	@export OUTPUT_DIR=output

	@echo "Environment variables initialized."

	@cat <<EOF > ./asm/asmcli.env
	FLEET_PROJECT_ID=$FLEET_PROJECT_ID
	CLUSTER_PROJECT_ID=$CLUSTER_PROJECT_ID
	NETWORK_PROJECT_ID=$NETWORK_PROJECT_ID
	REGION=$REGION
	LOCATION=$LOCATION
	CONTEXT=$CONTEXT
	HPATH=$HPATH
	OUTPUT_DIR=$OUTPUT_DIR
	EOF

	@echo "./asm/asmcli.env file created."