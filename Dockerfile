FROM ubuntu:22.04
RUN apt update &&  apt install -y \
    curl \
    wget \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    software-properties-common
COPY /scripts .
RUN ./powershell.sh && \
    ./armestimator.sh && \
    ./azcli.sh
RUN pwsh -c "Install-Module -Name Az -Repository PSGallery -Force"
RUN az extension add --name azure-devops
RUN apt clean autoclean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -f armestimator.sh && \
    rm -f powershell.sh && \
    rm -f azcli.sh
WORKDIR /home
LABEL Name=AzureMultiTool
LABEL Version=0.0.1
