ARG VERSION=v0.16.0-rc.3
ARG BASE_IMAGE=ghcr.io/weaveworks/tf-runner:${VERSION}-base
FROM $BASE_IMAGE
ARG TARGETARCH=amd64

# Switch to root to have permissions for operations
USER root

RUN wget -O /tmp/curl.tar.gz https://curl.se/download/curl-7.79.1.tar.gz && \
    tar -xzvf /tmp/curl.tar.gz -C /tmp && \
    cd /tmp/curl-7.79.1 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    rm -rf /tmp/curl*

# Utiliser curl pour télécharger et installer OpenTofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    chmod +x install-opentofu.sh && \
    ./install-opentofu.sh --install-method standalone && \
    rm -f install-opentofu.sh && \
    ls -la /opt/opentofu && \
    ln -fs /opt/opentofu/opentofu /usr/local/bin/terraform

# Switch back to the non-root user after operations
USER 65532:65532