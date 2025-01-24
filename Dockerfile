FROM ubuntu:22.04
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    curl=7.81.0 \
    wget=1.21.2 \
    git=2.34.1 \
    apt-transport-https=2.4.13 \
    ca-certificates=6.8.0 \
    gnupg=2.2.27 \
    lsb-release=11.1 \
    unzip=0.7-3 \
    software-properties-common=0.99.22.9 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY /scripts .
RUN ./powershell.sh && \
    ./armestimator.sh && \
    ./azcli.sh && \
    pwsh -c "Install-Module -Name Az -Repository PSGallery -Force" && \
    az extension add --name azure-devops
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -f ./powershell.sh && \
    rm -f ./armestimator.sh && \
    rm -f ./azcli.sh && \
    rm -rf /var/lib/apt/ && \
    rm -rf /var/lib/dpkg/ && \
    rm -rf /var/lib/cache/ && \
    rm -rf /var/lib/log/
