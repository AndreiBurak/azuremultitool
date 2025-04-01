FROM ubuntu:22.04
ENV TZ=Etc/Warsaw
WORKDIR /app
COPY /scripts .
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends curl wget git apt-transport-https \
    ca-certificates gnupg lsb-release unzip software-properties-common \
    && ./powershell.sh \
    && ./azcli.sh \
    && ./bicep.sh \
    && pwsh -c "Install-Module -Name Az -Repository PSGallery -Force" \
    && az extension add --name azure-devops && az bicep install \
    && apt-get upgrade --yes \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf ./*.sh \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/
