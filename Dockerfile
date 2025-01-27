FROM ubuntu:22.04
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY /scripts .
RUN ./powershell.sh && \
    ./armestimator.sh && \
    ./azcli.sh
RUN pwsh -c "Install-Module -Name Az -Repository PSGallery -Force"
RUN az extension add --name azure-devops
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf ./*.sh && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
