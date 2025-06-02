FROM google/cloud-sdk:latest

SHELL ["/bin/bash", "-c"]

ARG lang
ARG ver
ARG hpath
ARG jsonfile

WORKDIR ${hpath}

ENV LANG ${lang}
ENV DEBIAN_FRONTEND noninteractive

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
    chmod +x asmcli && \
    curl -sL https://istio.io/downloadIstioctl | sh - && \
    export PATH=${HPATH}/.istioctl/bin:${HPATH}

COPY ./asmcli-run.sh ./

RUN chmod +x ./asmcli-run.sh

CMD [ "bash" ]