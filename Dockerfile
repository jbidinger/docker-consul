FROM alpine:3.4

ENV CONSUL_VERSION 0.7.1
ENV CONSUL_SHA256 5dbfc555352bded8a39c7a8bf28b5d7cf47dec493bc0496e21603c84dfe41b4b
ENV GLIBC_VERSION "2.23-r1"

RUN apk --update add curl ca-certificates && \
    curl -Ls https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk > /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm -rf /tmp/glibc-${GLIBC_VERSION}.apk /var/cache/apk/*
ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 \
  && sha256sum -c /tmp/consul.sha256 \
  && cd /bin \
  && unzip /tmp/consul.zip \
  && chmod +x /bin/consul \
  && rm /tmp/consul.zip

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip /tmp/ui.zip
RUN mkdir /ui \
  && cd /ui   \
  && unzip /tmp/ui.zip

RUN mkdir /etc/consul.d
ADD agent.json             /etc/consul.d/agent.json
ADD cluster.json           /etc/consul.d/cluster.json
ADD service.consul-ui.json /etc/consul.d/service.consul-ui.json
#ADD service.atl-ntp.json   /etc/consul.d/service.atl-ntp.json

ENTRYPOINT ["/bin/consul"]
