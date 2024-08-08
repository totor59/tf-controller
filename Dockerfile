ARG VERSION=v0.16.0-rc.3
ARG BASE_IMAGE=ghcr.io/weaveworks/tf-runner:${VERSION}-base
FROM $BASE_IMAGE
ARG TARGETARCH=amd64

ENV OPENTOFU_VERSION="1.7.3"


# Switch to root to have permissions for operations
USER root

RUN wget https://github.com/moparisthebest/static-curl/releases/download/v8.7.1/curl-amd64 && \
    chmod +x ./curl-amd64

# Utiliser curl pour télécharger et installer OpenTofu
RUN ./curl-amd64 --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    chmod +x install-opentofu.sh && \
    sed -i "s/^DEFAULT_OPENTOFU_VERSION=.*/DEFAULT_OPENTOFU_VERSION=\"${OPENTOFU_VERSION}\"/" install-opentofu.sh && \
    ./install-opentofu.sh --install-method standalone && \
    rm -f install-opentofu.sh && \
    ls -la /opt/opentofu && \
    ln -fs /usr/local/bin/tofu /usr/local/bin/terraform

# Switch back to the non-root user after operations
USER 65532:65532