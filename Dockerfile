FROM alpine:3.23.3

LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="https://github.com/leto1210/docker-dnsmasq"

# webproc release settings
ENV WEBPROC_VERSION=0.4.0
ENV WEBPROC_URL=https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz

# Fetch dnsmasq and webproc binary, configure, and cleanup
RUN apk add --no-cache dnsmasq curl \
    && curl -sL --fail $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
    && chmod +x /usr/local/bin/webproc \
    && mkdir -p /etc/default/ \
    && echo "ENABLED=1" > /etc/default/dnsmasq \
    && echo "IGNORE_RESOLVCONF=yes" >> /etc/default/dnsmasq \
    && rm -rf /var/lib/apk/* /tmp/* /var/cache/apk/*

COPY dnsmasq.conf /etc/dnsmasq.conf

# Expose dnsmasq default port
EXPOSE 53/udp

# Run!
ENTRYPOINT ["webproc", "--config", "/etc/dnsmasq.conf", "--", "dnsmasq", "--no-daemon"]
