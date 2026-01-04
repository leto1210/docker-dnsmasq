FROM alpine:3.23.2

LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="https://github.com/leto1210/docker-dnsmasq"

# webproc release settings
ENV WEBPROC_VERSION=0.4.0
ENV WEBPROC_URL=https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz

# Fetch dnsmasq and webproc binary
RUN apk add --no-cache dnsmasq curl \
    && curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
    && chmod +x /usr/local/bin/webproc

# Réduire la taille de l'image
RUN rm -rf /var/lib/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Configure dnsmasq
RUN mkdir -p /etc/default/ \
    && echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf

# Expose dnsmasq default port
EXPOSE 53/udp

# Run!
ENTRYPOINT ["webproc", "--config", "/etc/dnsmasq.conf", "--", "dnsmasq", "--no-daemon"]
