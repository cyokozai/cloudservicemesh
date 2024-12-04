FROM google/cloud-sdk:latest

ARG lang
ARG ver
ARG credentials
ARG HPATH

WORKDIR ${HPATH}

ENV LANG ${lang}
ENV LANGUAGE ${lang}
ENV LC_ALL ${lang}
ENV DEBIAN_FRONTEND noninteractive
ENV GOOGLE_APPLICATION_CREDENTIALS ${credentials}

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install kubectl \
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
    export PATH=$HPATH/.istioctl/bin:$HPATH

COPY ./asmcli-run.sh ./

CMD ["bash", "asmcli-run.sh"]