# asmcli

- Download

  ```shell
  curl -L https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.23 > asmcli
  ```

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
