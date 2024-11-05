FROM google/cloud-sdk:latest

ARG lang
ARG ver

WORKDIR /home/asm

ENV LANG ${lang}
ENV LANGUAGE ${lang}
ENV LC_ALL ${lang}
ENV DEBIAN_FRONTEND = noninter active

RUN apt -y update && apt -y upgrade && \
    apt -y install kubectl \
        git \
        gawk \
        curl \
        grep \
        sed \
        netcat-openbsd \
        jq && \
    curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_${ver} > asmcli && \
    chmod +x asmcli

ENTRYPOINT bash