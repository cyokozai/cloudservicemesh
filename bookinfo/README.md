# asmcli

- Download

```shell
curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.23 > asmcli
```

- Validation

```shell
./asmcli validate \
  --project_id $FLEET_PROJECT_ID \
  --cluster_name $CLUSTER_PROJECT_ID \
  --cluster_location asia-northeast1-a \
  --fleet_id $FLEET_PROJECT_ID \
  --output_dir $DIR_PATH
```

- Installation

```shell
./asmcli install \
    --project_id $FLEET_PROJECT_ID \
    --cluster_name $CLUSTER_PROJECT_ID \
    --cluster_location asia-northeast1-a \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir /Users/yusuke/internship/projects/csm-handson/bookinfo/asm-output
```
