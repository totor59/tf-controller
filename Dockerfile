ARG VERSION=v0.16.0-rc.3
ARG BASE_IMAGE=ghcr.io/weaveworks/tf-runner:${VERSION}-base
FROM $BASE_IMAGE
ARG TARGETARCH=amd64

# Switch to root to have permissions for operations
USER root

RUN wget --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh && \
    # Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh
    # Grant execution permissions:
    chmod +x install-opentofu.sh && \
    # Please inspect the downloaded script at this point.
    # Run the installer:
    ./install-opentofu.sh --install-method standalone && \
    # Remove the installer:
    rm -f install-opentofu.sh && \
    ls -la /opt/opentofu && \
    ln -fs /opt/opentofu/opentofu /usr/local/bin/terraform

# Switch back to the non-root user after operations
USER 65532:65532