# `asmcli install`

macOSを前提に、クラスタの作成及びCSMのインストールから、サンプルアプリBookinfoの実装までを行なっていきます。

- `docker compose` を実行し、`asmcli` を実行する Linux コンテナを作成する
- 以下のコマンドを実行してクラスタに Anthos Service Mesh のインストールを行う

    ```shell
    docker exec -it asmcli-runner ./asmcli-run.sh
    ```
