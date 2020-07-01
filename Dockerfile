FROM alpine:3.12.0
LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/leto1210/docker-dnsmasq"
# webproc release settings
ENV WEBPROC_VERSION=0.4.0
ENV WEBPROC_URL=https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz
# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add dnsmasq \
	&& apk add --no-cache --virtual .build-deps curl
RUN curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc \
	&& apk del .build-deps
#configure dnsmasq
run mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf

#run!
ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
