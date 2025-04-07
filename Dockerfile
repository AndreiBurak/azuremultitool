FROM ubuntu:22.04
ENV TZ=Europe/Warsaw
WORKDIR /app
COPY /scripts .
# Set the system timezone by creating a symbolic link and updating the timezone file
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends curl wget git apt-transport-https \
    ca-certificates gnupg lsb-release unzip software-properties-common
RUN [ -x ./powershell.sh ] && ./powershell.sh
RUN [ -x ./azcli.sh ] && ./azcli.sh
RUN [ -x ./bicep.sh ] && ./bicep.sh
RUN pwsh -c "Install-Module -Name Az -Repository PSGallery -MinimumVersion  9.4.0 -Force" \
    && pwsh -c get-module -ListAvailable -Name Az
RUN command -v az >/dev/null 2>&1 && az extension add --name azure-devops && az bicep install
RUN apt-get upgrade --yes \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf ./powershell.sh ./azcli.sh ./bicep.sh \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*
