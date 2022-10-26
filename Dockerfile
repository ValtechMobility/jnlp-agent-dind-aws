FROM golang:1.15-alpine3.14 as builder
ARG VERSION=1.2.339.0
RUN set -ex && apk add --no-cache make git gcc libc-dev curl bash && \
    curl -sLO https://github.com/aws/session-manager-plugin/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /go/src/github.com && \
    tar xzf ${VERSION}.tar.gz && \
    mv session-manager-plugin-${VERSION} /go/src/github.com/session-manager-plugin && \
    cd /go/src/github.com/session-manager-plugin && \
    echo ${VERSION} > VERSION && \
    sed -i s/1.2.0.0/${VERSION}/g /go/src/github.com/session-manager-plugin/src/version/version.go && \
    gofmt -w src && make checkstyle && \
    make build-linux-amd64

FROM jenkins/inbound-agent:alpine as jnlp

FROM docker:20.10.21-dind-alpine3.16

RUN apk add --no-cache openjdk11-jre git curl bash aws-cli
RUN curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
RUN ln -s /usr/local/bin/helm /usr/local/bin/helm3

COPY --from=builder /go/src/github.com/session-manager-plugin/bin/linux_amd64_plugin/ /usr/bin

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
