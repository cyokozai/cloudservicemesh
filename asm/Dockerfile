FROM google/cloud-sdk:latest

SHELL ["/bin/bash", "-c"]

ARG lang
ARG ver
ARG credentials
ARG hpath
ARG jsonfile

WORKDIR ${hpath}

ENV LANG ${lang}
ENV DEBIAN_FRONTEND noninteractive

COPY ./asmcli-run.sh ./

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install kubectl \
        git \
        gawk \
        curl \
        grep \
        sed \
        netcat-openbsd \
        jq \
        coreutils && \
    curl -L https://storage.googleapis.com/csm-artifacts/asm/asmcli_${ver} > asmcli && \
    chmod +x asmcli && \
    curl -sL https://istio.io/downloadIstioctl | sh - && \
    export PATH="${hpath}/.istioctl/bin:${hpath}:${PATH}" && \
    chmod +x asmcli-run.sh