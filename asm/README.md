# asmcli install

macOSを前提に、クラスタの作成及びCSMのインストールから、サンプルアプリBookinfoの実装までを行なっていきます。

- `gcloud projects list`を実行しProject IDを調べる
    
    ```bash
    $ gcloud projects list
    PROJECT_ID        NAME              PROJECT_NUMBER
    hogehoge          hoge              XXXXXXXXXXXX
    ```
    
- `FLEET_PROJECT_ID`, `CLUSTER_PROJECT_ID` , `NETWORK_PROJECT_ID` , `REGION` をそれぞれ設定し、 `csm-env.sh` を実行して環境変数を設定する
    
    ```bash
    $ ./csm-env.sh
    Initializing environment variables...
    Enter FLEET_PROJECT_ID:   <FLEET_PROJECT_ID>
    Enter CLUSTER_PROJECT_ID: <CLUSTER_PROJECT_ID>
    Enter NETWORK_PROJECT_ID: <NETWORK_PROJECT_ID>
    Enter REGION:             <REGION (ex. asia-northeast1)>
    Updated property [core/project].
    Initializing asmctl configuration...
    Environment variables initialized.
    ./asm/asmcli.env file created.
    ```
    
    - `csm-env.sh`
        
        ```bash
        #!/bin/bash
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
        export HPATH=/home/asm/
        # Set the output directory for the generated files
        export OUTPUT_DIR=output
        
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
        EOF
        
        # Source the file
        source ./asm/asmcli.env
        
        if [ $? -eq 0 ]; then
            echo "./asm/asmcli.env file created."
            exit 0
        else
            echo "Error creating asmcli.env file."
            exit 1
        fi
        ```
        
    - 実行が完了すると、 `./asm/` 下に `asmcli.env` ファイルが生成される
    ※ 環境変数の設定がうまくいかない場合は `source ./asm/asmcli.env` を実行して現在のシェルに読み込み直してください

```shell
docker exec -it asmcli-runner ./asmcli-run.sh
```
