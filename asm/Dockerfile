FROM google/cloud-sdk:latest

ARG lang
ARG ver
ARG credentials
ARG HPATH

ENV LANG ${lang}
ENV LANGUAGE ${lang}
ENV LC_ALL ${lang}
ENV DEBIAN_FRONTEND noninteractive
ENV GOOGLE_APPLICATION_CREDENTIALS ${credentials}

WORKDIR ${HPATH}

COPY ./asmcli-run.sh ./csm-env.sh ./

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install kubectl \
        git \
        gawk \
        curl \
        grep \
        sed \
        netcat-openbsd \
        jq && \
    chmod +x asmcli-run.sh && \
    chmod +x csm-env.sh && \
    bash csm-env.sh && \
    curl -L https://storage.googleapis.com/csm-artifacts/asm/asmcli_${ver} > asmcli && \
    chmod +x asmcli && \
    curl -sL https://istio.io/downloadIstioctl | sh - && \
    export PATH=${HPATH}/.istioctl/bin:${HPATH}

CMD ["bash", "asmcli-run.sh"]