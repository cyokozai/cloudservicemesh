# asmcli on Docker

## Deploy

### Local

- `cd asm`
- `docker compose up d`

### Attach Shell

- Run gcloud command

    ```shell
    gcloud auth login --no-launch-browser
    ```

- Run this command

    ```shell
    gcloud config set project $FLEET_PROJECT_ID
    ```

- Get credential

    ```shell
    gcloud container clusters get-credentials $CLUSTER_PROJECT_ID \
        --region=$LOCATION \
        --project $FLEET_PROJECT_ID
    ```

  - Confirm

    ```shell
    kubectl cluster-info
    ```

- Switch to context

    ```shell
    kubectl config use-context gke_sreake-intern_asia-northeast1-a_$CLUSTER_PROJECT_ID
    ```

- Admin binding 

    ```shell
    kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=<YOUR EMAIL>
    ```

## Validate

- Run `asmcli validate`

    ```shell
    ./asmcli validate \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $OUTPUT_DIR
    ```

- Run `asmcli install`

    ```shell
    ./asmcli install \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location $LOCATION \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir $OUTPUT_DIR \
    --enable_all \
    --ca mesh_ca
    ```
