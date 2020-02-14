FROM buildpack-deps:jessie-curl
LABEL maintainer "Gerardo Junior <me@gerardo-junior.com>"

ENV USER keybase
ENV WORKDIR '/src'

# Install dependencies
RUN	set -xe && \
  	apt-get update && \
	apt-get install -y fuse \
	                   libappindicator1 \
	                   sudo \
	                   --no-install-recommends 

# Get and verify Keybase.io's code signing key
RUN set -xe && \
    curl https://keybase.io/docs/server_security/code_signing_key.asc | gpg --import && \
    gpg --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 && \
    curl -O https://prerelease.keybase.io/keybase_amd64.deb.sig && \
    curl -O https://prerelease.keybase.io/keybase_amd64.deb && \
    gpg --verify keybase_amd64.deb.sig keybase_amd64.deb && \
    dpkg -i keybase_amd64.deb && \
    apt-get install -y && \
    run_keybase && \
    rm -f keybase_*

RUN set -xe && \
	useradd  -g $USER -u 1000 $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default

# Add tools script
COPY ./tools /opt/tools
RUN /bin/chmod -R +x /opt/tools/
ENV PATH ${PATH}:/opt/tools

# Set image settings
VOLUME [${WORKDIR}]
WORKDIR ${WORKDIR}
USER ${USER}
ENTRYPOINT ["/bin/sh", "/opt/tools/entrypoint.sh"]
