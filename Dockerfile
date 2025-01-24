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
    software-properties-common
WORKDIR /app
COPY /scripts .
RUN ./powershell.sh && \
    ./armestimator.sh && \
    ./azcli.sh && \
    pwsh -c "Install-Module -Name Az -Repository PSGallery -Force" && \
    az extension add --name azure-devops
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -f armestimator.sh && \
    rm -f powershell.sh && \
    rm -f azcli.sh
LABEL Name=AzureMultiTool
LABEL Version=0.0.1
