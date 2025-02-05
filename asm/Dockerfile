FROM google/cloud-sdk:latest

SHELL ["/bin/bash", "-c"]

ARG lang
ARG ver
ARG credentials
ARG HPATH

WORKDIR ${HPATH}

ENV LANG ${lang}
ENV DEBIAN_FRONTEND noninteractive
ENV GOOGLE_APPLICATION_CREDENTIALS ${credentials}

COPY ./asmcli-run.sh ./
COPY ./.config/application_default_credentials.json ${GOOGLE_APPLICATION_CREDENTIALS}

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install kubectl \
        git \
        gawk \
        curl \
        grep \
        sed \
        netcat-openbsd \
        jq && \
    cat ${GOOGLE_APPLICATION_CREDENTIALS} && \
    curl -L https://storage.googleapis.com/csm-artifacts/asm/asmcli_${ver} > asmcli && \
    chmod +x asmcli && \
    chmod +x asmcli-run.sh && \
    curl -sL https://istio.io/downloadIstioctl | sh - && \
    export PATH=${HPATH}.istioctl/bin:${HPATH}

ENTRYPOINT gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS && ./asmcli-run.sh