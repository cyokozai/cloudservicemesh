FROM google/cloud-sdk:latest

ARG lang
ARG ver
ARG credentials

WORKDIR /home/asm

ENV LANG ${lang}
ENV LANGUAGE ${lang}
ENV LC_ALL ${lang}
ENV DEBIAN_FRONTEND=noninteractive
ENV GOOGLE_APPLICATION_CREDENTIALS=${credentials}

RUN apt -y update && apt -y upgrade && \
    apt -y install kubectl \
        git \
        gawk \
        curl \
        grep \
        sed \
        netcat-openbsd \
        jq && \
    curl -L https://storage.googleapis.com/csm-artifacts/asm/asmcli_${ver} > asmcli && \
    chmod +x asmcli

ENTRYPOINT bash