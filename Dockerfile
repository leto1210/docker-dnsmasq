FROM alpine:3.23.4

# Image metadata
LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="https://github.com/leto1210/docker-dnsmasq"
LABEL org.opencontainers.image.source="https://github.com/leto1210/docker-dnsmasq"
LABEL org.opencontainers.image.title="docker-dnsmasq"

# Web UI binary version (https://github.com/jpillora/webproc)
ENV WEBPROC_VERSION=0.4.0
ENV WEBPROC_URL=https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz

# Install runtime dependencies and download webproc.
# - dnsmasq: DNS forwarder / resolver
# - curl + gzip: fetch and extract webproc release artifact
RUN apk add --no-cache dnsmasq curl \
    && curl -sL --fail "$WEBPROC_URL" | gzip -d - > /usr/local/bin/webproc \
    && chmod +x /usr/local/bin/webproc \
    # Keep a minimal /etc/default/dnsmasq file for expected defaults
    && mkdir -p /etc/default/ \
    && echo "ENABLED=1" > /etc/default/dnsmasq \
    && echo "IGNORE_RESOLVCONF=yes" >> /etc/default/dnsmasq

# Default config shipped in the image (can be overridden with a bind mount)
COPY dnsmasq.conf /etc/dnsmasq.conf

# Expose DNS and the web UI port
EXPOSE 53/udp
EXPOSE 8080/tcp

# Start webproc in front of dnsmasq.
# webproc edits /etc/dnsmasq.conf and runs the command after "--".
ENTRYPOINT ["webproc", "--config", "/etc/dnsmasq.conf", "--", "dnsmasq", "--no-daemon"]
